Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5A533710B;
	Fri, 17 Oct 2025 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713340; cv=none; b=BUNY4UikCXeZN58bhnmK11daf8P+aCoWPyw/E9F6FKS+SFmRDAFrHpDFN201m4XBciC+vJxM24MJEikETmfbP9i4iy/8FxqCInA08VSEo5q/0x8tqLDIh3XtvQ9XyXpGt8aHaAQsIZS+XsVT6suLbDWl+Osyp2TIF1Ai1wsyOQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713340; c=relaxed/simple;
	bh=psfU0twLqc2nAiCuBiXfIft56P9iBK8dNiFNZik0mCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRiMgu39aZlZJM0lrZEPMFnN/I4ewSN+JkxdBUaGMPWkdvlYEq1rg9AWRUUUXikmlii/uNxd3s8e1RJw0H5ns34V8i2cvzkS5q8nBQKI0t0xVq/cC7L34nF/un3rNxMx2i5FfOEbPJzWIaONeIdEwFvhPymhmWsJzFzGH7BJKVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LEttyoqY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LEttyoqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A000C4CEE7;
	Fri, 17 Oct 2025 15:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713340;
	bh=psfU0twLqc2nAiCuBiXfIft56P9iBK8dNiFNZik0mCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LEttyoqYo3rDwolYo5cVH0DvImZPo7SIFgJ6fFjTeKqx/y9d6nMFg0hG9embh4viX
	 gOXputjyS46HV9VTxnygP2J++H8X7mHFOS5hENyw4HpEiLiN/8lRuMkgvcMGZP/k1d
	 yujcNqY0bOPa/Vpf8adt5Nce0wa79EKBOl2gLjqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 088/168] openat2: dont trigger automounts with RESOLVE_NO_XDEV
Date: Fri, 17 Oct 2025 16:52:47 +0200
Message-ID: <20251017145132.269949675@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Askar Safin <safinaskar@zohomail.com>

commit 042a60680de43175eb4df0977ff04a4eba9da082 upstream.

openat2 had a bug: if we pass RESOLVE_NO_XDEV, then openat2
doesn't traverse through automounts, but may still trigger them.
(See the link for full bug report with reproducer.)

This commit fixes this bug.

Link: https://lore.kernel.org/linux-fsdevel/20250817075252.4137628-1-safinaskar@zohomail.com/
Fixes: fddb5d430ad9fa91b49b1 ("open: introduce openat2(2) syscall")
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Cc: stable@vger.kernel.org
Signed-off-by: Askar Safin <safinaskar@zohomail.com>
Link: https://lore.kernel.org/20250825181233.2464822-5-safinaskar@zohomail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1360,6 +1360,10 @@ static int follow_automount(struct path
 	    dentry->d_inode)
 		return -EISDIR;
 
+	/* No need to trigger automounts if mountpoint crossing is disabled. */
+	if (lookup_flags & LOOKUP_NO_XDEV)
+		return -EXDEV;
+
 	if (count && (*count)++ >= MAXSYMLINKS)
 		return -ELOOP;
 
@@ -1383,6 +1387,10 @@ static int __traverse_mounts(struct path
 		/* Allow the filesystem to manage the transit without i_mutex
 		 * being held. */
 		if (flags & DCACHE_MANAGE_TRANSIT) {
+			if (lookup_flags & LOOKUP_NO_XDEV) {
+				ret = -EXDEV;
+				break;
+			}
 			ret = path->dentry->d_op->d_manage(path, false);
 			flags = smp_load_acquire(&path->dentry->d_flags);
 			if (ret < 0)


