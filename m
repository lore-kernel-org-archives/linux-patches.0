Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26453272E53;
	Thu, 20 Aug 2026 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243488; cv=none; b=Er249d3WhEnjylKGlW6L5OJwIXag+bnjZdXvx153glnTYA0y3KMyU3fqsYYQhQO3iIbytygMxC44HTFidGY7XDlaDE3jBHFKQMZcRsmxyAv5f/Ff8q5z+jcs900gIdBf3QWrFdKqbz4Ab6LGw77rDqeFwZdrYp0kU8ir+RHRD9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243488; c=relaxed/simple;
	bh=yCAGt4X2EFXAM47z6n4JtHkOwSf5SeoQ8PUy4lengWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kh5LepDbKaHjWOtVRuT/B3IfAh4ICoezxpikGqdEzYu4kUEIMf8u7zjOmW0oz8xShmQC5D9WzpCGadWFif80qeiOxpbSeM2L7qA5S5t5U6pFir8vVmtFr766ZPcTdA0yk4BSLpJjGttGfW6dWo08VMs9botAu8JKRddMxnLI344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/f/ZeRb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/f/ZeRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E07B1F000E9;
	Thu, 20 Aug 2026 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243487;
	bh=ofeQExH73F9qv/ZF8XyS8Az0uuDOzqFXm7geFhPJB0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/f/ZeRbZexX37VwfiPJWKXFQ3J6ldRf18TGA40m9eAd5g2CL0OtEKkrc0E7LVwkr
	 18rQKW7OSKD82+t5clVLhbLTjK02nQDUXNmtB6u9fo4QxzKWLyWlQAl3ZVo49shQzN
	 jWtEswAycmnDgfUFcmXYX75AI8lPZLIdK3tXCbR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <asmadeus@codewreck.org>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/272] 9p: skip nlink update in cacheless mode to fix WARN_ON
Date: Thu, 20 Aug 2026 16:54:54 +0200
Message-ID: <20260820145234.569285841@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 574aa0b4799470ac814479f1138d19efe6262255 ]

v9fs_dec_count() unconditionally calls drop_nlink() on regular files,
even when the inode's nlink is already zero. In cacheless mode the
client refetches inode metadata from the server (the source of truth)
on every operation, so by the time v9fs_remove() returns, the locally
cached nlink may already reflect the post-unlink value:

  1. Client initiates unlink, server processes it and sets nlink to 0
  2. Client refetches inode metadata (nlink=0) before unlink returns
  3. Client's v9fs_remove() completes successfully
  4. Client calls v9fs_dec_count() which calls drop_nlink() on nlink=0

This race is easily triggered under heavy unlink workloads, such as
stress-ng's unlink stressor, producing the following warning:

  WARNING: fs/inode.c:417 at drop_nlink+0x4c/0xc8
  Call trace:
   drop_nlink+0x4c/0xc8
   v9fs_remove+0x1e0/0x250 [9p]
   v9fs_vfs_unlink+0x20/0x38 [9p]
   vfs_unlink+0x13c/0x258
   ...

In cacheless mode the server is authoritative and the inode is on its
way out, so locally adjusting nlink buys nothing. Skip v9fs_dec_count()
entirely when neither CACHE_META nor CACHE_LOOSE is set, which both
avoids the warning and removes a class of nlink races (two concurrent
unlinkers observing nlink > 0 and both calling drop_nlink()) that an
nlink == 0 guard alone would only narrow rather than close.

Fixes: ac89b2ef9b55 ("9p: don't maintain dir i_nlink if the exported fs doesn't either")
Cc: stable@vger.kernel.org
Suggested-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Message-ID: <20260421-9p-v2-1-48762d294fad@debian.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
[ Adapted `v9ses->cache & (CACHE_META | CACHE_LOOSE)` bitmask test to the pre-bitmask exclusive enum form `v9ses->cache != CACHE_LOOSE && v9ses->cache != CACHE_FSCACHE`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -521,10 +521,19 @@ static int v9fs_at_to_dotl_flags(int fla
  * - ext4 (with dir_nlink feature enabled) sets nlink to 1 if a dir has more
  *   than EXT4_LINK_MAX (65000) links.
  *
+ * In cacheless mode the server is the source of truth for nlink and the
+ * inode is going away immediately, so locally adjusting i_nlink buys
+ * nothing and races with concurrent metadata fetches that may already
+ * have observed the post-unlink value (nlink == 0).
+ *
  * @inode: inode whose nlink is being dropped
  */
 static void v9fs_dec_count(struct inode *inode)
 {
+	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
+
+	if (v9ses->cache != CACHE_LOOSE && v9ses->cache != CACHE_FSCACHE)
+		return;
 	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
 		drop_nlink(inode);
 }


