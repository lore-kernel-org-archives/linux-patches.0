Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283B53BB5A;
	Fri, 17 Oct 2025 15:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714794; cv=none; b=QJzepqxbeMgtVNIxvm89hZ9dUiehELkArYgt+mLhezhzmWmJ2Z6te7+D6nzzc771fkbahVWVVdxTv+kFWACzdLsfMr1BXVEVQ4MOyjkluyO5qQtNmxdLZdc/hBQRxbnGRdc4M3yGxGfRBGKQw/pBmKOazrm/J/2jW6BkX7543T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714794; c=relaxed/simple;
	bh=O+meoy7Jj2I+ElVplh73hENstT9QPBGvqcraU+uAgd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pj6KxokXv9M+tXqE/igL+odfuw298maOnw6EwlKefYbhckQHnndtKqu64WjyYR4MVaMT6/8sKGCKpoNMSlfy0FrfgrseLKm2MhQDjLzdTrkBAAvtK85OJEEYyVouoO+HVIvfniXicTBJL7Po8w5MzRlJ5bH3f+jn6HXweu/2YLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsV/9ETw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsV/9ETw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71DEC4CEE7;
	Fri, 17 Oct 2025 15:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714794;
	bh=O+meoy7Jj2I+ElVplh73hENstT9QPBGvqcraU+uAgd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsV/9ETwZxzCnrG/bWQIxSkBWVZGkegSPYHJiZgKXu7ZX9Ig261nSenxg1CNETSea
	 HypInFkoY3HsaC1eGrvAsiMSMBlqeVFCeTs+btpHaHOgAGqyVHrY4pB0b9YblwdAFr
	 03r+5FXu1GA86BwNVGmzg473V8a4IBX9u0Whn33Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=E9=AB=98=E7=BF=94?= <gaoxiang17@xiaomi.com>
Subject: [PATCH 6.12 268/277] pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
Date: Fri, 17 Oct 2025 16:54:35 +0200
Message-ID: <20251017145156.946680679@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit abdfd4948e45c51b19162cf8b3f5003f8f53c9b9 ]

task_pid_vnr(another_task) will crash if the caller was already reaped.
The pid_alive(current) check can't really help, the parent/debugger can
call release_task() right after this check.

This also means that even task_ppid_nr_ns(current, NULL) is not safe,
pid_alive() only ensures that it is safe to dereference ->real_parent.

Change __task_pid_nr_ns() to ensure ns != NULL.

Originally-by: 高翔 <gaoxiang17@xiaomi.com>
Link: https://lore.kernel.org/all/20250802022123.3536934-1-gxxa03070307@gmail.com/
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/20250810173604.GA19991@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/pid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index b80c3bfb58d07..8fdc3a5f87c7d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -510,7 +510,8 @@ pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
 	rcu_read_lock();
 	if (!ns)
 		ns = task_active_pid_ns(current);
-	nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
+	if (ns)
+		nr = pid_nr_ns(rcu_dereference(*task_pid_ptr(task, type)), ns);
 	rcu_read_unlock();
 
 	return nr;
-- 
2.51.0



