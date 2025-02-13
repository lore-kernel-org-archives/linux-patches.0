Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDC114B95A;
	Thu, 13 Feb 2025 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457539; cv=none; b=c/JoUGsPwa8AQxloud6PloZSI9v5VwjCbEMYTPHU1Qt76UaF7w/idFJ0qHQnAuri66lBWUnWhcmYa4dAK0EdeaDlSDjkFOHC1RYYRBgFukYJDjhFlWAIQTTABGxFgSxBJ2hK3fscEWamFCAFxNP1sB7IWStibFMk/oB0MKqLV+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457539; c=relaxed/simple;
	bh=dRPsd0Iu+BKBsIXlFfv9lQO7ioyRnZipBN7RsdDm+5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6/hjx8ubTv9MQNryuyeSHcSqzpLHn7vGdZJKIYYGHXuAJeWOqxcGrqMSlcS8LsEUUz844itlsAIGWFtJr/TqKVTRV3jpq+0P89u/nhgbkmzg0c4r2NVKisMeXUtFyvsrKPCyN5EQ8w7HF6geKFM5Uz/htruqAx6lP88G2GG+jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02ly5yd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02ly5yd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4168EC4CED1;
	Thu, 13 Feb 2025 14:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457538;
	bh=dRPsd0Iu+BKBsIXlFfv9lQO7ioyRnZipBN7RsdDm+5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02ly5yd+zI4lYZcPldkdmxgwYswOJTLChdn04JIiz1BIgpBAki2b13EXLIBYV0fFn
	 lVIrCymJl+eT7TaFvhjBISqIVlIUWgW7S6RUezoW8LQ+sHxc0QmRpNskXEtJy0AIz9
	 4oITPOvFfeHy8RG/T7Ykfc97cDw+Yts5HSwuRCoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 141/422] fs/proc: do_task_stat: Fix ESP not readable during coredump
Date: Thu, 13 Feb 2025 15:24:50 +0100
Message-ID: <20250213142441.988206031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit ab251dacfbae28772c897f068a4184f478189ff2 upstream.

The field "eip" (instruction pointer) and "esp" (stack pointer) of a task
can be read from /proc/PID/stat. These fields can be interesting for
coredump.

However, these fields were disabled by commit 0a1eb2d474ed ("fs/proc: Stop
reporting eip and esp in /proc/PID/stat"), because it is generally unsafe
to do so. But it is safe for a coredumping process, and therefore
exceptions were made:

  - for a coredumping thread by commit fd7d56270b52 ("fs/proc: Report
    eip/esp in /prod/PID/stat for coredumping").

  - for all other threads in a coredumping process by commit cb8f381f1613
    ("fs/proc/array.c: allow reporting eip/esp for all coredumping
    threads").

The above two commits check the PF_DUMPCORE flag to determine a coredump thread
and the PF_EXITING flag for the other threads.

Unfortunately, commit 92307383082d ("coredump:  Don't perform any cleanups
before dumping core") moved coredump to happen earlier and before PF_EXITING is
set. Thus, checking PF_EXITING is no longer the correct way to determine
threads in a coredumping process.

Instead of PF_EXITING, use PF_POSTCOREDUMP to determine the other threads.

Checking of PF_EXITING was added for coredumping, so it probably can now be
removed. But it doesn't hurt to keep.

Fixes: 92307383082d ("coredump:  Don't perform any cleanups before dumping core")
Cc: stable@vger.kernel.org
Cc: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/d89af63d478d6c64cc46a01420b46fd6eb147d6f.1735805772.git.namcao@linutronix.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -500,7 +500,7 @@ static int do_task_stat(struct seq_file
 		 * a program is not able to use ptrace(2) in that case. It is
 		 * safe because the task has stopped executing permanently.
 		 */
-		if (permitted && (task->flags & (PF_EXITING|PF_DUMPCORE))) {
+		if (permitted && (task->flags & (PF_EXITING|PF_DUMPCORE|PF_POSTCOREDUMP))) {
 			if (try_get_task_stack(task)) {
 				eip = KSTK_EIP(task);
 				esp = KSTK_ESP(task);


