Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA8833032B;
	Sat, 30 May 2026 17:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163955; cv=none; b=lSwxGGq9EIcZAiyHGjUQqPOllTr891q8Q9rZ3WtlQWar7a3PX6qCz/iII8EQhIdSj3klonZU7ZR0zqa5qyBhqk3VHCDfMb+f3pdyyXyW/7aejK5IXjkAcH4drUbNIhNKd/PW5C1ijZo4WEmwMW0dj6Afb8fXqh6yt2RkW426vLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163955; c=relaxed/simple;
	bh=JFQHewgqkMmooZgGgUE9WIUv4nAk3ZyVYiq/OHw1kf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOInglXHqhRX4oAe4XfGcA2ImI1Ri2DAqHSvk73ix88TiyuCVgkXYc9RjVz+/pY79Rcyh4OF05i6qcr/q2qRxfYKHLdMu6Wo0ntmsvy/F1QjGZuPwBGCk2WV9REWC2T/8/sMwyAJMhtx30E4iwJ7aPKft66AbESVGTD3H0e4Sbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oap/JL6u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oap/JL6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E591F00893;
	Sat, 30 May 2026 17:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163953;
	bh=BwilBU/6sqYCd7m0Jbu/sexp7Ckx/UOe+ncqVm43S54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oap/JL6uSrrVHKXCWt6w0HVFSAQK1Lvu+zZEw4M2IlB5OvJCSF4KXVVcSDwzfJaD9
	 mn1TfwlogsHb3JFxOurIGFuOE5pYY6mxC5EGZsXhZOLaT6xhV38DjTpnN5XQUv7mt7
	 yBEp1gTS4FpvvEgIrEfZ4cmnYkxLyYCR6h6AEh38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/776] bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks
Date: Sat, 30 May 2026 18:02:05 +0200
Message-ID: <20260530160251.110032083@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit beaf0e96b1da74549a6cabd040f9667d83b2e97e ]

bpf_lsm_task_to_inode() is called under rcu_read_lock() and
bpf_lsm_inet_conn_established() is called from softirq context, so
neither hook can be used by sleepable LSM programs.

Fixes: 423f16108c9d8 ("bpf: Augment the set of sleepable LSM hooks")
Reported-by: Quan Sun <2022090917019@std.uestc.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Closes: https://lore.kernel.org/bpf/3ab69731-24d1-431a-a351-452aafaaf2a5@std.uestc.edu.cn/T/#u
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260407122334.344072-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index c9e785ab62cf0..02913d8610414 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -211,7 +211,6 @@ BTF_ID(func, bpf_lsm_task_getsecid_subj)
 BTF_ID(func, bpf_lsm_task_getsecid_obj)
 BTF_ID(func, bpf_lsm_task_prctl)
 BTF_ID(func, bpf_lsm_task_setscheduler)
-BTF_ID(func, bpf_lsm_task_to_inode)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_SET_END(sleepable_lsm_hooks)
 
-- 
2.53.0



