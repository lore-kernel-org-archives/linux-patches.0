Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD4F337112;
	Fri, 17 Oct 2025 15:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714005; cv=none; b=kQP8cTPz3nPbf3t+7zGUselGTdEUjKeuV5ufv3VuY0l8djjLJXqro4/Xk7D6H/zLHSvYMfOrhbx0NoA4bRklNRGDhII+DH2zNYsfYb4eU4/t0ffRCDg7uuhWMjA2/67v/oo5QWk61dyMVJ+9C8nyyjw063YiMkfJWjyLn23JrJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714005; c=relaxed/simple;
	bh=nqbwf+Asf1bGfsVeCFSWkNN8RkWSflRkiYdUerboK+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UYvR0QkSJn6lk/C0pFWqB5PHeIsEN1+KMpizM8pFwNaKmYmCKMTpFG1hEmlA44SzPPwepBw5Yy6yFIeY+yAS2z7rvv3zTfVE8hs1zxZSuCRf9tsMIF72YTiL6buY6vr6eeTEHlWhMxfnzn3Mi1NpL1d0Ta3ULoekDpXEMVGjMoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnRYOwb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnRYOwb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A514C4CEE7;
	Fri, 17 Oct 2025 15:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714005;
	bh=nqbwf+Asf1bGfsVeCFSWkNN8RkWSflRkiYdUerboK+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnRYOwb97A9H3ZCcjVE84d7tWeTWBTa3nkfYkKod36EbfuRZaIdjOvD67TSYnHNh2
	 Dvw5FHsSVaKNf46aY0xXIS1SWI12CMT4srpyKK+FUfZ+BxVsQBmkvIcEZH+3kT6sSj
	 ojzsh2VkVaRdxLQklQ9NnYFsEkPkQLPoCnjXmy9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?=E9=AB=98=E7=BF=94?= <gaoxiang17@xiaomi.com>
Subject: [PATCH 6.6 196/201] pid: make __task_pid_nr_ns(ns => NULL) safe for zombie callers
Date: Fri, 17 Oct 2025 16:54:17 +0200
Message-ID: <20251017145141.961492076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e57adc00cb779..69922b2e7ed15 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -500,7 +500,8 @@ pid_t __task_pid_nr_ns(struct task_struct *task, enum pid_type type,
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



