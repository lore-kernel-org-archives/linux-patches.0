Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F0815FD11;
	Mon, 27 May 2024 19:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837778; cv=none; b=kvRwOm5cg3RW+GnZzhZx0ZhY1zvEDf/sTB0q4BpquUnhNUVU2bSkvplVQadWTWtCBOm0TlKVsrAJ3hg5SZNxOzkYVdKz3T4vJWB07AbqrzbYHfIjVkbXDjwA9xn6xDMDa2BZyzSTEGpNWLO02AlRxAK0IsFRM2YXRXot4ab68Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837778; c=relaxed/simple;
	bh=RVdQv8cbWMYP4x5nM+DWwSNnDdz4fVHxSVM0iA+Sm5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyuVBzzZDxYesZ39WRgp3uTyIPW1Y/Pn7j2gBqc35pt11uIcOGyCnpnv4DN6whFfc+9B+AJ452N1ERNA9M067MaVcceMBnvwNbvADw/BHOX52KFa/GCz6nDQSJ18OTVdEqytfbj32xs1UKj1uUyeJsx39c92niNIr8ijsyvq/Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmuhbtR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmuhbtR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC94CC2BBFC;
	Mon, 27 May 2024 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837778;
	bh=RVdQv8cbWMYP4x5nM+DWwSNnDdz4fVHxSVM0iA+Sm5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmuhbtR5wY0YYMig8ERhsGTNJc3q6H9+ZjiDzA1x5OBe4Zv3QjSWbqDvMXC1gZfm5
	 E7mi5ZNpO0sQd312WiA5N1zt41hiIYKCdt9Ejfxi9KYJFH/iuXFetSvzp7rYT5jX5u
	 LNinEHs6zEcgKSAiR5t6RxlZ73eGvfnfELVKsZyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Xilin Wu <wuxilin123@gmail.com>
Subject: [PATCH 6.8 142/493] soc: qcom: pmic_glink: dont traverse clients list without a lock
Date: Mon, 27 May 2024 20:52:24 +0200
Message-ID: <20240527185635.094815680@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 635ce0db89567ba62f64b79e8c6664ba3eff6516 ]

Take the client_lock before traversing the clients list at the
pmic_glink_state_notify_clients() function. This is required to keep the
list traversal safe from concurrent modification.

Fixes: 58ef4ece1e41 ("soc: qcom: pmic_glink: Introduce base PMIC GLINK driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Tested-by: Xilin Wu <wuxilin123@gmail.com> # on QCS8550 AYN Odin 2
Link: https://lore.kernel.org/r/20240403-pmic-glink-fix-clients-v2-1-aed4e02baacc@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/pmic_glink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soc/qcom/pmic_glink.c b/drivers/soc/qcom/pmic_glink.c
index f913e9bd57ed4..2b2cdf4796542 100644
--- a/drivers/soc/qcom/pmic_glink.c
+++ b/drivers/soc/qcom/pmic_glink.c
@@ -115,10 +115,12 @@ static int pmic_glink_rpmsg_callback(struct rpmsg_device *rpdev, void *data,
 
 	hdr = data;
 
+	mutex_lock(&pg->client_lock);
 	list_for_each_entry(client, &pg->clients, node) {
 		if (client->id == le32_to_cpu(hdr->owner))
 			client->cb(data, len, client->priv);
 	}
+	mutex_unlock(&pg->client_lock);
 
 	return 0;
 }
@@ -168,8 +170,10 @@ static void pmic_glink_state_notify_clients(struct pmic_glink *pg)
 	}
 
 	if (new_state != pg->client_state) {
+		mutex_lock(&pg->client_lock);
 		list_for_each_entry(client, &pg->clients, node)
 			client->pdr_notify(client->priv, new_state);
+		mutex_unlock(&pg->client_lock);
 		pg->client_state = new_state;
 	}
 }
-- 
2.43.0



