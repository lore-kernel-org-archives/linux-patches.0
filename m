Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE261CA4B;
	Tue, 17 Jun 2025 16:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179529; cv=none; b=PsZ9s3S0fA8sH/rPznDwEs7pncsgEnNeGz7w53AFpNrUBsMnrdskW8Ou/LqbYVU8jn1B6MHdOuYIFlJ1H4k8Ndthur/oSlqJfnh1ZF36XIoX/P8CLsJmDi9/yl03BAGZ64V/N6rkUQlw5EbDmJqJCHG4Redw9s7N7PEu2S78tfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179529; c=relaxed/simple;
	bh=tHsujHJ0ue3jrlgcx5HQScAPb3Eauy3uL4jPYuLKXiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eszTlGdCYZrSJzkNVw3iVLAR6Fk+hEyUcE99d/TQVXiAlVTlDBtOhUQQXP1rpaDLt+RDK55ddAxgsNh8Nmg8OQcxdWPolxJNVN4J3XYc++KfpLL+s3UR0nPnBglLPqUYR5b4mTabvbzgMIy+p3jtQRyqrc8wg3yRSw3RV3oUSrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utQZlmUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utQZlmUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1D9C4CEE3;
	Tue, 17 Jun 2025 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179529;
	bh=tHsujHJ0ue3jrlgcx5HQScAPb3Eauy3uL4jPYuLKXiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utQZlmUb9SX5uCzTNBQ0Ff3fE9kI3B+zxVEJcNSHdv/GGNgh+AttyseGNhXtaAe9l
	 WqW3WHaEmZdPHy55Ex/et+cO3Gli4P4gS3qEu5KrTzRlDEEH6wrFDMD9xZPDD7Jfrw
	 zClmDl/EXAzzSurGPK7Hi70dQqvQwBNHYsxKl0yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Yuan <me@yhndnzj.com>,
	Christian Brauner <brauner@kernel.org>,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH 6.15 743/780] pidfs: never refuse ppid == 0 in PIDFD_GET_INFO
Date: Tue, 17 Jun 2025 17:27:31 +0200
Message-ID: <20250617152521.759063684@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Yuan <me@yhndnzj.com>

commit b55eb6eb2a7427428c59b293a0900131fc849595 upstream.

In systemd we spotted an issue after switching to ioctl(PIDFD_GET_INFO)
for obtaining pid number the pidfd refers to, that for processes
with a parent from outer pidns PIDFD_GET_INFO unexpectedly yields
-ESRCH [1]. It turned out that there's an arbitrary check blocking
this, which is not really sensible given getppid() happily returns
0 for such processes. Just drop the spurious check and userspace
ought to handle ppid == 0 properly everywhere.

[1] https://github.com/systemd/systemd/issues/37715

Fixes: cdda1f26e74b ("pidfd: add ioctl to retrieve pid info")
Signed-off-by: Mike Yuan <me@yhndnzj.com>
Link: https://lore.kernel.org/20250604150238.42664-1-me@yhndnzj.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: Luca Boccassi <luca.boccassi@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -336,7 +336,7 @@ static long pidfd_info(struct file *file
 	kinfo.pid = task_pid_vnr(task);
 	kinfo.mask |= PIDFD_INFO_PID;
 
-	if (kinfo.pid == 0 || kinfo.tgid == 0 || (kinfo.ppid == 0 && kinfo.pid != 1))
+	if (kinfo.pid == 0 || kinfo.tgid == 0)
 		return -ESRCH;
 
 copy_out:


