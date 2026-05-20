Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A283F6619;
	Wed, 20 May 2026 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300159; cv=none; b=H1uheDIGvj/G+fc6zN0+S+3ooT5TiyBFz4rYupCX/J6BfyvctvR3nDz68jDPjHKQ8ECL4Lo4V7KNz0KY8oJham+NfpIVFh+r/+OmRstu5BpvlhRHgdpRrRXL3kxOpZm1WHezb3DJlghxhJE2B0/m3H9jJ1oh1+Rl1nchQEI9y3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300159; c=relaxed/simple;
	bh=ANT7gatbiLbt6U5UXnQyHU8wuu+SymJntrx7GC3BzIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ci4KVppZJIhhDcg9mqxjlc88+etqlhbpi/lOKEgo/m+2hzkmLnhLYG9OgLRbc3Sdj78x8EKxIjWKu8gbhwiLMukAhL/AvWHB+UbvXJOhSFL10WABqbOG8w7E5sTz5aHthLnrSVSG2MOZ69Q3k6WG3eR4jj61fwynNtAtV9wZk5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra3f0/NF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra3f0/NF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127E21F000E9;
	Wed, 20 May 2026 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300158;
	bh=IXp5OFCthmsmvjPoKBu2LeCjDGMjj8xs7wt4btt85UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ra3f0/NFtvT5QN9sAeX/ST65WJsGtkHVIzse/Rfr4ridPclxckz9BciMN+koAVXqN
	 yBi3MD5bInAzdEcI3EREQtash5XRqYZ6xoxyMbsQnplG3a6fIDAa8IahOCyQRaZnsR
	 xakgCMtM75FuN3rx6WX2n0EgLAdIkqbVMGyYGavQ=
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
Subject: [PATCH 6.12 068/666] bpf: Drop task_to_inode and inet_conn_established from lsm sleepable hooks
Date: Wed, 20 May 2026 18:14:39 +0200
Message-ID: <20260520162112.704454423@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/bpf/bpf_lsm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 3bc61628ab251..0849453b36176 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -355,8 +355,6 @@ BTF_ID(func, bpf_lsm_sb_umount)
 BTF_ID(func, bpf_lsm_settime)
 
 #ifdef CONFIG_SECURITY_NETWORK
-BTF_ID(func, bpf_lsm_inet_conn_established)
-
 BTF_ID(func, bpf_lsm_socket_accept)
 BTF_ID(func, bpf_lsm_socket_bind)
 BTF_ID(func, bpf_lsm_socket_connect)
@@ -379,7 +377,6 @@ BTF_ID(func, bpf_lsm_current_getsecid_subj)
 BTF_ID(func, bpf_lsm_task_getsecid_obj)
 BTF_ID(func, bpf_lsm_task_prctl)
 BTF_ID(func, bpf_lsm_task_setscheduler)
-BTF_ID(func, bpf_lsm_task_to_inode)
 BTF_ID(func, bpf_lsm_userns_create)
 BTF_SET_END(sleepable_lsm_hooks)
 
-- 
2.53.0



