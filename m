Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2703B2F12C2;
	Fri, 17 Oct 2025 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715600; cv=none; b=Z4bZPwQonjSxAYSLKTQARJgPbFlqNcTj1s7eElTD5CQOfrgHfHpurwE1nvHvjcsRggynqZUuqFIpg27fFgQdGV7WofapMqx31RcUHdk0J5E8o61Nn5H2g6DJ/4708Ba4kVtLnJmwsE8pRwrwVgftPs0mksPhBZ90xcAkHPLccdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715600; c=relaxed/simple;
	bh=JSWQ1ct0lSI/xoaFuAbUZ3H36yOyNdtOlc2cikxPqP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvI2baq5bhOkS4xd+tffB/2qipS2g1PsIx+1XNIDnHkUMeRzvY8i2K/KZBQBobsdkVtHN1tloG9W7jmNQNOoxbNG50EAYQAgQOHb2vqg1pjLTi24zjowyhriv8mvASuXopB1LfACTyh85004l5r/m8Z55zZGR1SARka6iufe2rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye5Hc5U5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye5Hc5U5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4A6C4CEE7;
	Fri, 17 Oct 2025 15:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715599;
	bh=JSWQ1ct0lSI/xoaFuAbUZ3H36yOyNdtOlc2cikxPqP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ye5Hc5U51MPtRNYithQJc3S91HTMVQJGnJvPqorewAG5belpINfNzOA//SQWA21kr
	 L/ysDQU+shtyPu1f6Z2/PkkKJmIfAE4QL+DPOyasCzyxBW6CJNzxOMIvmop/+oZOqA
	 XqffVx56/Vjl/uTRc744qS6CsZX9B+uIEo3o+IFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 239/371] openat2: dont trigger automounts with RESOLVE_NO_XDEV
Date: Fri, 17 Oct 2025 16:53:34 +0200
Message-ID: <20251017145210.727008590@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1449,6 +1449,10 @@ static int follow_automount(struct path
 	    dentry->d_inode)
 		return -EISDIR;
 
+	/* No need to trigger automounts if mountpoint crossing is disabled. */
+	if (lookup_flags & LOOKUP_NO_XDEV)
+		return -EXDEV;
+
 	if (count && (*count)++ >= MAXSYMLINKS)
 		return -ELOOP;
 
@@ -1472,6 +1476,10 @@ static int __traverse_mounts(struct path
 		/* Allow the filesystem to manage the transit without i_rwsem
 		 * being held. */
 		if (flags & DCACHE_MANAGE_TRANSIT) {
+			if (lookup_flags & LOOKUP_NO_XDEV) {
+				ret = -EXDEV;
+				break;
+			}
 			ret = path->dentry->d_op->d_manage(path, false);
 			flags = smp_load_acquire(&path->dentry->d_flags);
 			if (ret < 0)


