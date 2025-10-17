Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1675330B2E;
	Fri, 17 Oct 2025 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716644; cv=none; b=DZiyz1uVACuKkAEwbrrilI8D1hJL4ukn5egiZPx4Pcq1r2fmFMUlJbyXjhMU19/2uni/Ke5+xncKk2I+txL2kp2UkIgptdBqBLvipSZZxeuTko2r1IWC3RrFXhtCgyg8yAGvBoEjcAOjSJKf/3y5ApYMG06ZEY5nBoU8ZpFGld4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716644; c=relaxed/simple;
	bh=6zd5eHMARvAMDAf3z+YpE/HlK2S6ZDiEz+R7rjrun7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dtOINIyhfm3ByCaF8Jm6ViZRbV8K/h5a3TcZV/hkHqyZRUftDdEFX83aPOwJTh+4QXllJFOIQtt/L/Ufv5ro/a6TwSIeiebfMAna//knevUTugS0LewV95X5YdU1bVLp6Ri/OVJkCvT3U/i+f7PgBUrvcAm1vjxG0oerwJASzBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldS0zGXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldS0zGXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7CCC116B1;
	Fri, 17 Oct 2025 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716643;
	bh=6zd5eHMARvAMDAf3z+YpE/HlK2S6ZDiEz+R7rjrun7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldS0zGXCQXpMAqpAuoeEqYax9DmRyawwu8o7e2j3VFsUSchifaPaAAThkyESDFoXx
	 0W5qCbE2l5CO8IyUPOVjh2qGlCDgB+J6FMfBLgfqLvLaeKQ3T+RVVBzFUEbdMa1TpR
	 Welp8K3kJK2cbs6JOgJ/Kbmv/9pm9HPbu1D4C4Tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=E9=AB=98=E7=BF=94?= <gaoxiang17@xiaomi.com>
Subject: [PATCH 5.15 262/276] pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
Date: Fri, 17 Oct 2025 16:55:55 +0200
Message-ID: <20251017145152.050881253@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 61f6649568b25..18f67751d0a51 100644
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



