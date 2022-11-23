Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6271A1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A727C433D6;
	Wed, 23 Nov 2022 09:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195472;
	bh=FzlzNwFEQZf+iUksPz8L9P4mFXjh2drbjWh1XaP4tc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2O04+8iDsW5+hjNB2XBGDhI6i1IvOTu+3z4eT8Gmc3kLRJLfhywHKCq2Ma1kqRd7y
	 9gHZ+qDPZaazcVi8v1zYT52eUx9D/EtgpqhlXqL/rEUelfB6A+djgmyLsCHaaN5dSg
	 9Hsxh/12NJWlsnCtfwEFfiUoO7vEN7bNvL31IeHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/149] bpf: Initialize same number of free nodes for each pcpu_freelist
Date: Wed, 23 Nov 2022 09:50:45 +0100
Message-Id: <20221123084600.153838542@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 4b45cd81f737d79d0fbfc0d320a1e518e7f0bbf0 ]

pcpu_freelist_populate() initializes nr_elems / num_possible_cpus() + 1
free nodes for some CPUs, and then possibly one CPU with fewer nodes,
followed by remaining cpus with 0 nodes. For example, when nr_elems == 256
and num_possible_cpus() == 32, CPU 0~27 each gets 9 free nodes, CPU 28 gets
4 free nodes, CPU 29~31 get 0 free nodes, while in fact each CPU should get
8 nodes equally.

This patch initializes nr_elems / num_possible_cpus() free nodes for each
CPU firstly, then allocates the remaining free nodes by one for each CPU
until no free nodes left.

Fixes: e19494edab82 ("bpf: introduce percpu_freelist")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221110122128.105214-1-xukuohai@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/percpu_freelist.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/percpu_freelist.c b/kernel/bpf/percpu_freelist.c
index 3d897de89061..bbab8bb4b2fd 100644
--- a/kernel/bpf/percpu_freelist.c
+++ b/kernel/bpf/percpu_freelist.c
@@ -102,22 +102,21 @@ void pcpu_freelist_populate(struct pcpu_freelist *s, void *buf, u32 elem_size,
 			    u32 nr_elems)
 {
 	struct pcpu_freelist_head *head;
-	int i, cpu, pcpu_entries;
+	unsigned int cpu, cpu_idx, i, j, n, m;
 
-	pcpu_entries = nr_elems / num_possible_cpus() + 1;
-	i = 0;
+	n = nr_elems / num_possible_cpus();
+	m = nr_elems % num_possible_cpus();
 
+	cpu_idx = 0;
 	for_each_possible_cpu(cpu) {
-again:
 		head = per_cpu_ptr(s->freelist, cpu);
-		/* No locking required as this is not visible yet. */
-		pcpu_freelist_push_node(head, buf);
-		i++;
-		buf += elem_size;
-		if (i == nr_elems)
-			break;
-		if (i % pcpu_entries)
-			goto again;
+		j = n + (cpu_idx < m ? 1 : 0);
+		for (i = 0; i < j; i++) {
+			/* No locking required as this is not visible yet. */
+			pcpu_freelist_push_node(head, buf);
+			buf += elem_size;
+		}
+		cpu_idx++;
 	}
 }
 
-- 
2.35.1



