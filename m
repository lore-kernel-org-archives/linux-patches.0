Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C971DFC7;
	Wed,  3 Jul 2024 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004623; cv=none; b=Wko5+ZMGDBMx94VPcoHpKDZ6NmDR2LNsuP4pbRGwG3O0nGpNszi9IOxhXwDaWA2ish5NxjQ5jn1zrN047aP6feEyzW3PK+d5SpAdZOyUpIt/UrdCUoynYXjO9utGChGnqz1bCR5kt8Xr1adoOZM4ZCNOOLx8mL43WfKBAMuulBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004623; c=relaxed/simple;
	bh=DmrdjEoU7lVDDK17DvsjHEPjH5oonKwxdbbKPxxJyIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkW4qQl4LthcSAqFIkm4M7Rofpr0iQmP5y9QEAoFTwwbT+Io7KbrJNChhMCurkpG8RgsXnuiXdbjb0DcSyEvL5otspOXdtLRIVkpRiMyax7XS9VKCDvczQ9P/kSs1u77dZBJAD1UKskxXD+3IN13evPZAKkqtaqZJRNOi1jNAUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wF5m1Qu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wF5m1Qu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8291DC2BD10;
	Wed,  3 Jul 2024 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004623;
	bh=DmrdjEoU7lVDDK17DvsjHEPjH5oonKwxdbbKPxxJyIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wF5m1Qu729coCkjD32DHSC8O5pSxDc8UacuxVVesBOgNbQ6RuYkXckVWjekdtXoxV
	 HkZo0DQc8ifCUDtSxgbx9MujieebCmAQ4Wc+4lO0Yk5XB6MSA/kWchoK68bHsMWrqv
	 fiOjTWDnPJCmcislDClmYHSmXLTzz5aEUhL0YfTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Rachel Menge <rachelmenge@linux.microsoft.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Wei Fu <fuweid89@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Allen Pais <apais@linux.microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Joel Granados <j.granados@samsung.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mike Christie <michael.christie@oracle.com>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/290] zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING
Date: Wed,  3 Jul 2024 12:38:05 +0200
Message-ID: <20240703102908.124468497@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 7fea700e04bd3f424c2d836e98425782f97b494e ]

kernel_wait4() doesn't sleep and returns -EINTR if there is no
eligible child and signal_pending() is true.

That is why zap_pid_ns_processes() clears TIF_SIGPENDING but this is not
enough, it should also clear TIF_NOTIFY_SIGNAL to make signal_pending()
return false and avoid a busy-wait loop.

Link: https://lkml.kernel.org/r/20240608120616.GB7947@redhat.com
Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Rachel Menge <rachelmenge@linux.microsoft.com>
Closes: https://lore.kernel.org/all/1386cd49-36d0-4a5c-85e9-bc42056a5a38@linux.microsoft.com/
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Tested-by: Wei Fu <fuweid89@gmail.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/pid_namespace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 20243682e6056..e032b1ce79649 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -221,6 +221,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
+		clear_thread_flag(TIF_NOTIFY_SIGNAL);
 		rc = kernel_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
-- 
2.43.0



