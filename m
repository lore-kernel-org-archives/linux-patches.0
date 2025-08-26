Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20322350825;
	Tue, 26 Aug 2025 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219076; cv=none; b=V+yRls4N+VbtvSuQpaA/KP5HPM8dDd4c1ipk64fNR85QhpP2Ln9LzrlZWJakPRLdGdhpXRvEKIYg5L4eoLFr28X4VBukt02oreJNQ3j7yywenC7gJOjcTwVQBmuziv1Sz4vdp3sKrQU9CTfAjX1QyCz8UTl2O9eUQXJKBFburZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219076; c=relaxed/simple;
	bh=XPh2Llq2R22Tt3xsDbp2zwdZQVvhqETN8xzBhG813us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrT6sCuxCFI6Gf4LgOXUNZXTHlul+UPTNSIwRdN3bvizSGvMKosE9NDkrQm6PI38A2zdd7IaFO4iF47oljaHGJPnZSNfP0lNOk9qczZdXHZnZJn2SgynkbM5L3nuX9ZUJpf7POAPBLHE0X73jGLI6ikYUQXvCog83rJoH/QABtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6auGTcM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6auGTcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CCBC113CF;
	Tue, 26 Aug 2025 14:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219076;
	bh=XPh2Llq2R22Tt3xsDbp2zwdZQVvhqETN8xzBhG813us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l6auGTcMVR+h+kUvcI26fJNoupwCViP0NqGiuxGTdcDPo3cSSlxDMOJl8vqlGqHRf
	 W1f13hK5ThA8+enFy4+bGLZ7xWsbuTLtkM3nxhNyvOtHBLmfHD5BNwE3D2RfaiIeM/
	 tSyQqF9podb/Ach3DmT1FLVz3F1+mhreweXBxrt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Yury Norov [NVIDIA]" <yury.norov@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 243/403] RDMA: hfi1: fix possible divide-by-zero in find_hw_thread_mask()
Date: Tue, 26 Aug 2025 13:09:29 +0200
Message-ID: <20250826110913.541317554@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 832b878fa67e..6933fbea2b46 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -1009,31 +1009,35 @@ static void find_hw_thread_mask(uint hw_thread_no, cpumask_var_t hw_thread_mask,
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



