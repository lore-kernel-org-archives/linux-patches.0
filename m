Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E859C188921;
	Tue, 10 Sep 2024 09:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962143; cv=none; b=JaRqHSk57U2wrxf0DIgGkUdd9C9FMQ+0L5C/5I10Hvff5/d1wg976OhtrXy6XrVwJKyLhCtIw9JSWFpdci4XTNTyMV7GpBr6jyUCLTp3oHr1/ROiMpH+F0Yri0j9ZouhSwBKqINH9RkIBX+ekVpc2Hq1OXbHZ1RrxiVYItnap1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962143; c=relaxed/simple;
	bh=Gi6SYc9H+cSIdPnf/kUY1tQ+6ZQKEUvgHxCCO0BOGfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HT4EJAWrZwxOo4y6q12dnFJz09yAf4LhyK2U65c86yNBXB6wK5OwBPOpqZnCVLGW7GX4nu4DO+gYlUaT1htVr3d1zVhaJgcx8Mp9YZJjc9M2aMBQK2asX//0478WBgcrqruZ+J+DV2ZtJ2gCIx4IWhZ7AFdycbdIBoCDDAHKTy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg+A3/j0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg+A3/j0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA35C4CEC3;
	Tue, 10 Sep 2024 09:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962142;
	bh=Gi6SYc9H+cSIdPnf/kUY1tQ+6ZQKEUvgHxCCO0BOGfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tg+A3/j0yNuXsMpjLXZ01CJiJDQ4GHYa6RKACSvlXDQLvM989Sv5i76kU9UzC6Wlm
	 5vzK2CpzkBKqdBoUsGXcRa+HZBH14eHeu4e//+7lVOXLgqJLARH3f8h1wgRYfAy65C
	 sr8AALLf0rjVe+NGsFwJfvTaWnk8Y4AUlSqhEVzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.10 282/375] fs: only copy to userspace on success in listmount()
Date: Tue, 10 Sep 2024 11:31:19 +0200
Message-ID: <20240910092632.032191224@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 8d42877ad65b02741c9099392a001b7209baa5d4 upstream.

Avoid copying when we failed to, or didn't have any mounts to list.

Fixes: cb54ef4f050e ("fs: don't copy to userspace under namespace semaphore") # mainline only
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5138,6 +5138,8 @@ SYSCALL_DEFINE4(listmount, const struct
 
 	scoped_guard(rwsem_read, &namespace_sem)
 		ret = do_listmount(kreq.mnt_id, kreq.param, kmnt_ids, nr_mnt_ids);
+	if (ret <= 0)
+		return ret;
 
 	if (copy_to_user(mnt_ids, kmnt_ids, ret * sizeof(*mnt_ids)))
 		return -EFAULT;


