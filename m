Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78513370FF;
	Fri, 17 Oct 2025 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713451; cv=none; b=KPTvMhl18kx/NpsuHYVLqdGsRqiwj2rqvLD1oNCmRYx2HytbxsBCQ2gmW4Wq9hy+9+XlChRyYNgBGjq9nB/3ILgGoy4yLHrRsGV0SxrQJ3MSkVlBa1CORV7q7Ek4Hi6iJMjjO6XjJ+DwjahQUXDPRch4329xoV2oEWXEozuOT5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713451; c=relaxed/simple;
	bh=rR8iq7dNZg9CXF77RgNAnVyLp2gHny5KfFL8QaHYQbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ryeD0OiuJw0dFCo3q0FPneC9SrWaEUxgx1QYsCJYS/P5HtkubaJ5+F4iW34rCgd4BJJtIsd5sB0uHumjPxZr/xATwwvfGfEKt6ZtmgnQeZnJK+00FHkYnfm7k9SmpmzLZeTMhqQJ94kgm5N3mt93R60EfLKhp6S9t2FxAuvDkr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A47cr73h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A47cr73h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DF0C4CEE7;
	Fri, 17 Oct 2025 15:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713451;
	bh=rR8iq7dNZg9CXF77RgNAnVyLp2gHny5KfFL8QaHYQbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A47cr73hthu1Yg6E+rZipHpH0ZvP/qlvWbery73p5Ai13am4iVhflhITjjl7rD5te
	 Qi/XuE18mRePWklrWOlKAD92kF5sMW22NjJJiedyXiF4Ia59h9o6DF68OUBiXCBmtZ
	 CfE4qnvGkUQlZGsLcw1cieg4DFkJ1fwa3bt1qXTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=E9=AB=98=E7=BF=94?= <gaoxiang17@xiaomi.com>
Subject: [PATCH 6.1 163/168] pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
Date: Fri, 17 Oct 2025 16:54:02 +0200
Message-ID: <20251017145135.053471068@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e1d0c9d952278..62a8349267de1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -497,7 +497,8 @@ pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
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



