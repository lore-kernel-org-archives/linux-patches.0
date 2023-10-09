Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB34339B0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcA01uEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BECC433C7;
	Mon,  9 Oct 2023 13:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859045;
	bh=i6GSJHMGWSNr3uVC4MqQhX1BNSo0321HDQ7mNgCEbYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcA01uEaQROj+Phz+xe84BwJ0dHjS0gjdFEsJSgKIxsFe+0hFRSjcUCvyrQEuSVEd
	 MJkWYC6nCmQbZHC1zBUyWy9+N7YOGHg3/8Eebt0izL8XXMAotTnJgeP4WIqUCns8Ql
	 Kb1bZLQcz+/lAk9V0sCQV6YbNvrqn4oNglp2er7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Wolsieffer <ben.wolsieffer@hefring.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Giulio Benetti <giulio.benetti@benettiengineering.com>,
	Greg Ungerer <gerg@uclinux.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 153/226] proc: nommu: /proc/<pid>/maps: release mmap read lock
Date: Mon,  9 Oct 2023 15:01:54 +0200
Message-ID: <20231009130130.700707170@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Ben Wolsieffer <Ben.Wolsieffer@hefring.com>

commit 578d7699e5c2add8c2e9549d9d75dfb56c460cb3 upstream.

The no-MMU implementation of /proc/<pid>/map doesn't normally release
the mmap read lock, because it uses !IS_ERR_OR_NULL(_vml) to determine
whether to release the lock.  Since _vml is NULL when the end of the
mappings is reached, the lock is not released.

Reading /proc/1/maps twice doesn't cause a hang because it only
takes the read lock, which can be taken multiple times and therefore
doesn't show any problem if the lock isn't released. Instead, you need
to perform some operation that attempts to take the write lock after
reading /proc/<pid>/maps. To actually reproduce the bug, compile the
following code as 'proc_maps_bug':

#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>

int main(int argc, char *argv[]) {
        void *buf;
        sleep(1);
        buf = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        puts("mmap returned");
        return 0;
}

Then, run:

  ./proc_maps_bug &; cat /proc/$!/maps; fg

Without this patch, mmap() will hang and the command will never
complete.

This code was incorrectly adapted from the MMU implementation, which at
the time released the lock in m_next() before returning the last entry.

The MMU implementation has diverged further from the no-MMU version since
then, so this patch brings their locking and error handling into sync,
fixing the bug and hopefully avoiding similar issues in the future.

Link: https://lkml.kernel.org/r/20230914163019.4050530-2-ben.wolsieffer@hefring.com
Fixes: 47fecca15c09 ("fs/proc/task_nommu.c: don't use priv->task->mm")
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: Greg Ungerer <gerg@uclinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/task_nommu.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -208,11 +208,16 @@ static void *m_start(struct seq_file *m,
 		return ERR_PTR(-ESRCH);
 
 	mm = priv->mm;
-	if (!mm || !mmget_not_zero(mm))
+	if (!mm || !mmget_not_zero(mm)) {
+		put_task_struct(priv->task);
+		priv->task = NULL;
 		return NULL;
+	}
 
 	if (mmap_read_lock_killable(mm)) {
 		mmput(mm);
+		put_task_struct(priv->task);
+		priv->task = NULL;
 		return ERR_PTR(-EINTR);
 	}
 
@@ -221,23 +226,21 @@ static void *m_start(struct seq_file *m,
 		if (n-- == 0)
 			return p;
 
-	mmap_read_unlock(mm);
-	mmput(mm);
 	return NULL;
 }
 
-static void m_stop(struct seq_file *m, void *_vml)
+static void m_stop(struct seq_file *m, void *v)
 {
 	struct proc_maps_private *priv = m->private;
+	struct mm_struct *mm = priv->mm;
 
-	if (!IS_ERR_OR_NULL(_vml)) {
-		mmap_read_unlock(priv->mm);
-		mmput(priv->mm);
-	}
-	if (priv->task) {
-		put_task_struct(priv->task);
-		priv->task = NULL;
-	}
+	if (!priv->task)
+		return;
+
+	mmap_read_unlock(mm);
+	mmput(mm);
+	put_task_struct(priv->task);
+	priv->task = NULL;
 }
 
 static void *m_next(struct seq_file *m, void *_p, loff_t *pos)


