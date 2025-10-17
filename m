Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB23330B1C;
	Fri, 17 Oct 2025 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715860; cv=none; b=ZlzEuojB37D21bl9xu4J50TN+a/vtX4vec6dQ+LetehIpP7fYgFABFxEOmvoKAkk7zVjG5qe8y+DKYbCq1+GW38E75+H1m/lgVtS66QgMwTJN9mR3nG09I8akCjr/Hd+NBSbT4OSndn4EJKbZR80z+S7IC0u97RaMKj1FRuokUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715860; c=relaxed/simple;
	bh=vDJAGuVwZHZLaBj4WYi1NhP7g3g9hQoQRqimx7yBkl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ii2iatD83mdRyyeLcJ9Jmm6TgUCgumo7/VqJGy44+UOheQ0KglUoQG/1hAKq3A9u+YMW+wYCe9+GHepSzbK+rm0TG1mosaINsmhqe9m86xLXc1tGLZl03vsCtAQAxMoD47VM+UP5yEIzaVJjsoYlTtR33aSonWxHCmBU5Ei+yMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7WACyvY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7WACyvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269F7C4CEE7;
	Fri, 17 Oct 2025 15:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715860;
	bh=vDJAGuVwZHZLaBj4WYi1NhP7g3g9hQoQRqimx7yBkl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7WACyvYwhfAAlnOzRMMGwVJwYIe+jg9DQC9UjN6g/adltoVf8b4N2g31glB7Yo5+
	 wdy4xE9qPyo7IGjTjq6p1kEPmDDJcNtmR+G3zxDqz59dgFDGmuO6p4BbEKherZBdf3
	 wlUEfv+do/kap65H2VdbI9+WHvh/pRJa++/Cv6fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=E9=AB=98=E7=BF=94?= <gaoxiang17@xiaomi.com>
Subject: [PATCH 6.17 362/371] pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
Date: Fri, 17 Oct 2025 16:55:37 +0200
Message-ID: <20251017145215.186698508@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 296cd04c24bae..2dbcc4dd90cc0 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -514,7 +514,8 @@ pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
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



