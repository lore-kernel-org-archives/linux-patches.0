Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B2C138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907ACC433EF;
	Tue,  3 Jan 2023 08:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733794;
	bh=EfAqrOsV3H3iCG3r35M0pCcLWvv+AM/p3/4tGyl+6dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3a4pzqFMDplD9YN1dF/HjPhUPi4EnvJQfX7O1Ov0EdG8K0+dXaC/N2OT/IgsDbfA
	 v0nRfvg8acYHIvz8UwEPLdVYsCalK+s4MZKVJtjRmWv/YBM4Zktw+laWa0LEk5O+6T
	 v0vsBsq20yJ+iy6r7EEfFDVOCiQnv/gh+bW5RUww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Langlois <olivier@trillion01.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 46/63] coredump: Limit what can interrupt coredumps
Date: Tue,  3 Jan 2023 09:14:16 +0100
Message-Id: <20230103081311.355472591@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 06af8679449d4ed282df13191fc52d5ba28ec536 ]

Olivier Langlois has been struggling with coredumps being incompletely written in
processes using io_uring.

Olivier Langlois <olivier@trillion01.com> writes:
> io_uring is a big user of task_work and any event that io_uring made a
> task waiting for that occurs during the core dump generation will
> generate a TIF_NOTIFY_SIGNAL.
>
> Here are the detailed steps of the problem:
> 1. io_uring calls vfs_poll() to install a task to a file wait queue
>    with io_async_wake() as the wakeup function cb from io_arm_poll_handler()
> 2. wakeup function ends up calling task_work_add() with TWA_SIGNAL
> 3. task_work_add() sets the TIF_NOTIFY_SIGNAL bit by calling
>    set_notify_signal()

The coredump code deliberately supports being interrupted by SIGKILL,
and depends upon prepare_signal to filter out all other signals.   Now
that signal_pending includes wake ups for TIF_NOTIFY_SIGNAL this hack
in dump_emitted by the coredump code no longer works.

Make the coredump code more robust by explicitly testing for all of
the wakeup conditions the coredump code supports.  This prevents
new wakeup conditions from breaking the coredump code, as well
as fixing the current issue.

The filesystem code that the coredump code uses already limits
itself to only aborting on fatal_signal_pending.  So it should
not develop surprising wake-up reasons either.

v2: Don't remove the now unnecessary code in prepare_signal.

Cc: stable@vger.kernel.org
Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reported-by: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -523,7 +523,7 @@ static bool dump_interrupted(void)
 	 * but then we need to teach dump_write() to restart and clear
 	 * TIF_SIGPENDING.
 	 */
-	return signal_pending(current);
+	return fatal_signal_pending(current) || freezing(current);
 }
 
 static void wait_for_dump_helpers(struct file *file)


