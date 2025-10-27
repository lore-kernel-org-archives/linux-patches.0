Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3946B332918;
	Mon, 27 Oct 2025 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591307; cv=none; b=QTaHXr3QC1lMTurcam4PaDKrZif9XTzxpRh6DMAg0pnPshD9Dj4zBsWQJDsu0PprDLfjtUi5vbPWVyC8BkFz2arpQ8OzDv7wQDCgBbgtfl8jcbTd/8k9I4J9XGSZnH0jYJp7cYwJvch7MH2beNCizMDebjdeJsyS8vCBo1wupck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591307; c=relaxed/simple;
	bh=7jp+8KHpElyAaWkdZBGHr69xJXZvKYcOB5sgILeMzuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ke1WlP3dDvQPdkCjT/XtyKKJU1FZ4645L7FvJSTw9MbfD6MhzZUBLcR1nWD0Jg919gBs4zEihm9AN0rb76C3+kFQ2H4MOe7hGU5rHNLdKOT5izJf1d52RGnZF9ZlT+kxs7B5bkoaB8UjEqzSEOPqZN/a1+9lbLgD9JsTm2eKWzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrImAeSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrImAeSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB33C4CEF1;
	Mon, 27 Oct 2025 18:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591307;
	bh=7jp+8KHpElyAaWkdZBGHr69xJXZvKYcOB5sgILeMzuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrImAeShXUF7NvCoujc/PSZOkVw2LRzdaI5gJsfYDJMjtvHLwVCmVE+CueyssDmhN
	 WgM8EuJq5yFCEQ5lNy3ligtCntpY+/BaTu51gJg1lYd5u1jynKv9YmqrYxWAfTb9M+
	 9DdxDRijoBSZavsvXRUXD8wguGC1mSuedbHWjFIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 145/332] openat2: dont trigger automounts with RESOLVE_NO_XDEV
Date: Mon, 27 Oct 2025 19:33:18 +0100
Message-ID: <20251027183528.461810519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1202,6 +1202,10 @@ static int follow_automount(struct path
 	    dentry->d_inode)
 		return -EISDIR;
 
+	/* No need to trigger automounts if mountpoint crossing is disabled. */
+	if (lookup_flags & LOOKUP_NO_XDEV)
+		return -EXDEV;
+
 	if (count && (*count)++ >= MAXSYMLINKS)
 		return -ELOOP;
 
@@ -1225,6 +1229,10 @@ static int __traverse_mounts(struct path
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


