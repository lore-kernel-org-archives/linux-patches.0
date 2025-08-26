Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3069534F48B;
	Tue, 26 Aug 2025 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216505; cv=none; b=pwiKFdQ8kM7PhKsdHIalLLlKSC5YKemkyzD4mdEIt/tw46abHzJ1PIIBgH5UyuYYPR/IaBGi4yH/hYb+fLqy/CrinqP4Cu3pFRZYxmeJCMRaOyIIkBzkuRCYi9oXgAHtdufbXN6WKdvlXtv/ZPwNfQvMR74KhC53BU29nRTDzR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216505; c=relaxed/simple;
	bh=4w6til42xhyOMiEj6ix+K5dP9il8X0T9bkWOtuf1snI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPZS59vmtnZpYbn48/K20NGWUCFUtGtJ5HgeLk06ceGiu2lhnwuwRpRZOsZ2wZMcqHtKkhM5zDynm/TZob6/KRJoD0s2APfPjONch87gA6BF65WduclpQLJ9ijVUCi9ieNWqFmF5w+9eQv95Mbj9SiuW8o2hSx2PaVNYU6SY1LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9XWYsCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9XWYsCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B85C4CEF1;
	Tue, 26 Aug 2025 13:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216505;
	bh=4w6til42xhyOMiEj6ix+K5dP9il8X0T9bkWOtuf1snI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9XWYsCq8g3WMFYBtHKRgzU0qW+JpUW/68MQY4dOU998xeP9kcaK7jvlB2sdNMFZe
	 9easAixH0qd9Fsh+YN38ibhategEmfKXcxiUsbyhZd9n+6WjqiqJ4bjBreNHtIfKzh
	 22/CFL7xLbSz7JvnT6nsU9WE/GQgD5oq703sK4k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/644] RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()
Date: Tue, 26 Aug 2025 13:08:10 +0200
Message-ID: <20250826110956.339946674@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov [NVIDIA] <yury.norov@gmail.com>

[ Upstream commit 59f7d2138591ef8f0e4e4ab5f1ab674e8181ad3a ]

The function divides number of online CPUs by num_core_siblings, and
later checks the divider by zero. This implies a possibility to get
and divide-by-zero runtime error. Fix it by moving the check prior to
division. This also helps to save one indentation level.

Signed-off-by: Yury Norov [NVIDIA] <yury.norov@gmail.com>
Link: https://patch.msgid.link/20250604193947.11834-3-yury.norov@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/affinity.c | 44 +++++++++++++++------------
 1 file changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband/hw/hfi1/affinity.c
index 4c403d9e90cb..2b17acbb3569 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -967,31 +967,35 @@ static void find_hw_thread_mask(uint hw_thread_no, cpumask_var_t hw_thread_mask,
 				struct hfi1_affinity_node_list *affinity)
 {
 	int possible, curr_cpu, i;
-	uint num_cores_per_socket = node_affinity.num_online_cpus /
+	uint num_cores_per_socket;
+
+	cpumask_copy(hw_thread_mask, &affinity->proc.mask);
+
+	if (affinity->num_core_siblings == 0)
+		return;
+
+	num_cores_per_socket = node_affinity.num_online_cpus /
 					affinity->num_core_siblings /
 						node_affinity.num_online_nodes;
 
-	cpumask_copy(hw_thread_mask, &affinity->proc.mask);
-	if (affinity->num_core_siblings > 0) {
-		/* Removing other siblings not needed for now */
-		possible = cpumask_weight(hw_thread_mask);
-		curr_cpu = cpumask_first(hw_thread_mask);
-		for (i = 0;
-		     i < num_cores_per_socket * node_affinity.num_online_nodes;
-		     i++)
-			curr_cpu = cpumask_next(curr_cpu, hw_thread_mask);
-
-		for (; i < possible; i++) {
-			cpumask_clear_cpu(curr_cpu, hw_thread_mask);
-			curr_cpu = cpumask_next(curr_cpu, hw_thread_mask);
-		}
+	/* Removing other siblings not needed for now */
+	possible = cpumask_weight(hw_thread_mask);
+	curr_cpu = cpumask_first(hw_thread_mask);
+	for (i = 0;
+	     i < num_cores_per_socket * node_affinity.num_online_nodes;
+	     i++)
+		curr_cpu = cpumask_next(curr_cpu, hw_thread_mask);
 
-		/* Identifying correct HW threads within physical cores */
-		cpumask_shift_left(hw_thread_mask, hw_thread_mask,
-				   num_cores_per_socket *
-				   node_affinity.num_online_nodes *
-				   hw_thread_no);
+	for (; i < possible; i++) {
+		cpumask_clear_cpu(curr_cpu, hw_thread_mask);
+		curr_cpu = cpumask_next(curr_cpu, hw_thread_mask);
 	}
+
+	/* Identifying correct HW threads within physical cores */
+	cpumask_shift_left(hw_thread_mask, hw_thread_mask,
+			   num_cores_per_socket *
+			   node_affinity.num_online_nodes *
+			   hw_thread_no);
 }
 
 int hfi1_get_proc_affinity(int node)
-- 
2.39.5



