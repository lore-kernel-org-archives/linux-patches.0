Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCF4189BAF;
	Mon, 28 Oct 2024 06:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097656; cv=none; b=f24jTSzOKwIXqk4NLc0L86iSLWiEZSeszPCheDRGCtTzk0DH1L3MFjUt5qVaaf2LF4puDmcbx1MPQ1PvbFXjuLWaNKg1rCqKLdRDQeXzalfQG74U+wjDtCc8JlxLECI4sHzlvzbdRTqA5fb/eEfDfPegN6GCKQiKOBozw3WetNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097656; c=relaxed/simple;
	bh=CeuZXRyP7Tpk5eWInQpkw0HHhP5d0BOIIN6DH/GtZo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpoUHQyXLFTPsoJMtKg6F+ScYT9uNHQzDHfia0rFLvo1M1G9cQBAhd+taoJ2WYDSDJtHbzCgauf3tpXPGbguCzyAmybXyPzwWTDCeSjwjSZXYiQ1QcQycmqnPumQKmeswoKJT5qECxyLpiLkkT3NfPJycajhz9v7j8ZNCis1Hu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTCetCvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTCetCvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B084AC4CEC3;
	Mon, 28 Oct 2024 06:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097656;
	bh=CeuZXRyP7Tpk5eWInQpkw0HHhP5d0BOIIN6DH/GtZo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTCetCvfjqWZN2BptDGWqNfahhdyQEzrX/2xkdomZUr98GACHWy0C207m1XHrEJdo
	 aM7w1aQZ1PUYk6+vs9it6jP7baHijYFXku9s7Olhyk+apy/9N/C+BJCwsWCO86W5o6
	 qnTTW/Gse727cpOgLIMjVL+vcbi2+q8ILKoJ+VuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rome <linux@jordanrome.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/208] bpf: Fix iter/task tid filtering
Date: Mon, 28 Oct 2024 07:24:29 +0100
Message-ID: <20241028062308.840521568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Rome <linux@jordanrome.com>

[ Upstream commit 9495a5b731fcaf580448a3438d63601c88367661 ]

In userspace, you can add a tid filter by setting
the "task.tid" field for "bpf_iter_link_info".
However, `get_pid_task` when called for the
`BPF_TASK_ITER_TID` type should have been using
`PIDTYPE_PID` (tid) instead of `PIDTYPE_TGID` (pid).

Fixes: f0d74c4da1f0 ("bpf: Parameterize task iterators.")
Signed-off-by: Jordan Rome <linux@jordanrome.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20241016210048.1213935-1-linux@jordanrome.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index c4ab9d6cdbe9c..f7ef58090c7d0 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -119,7 +119,7 @@ static struct task_struct *task_seq_get_next(struct bpf_iter_seq_task_common *co
 		rcu_read_lock();
 		pid = find_pid_ns(common->pid, common->ns);
 		if (pid) {
-			task = get_pid_task(pid, PIDTYPE_TGID);
+			task = get_pid_task(pid, PIDTYPE_PID);
 			*tid = common->pid;
 		}
 		rcu_read_unlock();
-- 
2.43.0



