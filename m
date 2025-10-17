Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3D8330B00;
	Fri, 17 Oct 2025 15:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716431; cv=none; b=oDH8waLvXx98yrWFCW4j/De9mNGs1wOZgUxP2EGzssKyYNs7UtNhNxsvYMkmmak57qr6NzieazlBsKTkDfn/w2QlOzrc4o48ZBDzFcnREM/FNVZkoJB8W172gMX4PRYGzkzu0v8PAT0qMQHfozL1OLXKefzRcezPgCFosOsMEx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716431; c=relaxed/simple;
	bh=HGDqRkJpf6oiOs3Gy3QkUCY1iywHwdjHBMuB/HDd188=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaeKrUdYO3I1LHAvrqLL0zyVjaoAZ3T2yzYhGpWlVmuSL2cI9Uln6cNB6gnM6gkc3dfJobvusL6jm914mjR4Pqoq/syFM1GL8OJ0cv/8UzYT7bdY9atArF7ixg0c+N8tx+5g/5EW3dylSI0h4+eZCLIde/O1XwUSi55fsZBzN88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwSpSmZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwSpSmZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195B9C4CEE7;
	Fri, 17 Oct 2025 15:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716431;
	bh=HGDqRkJpf6oiOs3Gy3QkUCY1iywHwdjHBMuB/HDd188=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwSpSmZF9BU2vcNcqx996p0tlQT+CctHJvolIdZpxRrqY2h0vl/LnbXg4IflODNN7
	 T54649vAEBH1pXWDw4lWBwWo2qX8G/8cHMgaHIaO1y2m7YsLJpcpS6/GCfStF6dssm
	 htLgJum0Ke39UQ6HbB8/aXKK4ys28ADQ5ggmDQjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Sarai <cyphar@cyphar.com>,
	Askar Safin <safinaskar@zohomail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 189/276] openat2: dont trigger automounts with RESOLVE_NO_XDEV
Date: Fri, 17 Oct 2025 16:54:42 +0200
Message-ID: <20251017145149.371193004@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
@@ -1307,6 +1307,10 @@ static int follow_automount(struct path
 	    dentry->d_inode)
 		return -EISDIR;
 
+	/* No need to trigger automounts if mountpoint crossing is disabled. */
+	if (lookup_flags & LOOKUP_NO_XDEV)
+		return -EXDEV;
+
 	if (count && (*count)++ >= MAXSYMLINKS)
 		return -ELOOP;
 
@@ -1330,6 +1334,10 @@ static int __traverse_mounts(struct path
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


