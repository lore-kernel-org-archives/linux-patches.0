Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F26395AEA;
	Sat, 30 May 2026 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160894; cv=none; b=Q9FUNyFNLSkzG3//SbQZfoXDmc46fFQGzPUqLFTFSglRaCB219WBjhg5dY4exW+dL1ITfQfn9MN8fuCF9syu/1MpDkGpjLVg2qQsoH7e0m44Zv7dGy/bFGMkdEMiFrTvOqwf0n7AZAnxJNApXr250vOA2m9PlGbCXpqYoHYNgek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160894; c=relaxed/simple;
	bh=pZTD0U7+EnbYs6+4FFtDm+RFVI3wF91C81toAMMhUqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3S3C/QL70IkoDf6ZezY2dhYh1zV3q43xEtk44Uk29kbMxQBB4f3TBbzpqNL6edlbnhxv0uH8wimok3Nrctnd+ob531NO22f+4ZN5AEs9oCkaoys2rTQEUdaF6NpQN4vs8yi8vnz43qop3kBxO83fqeMbQtHLzcvzNv2p/Zis8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gejq+l8y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gejq+l8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71C21F00893;
	Sat, 30 May 2026 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160893;
	bh=h5oUBorRck0q9sc04yZ7WPHY5i0tWBtar8b0iNHcbV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gejq+l8yKyAj9M3vS61Byq/DewnuK1+dBzZJpQOJV0tiCrHIcoWBMocEEFELWXkPM
	 5brGD4b5nZDaQPGennfk/b6pj6zZ7zMc3FQYUgDVxP2CBu6jzYXTKH+ASideTxD7tT
	 LayrpARDVRLyFjUl8xBCFReWZ3MqY8kM0/ph4/LQ=
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
Subject: [PATCH 6.1 464/969] bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks
Date: Sat, 30 May 2026 17:59:48 +0200
Message-ID: <20260530160313.095711369@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6a76da4bca78..075c06aa9c951 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -338,7 +338,6 @@ BTF_ID(func, bpf_lsm_current_getsecid_subj)
 BTF_ID(func, bpf_lsm_task_getsecid_obj)
 BTF_ID(func, bpf_lsm_task_prctl)
 BTF_ID(func, bpf_lsm_task_setscheduler)
-BTF_ID(func, bpf_lsm_task_to_inode)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_SET_END(sleepable_lsm_hooks)
 
-- 
2.53.0



