Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB67F2FD1D5;
	Tue, 26 Aug 2025 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214585; cv=none; b=NTF+1vClm9s8m3UWM1NRgfAImLJh2f+BLBokdDlsroHIB08qMrrirTV6ax9avaGL7QDuo95vXjRfMcsMkFZkFG9fxXJqqz28hgHoTQ7vneHyQ9Pk8+P+qTnhfFm9YjCKv78NO5ww3jNQFePzB2W5uLJS7jnrvqk9LH3rfYTi664=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214585; c=relaxed/simple;
	bh=EyX49mztYVmgzeVaOEOz5XTtwO3ydUIR7ewDrQuTNlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G56620sDMcQJVoUBjnpVC8tmzLN4yYigJ673eRACAycRPNRSRzTrrTcJxNAfCaaOZ6phhTuZTC/QvkpCXh0nKEk9PuhoYMZmQXtedJtlaqNHXYZJiyvNV2TwoISBmCQnNGPZ55v7POu+jEa+HM6A/jkn4bjjMigoV0FOMvxK1/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7MtIZYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7MtIZYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C6CC113CF;
	Tue, 26 Aug 2025 13:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214585;
	bh=EyX49mztYVmgzeVaOEOz5XTtwO3ydUIR7ewDrQuTNlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7MtIZYY6oeMl3es5DdMA/jIQ0BiJ4Rnfm3I78zfd4ePhWA9+ryl57ur/kWji35C0
	 p0wVvW+nDDRZYzyoAJdBR204nebmkNogVbc8oaj3Vt/jaJ7hiM8qyhXYQgsvzbOf0p
	 GBR2mbVlMBl42Z9X0pv8g9nDM5P0HXQek5W2bv/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/482] RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()
Date: Tue, 26 Aug 2025 13:07:27 +0200
Message-ID: <20250826110935.593911295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 77ee77d4000f..7382b85c72a6 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -966,31 +966,35 @@ static void find_hw_thread_mask(uint hw_thread_no, cpumask_var_t hw_thread_mask,
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



