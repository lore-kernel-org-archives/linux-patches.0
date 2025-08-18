Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE465322544;
	Mon, 18 Aug 2025 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524194; cv=none; b=dXo0Lg/H4SkZPR1AKhsT25496WySxpyP8OyVWFGILwF3TlPbE74qwV6lw5LyJ6vom97NB5/ToTrZPp0gdH/oDZeNsPYg+/C0QoTbvDRyDbP/urvALl3+9CvDE8ZwajRO301ob+0DlQ91AyzxLbnItPGxgioB3fpTcWlcwwtZWI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524194; c=relaxed/simple;
	bh=Kh/6bMgpWRoWfr774RSkQlLjInc/3yAj33PorjvpNsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+J02Qz6PlyRv8pGzMNB0baT8roqtQd0J1ognfXp4JMrlFwnrZzwNjXAy4laGcnoXMqX/VkV0nKbuYGQHJ5M6ClFOogTv4tBwuNE7PCpKihU1cXTk7/UHHv2l/6G+b60/rgsGy+4wJrcdCRq2RxRmpVxvzhYVVjaZtN3rupJ8ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY/MkMER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY/MkMER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9A1C4CEEB;
	Mon, 18 Aug 2025 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524194;
	bh=Kh/6bMgpWRoWfr774RSkQlLjInc/3yAj33PorjvpNsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY/MkMERkx1y/26z5X89354hmc3EjSzi8AuhQkK+c1GPbSFa3uciClOv0qbsgrvLb
	 ZOzMrPId7E39UsJAAjWgPRFYuMlg7Qm4dizAEBVsh8CPTa327pSTAdiXcJBnZyGTXm
	 ofmkmNgwJyb5qFY/EtG0XQua0g25C0Ni003Dko6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 364/515] RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()
Date: Mon, 18 Aug 2025 14:45:50 +0200
Message-ID: <20250818124512.418303519@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7ead8746b79b..f2c530ab85a5 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -964,31 +964,35 @@ static void find_hw_thread_mask(uint hw_thread_no, cpumask_var_t hw_thread_mask,
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



