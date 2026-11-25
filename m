Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622859;
	b=DJDhsIR2Bf6OF9gufVOav64OivOMd3xnFRiRXvwQ1Y/6HWeWG/HGtDcdVL/FKhfGYKIz
	 IS7E2W2oBhaYkhNqN8TmEO9idtOjAyEvOouTqCG1ha1NfBsIH7X+JL1zW5I9088FPE56f
	 np64bMPSlEIXZlzqisEgQl8r42HjsvpwyqJ45u5KY4bB9VHDHcLBkWn7oZzUv1e3y56rr
	 YPLzn7r1AarTeXEWtfjmZXiO7/GRGjGt9+aXxGTkHdt9gVzg8oMr3pyBHMDxGNOTWs2RE
	 bWOI+eIesZox7d3DaT8zv9o3vNuWWkG6hxOUoXXJAw5oalOwI2sS1x8faUBQmm25fTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rIJP8kQfgiH3Fe1FN83gHGtZeFdZxwKo62UzVKXXO4o=;
	b=yRjWbbPtpvd0Y1mz30A5Pvklu5mI2QwivTN1OSzxGHvlIfZx/9gVbbHtWy4k0X64Ge2e
	 +qlFMaQT+LVrKwCWzFtqJC0FyESmXWhoLXtJFIJsPGv+MPxYULXPYBHYutUGkjDtCCssf
	 LFm7j9Rvyf+E6oYacXMVGRdBYIwbEwNmgmIfT1UqCbND5QKixvcXkKlW0/c1+ORtN84Hl
	 noSqPey0PU2czQw7qbVwjWdt8syxgGvyajHD4wTi3+JbYwD0/hRNozPAgZRthoskrL0un
	 4/QoLAnQWWKI4avTpLK17s0V/gvUqwl/YyI6fSZQE1+j9lvhQ/2nAD8az8eGA1vXUYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bb5oqaRt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6440606A31E;
	Wed, 25 Nov 2026 16:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bb5oqaRt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128091F000CF;
	Wed, 25 Nov 2026 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622859;
	bh=rIJP8kQfgiH3Fe1FN83gHGtZeFdZxwKo62UzVKXXO4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bb5oqaRt0P9n2o3mBM9FomcHikpUBui6StPVj0CU+N8LIUTvralUEWUa9IcjEQYDp
	 t5eJyfJry391KbScQ+rVH/qCEmzGVxp/kbmgP9DbseS8NwLQ11DLZk70EzvZFgIg2H
	 x0bLul34disC6W+IeupI+y724392ZrQscDkFZngw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Chen Linxuan <me@black-desk.cn>
Subject: [PATCH 6.18 671/990] pidfd: restrict task access ioctls to the callers pid namespace
Date: Wed, 25 Nov 2026 15:33:58 +0100
Message-ID: <20261125143837.806080638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Linxuan <me@black-desk.cn>

commit ee8323fdc827c580425644db605a4be776cace57 upstream.

pidfds can cross pid namespace boundaries: a task may obtain one for a
process outside of its own pid namespace hierarchy through SO_PASSPIDFD
or SO_PEERPIDFD, via SCM_RIGHTS, or through file descriptor inheritance.

The namespace ioctls gate access with a ptrace check against the
target's credentials only. That check does not account for the pid
namespace relationship between the caller and the target, so a task
inside a pid namespace can use a pidfd obtained across that boundary to
acquire namespace file descriptors of a task outside of its hierarchy.

procfs exposes the equivalent information only for tasks visible in the
reader's pid namespace, and PIDFD_GET_INFO already answers with -EREMOTE
for targets outside the caller's hierarchy. Extend that policy to the
namespace ioctls: fail with -EREMOTE unless the target is visible in the
caller's active pid namespace. Callers in ancestor pid namespaces are
unaffected.

Unlike PIDFD_GET_INFO, the visibility check is performed after the task
lookup here, so reaped targets outside of the caller's pid namespace
hierarchy answer -ESRCH instead of -EREMOTE.

Link: https://lore.kernel.org/all/CAG48ez1T5-tUHVK_iHsgUtWa-inVdrZxA3E-ZCW0iENJvasKfg@mail.gmail.com
Link: https://lore.kernel.org/all/20260925-gewischt-auftrag-tierzucht-c153cb3f9f74@brauner
Suggested-by: Jann Horn <jannh@google.com>
Suggested-by: Christian Brauner <brauner@kernel.org>
Fixes: 5b08bd408534 ("pidfs: allow retrieval of namespace file descriptors")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Linxuan <me@black-desk.cn>
Link: https://patch.msgid.link/20261027-pidfd-task-access-v1-1-d46cf0fa4ca1@black-desk.cn
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -514,6 +514,14 @@ static long pidfd_ioctl(struct file *fil
 		return -EINVAL;
 
 	/*
+	 * Require the target to be visible in the caller's pid namespace
+	 * for operations that grant access to its resources, mirroring
+	 * procfs and PIDFD_GET_INFO.
+	 */
+	if (!pid_in_current_pidns(pidfd_pid(file)))
+		return -EREMOTE;
+
+	/*
 	 * We're trying to open a file descriptor to the namespace so perform a
 	 * filesystem cred ptrace check. Hold @task's exec_update_lock for the
 	 * duration of the ptrace check and the namespace lookup so that the


