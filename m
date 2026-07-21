Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3032C46DFEF;
	Tue, 21 Jul 2026 19:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663742; cv=none; b=iUbOJ8nMYp/lDcKmB3zvSZJePtEJ2uz0eUsrEZ4QskKPC69nJRFBzJTTKt3QbmdHcK9WDzpNTzM7VDL4C+0Go+SmMGxk6ZoUEOpEX/+8Q+bUNCscVg27KpHMP34gACSRiRmxm30udq5EJnUucH1Yg7z+4OkIfXsf4Liwo/5Tw88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663742; c=relaxed/simple;
	bh=24TtvqE3kG6lYR4+CE++dyG4U1BEYdQta8zOKhdemTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUvyKtRVVSj81LQkJY2vGEakHKoUeTzGmMrXp3THiYK8jsCnI4FiNI9cMNiyyYf+mzQHTZHs01TRNulPDKos2qX16XClBy8Cdk0H/G8HTucFWNDXPRi8EPuY8uD/ZeVRxKQE0KkB46L0PE1KaO2CX0Jy+s+XK8SnxAK6CZ6LrtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWkl63PS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWkl63PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950A31F000E9;
	Tue, 21 Jul 2026 19:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663740;
	bh=/hKWlionh2xsUvGQMwwkfdnHZ11CCGuy2u5AE0aeweI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWkl63PSbMyLd31rgtL5gFbVYDWpSBAQqTwIyNS4HD4CWkN959MWUeHZPnkZ1QfrC
	 MJvG6FVRjhEc+TVNT9iUl9K2Y4oaRsTi1xuJkLpPNDSdRLpJ2Fz47Tlnc5/temQKv+
	 /MbMTM+CVz74Hsutie5IglVxT05ZpI9AYSu/bca4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <asmadeus@codewreck.org>,
	Breno Leitao <leitao@debian.org>
Subject: [PATCH 6.12 0938/1276] 9p: skip nlink update in cacheless mode to fix WARN_ON
Date: Tue, 21 Jul 2026 17:23:01 +0200
Message-ID: <20260721152507.022538698@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 574aa0b4799470ac814479f1138d19efe6262255 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -488,10 +488,19 @@ static int v9fs_at_to_dotl_flags(int fla
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
+	if (!(v9ses->cache & (CACHE_META | CACHE_LOOSE)))
+		return;
 	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
 		drop_nlink(inode);
 }


