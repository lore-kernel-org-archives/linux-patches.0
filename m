Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF558F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A72C433C7;
	Sun, 16 Jul 2023 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537642;
	bh=pliFVdMuf51GMDN9egQxiP92mH1yOS+LjzSYlEzTJBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlXUSFFBVBJ/txBb+dkhqk2OOYxLGsbhXy5dfzZTEgRkJF1pDA46BeTjiRZEcibJC
	 pv0GfTDSL401ZMZBa5fAnOWm6MzZprH1E5EGWTSxYmk8h/tmJDslHRyIamCIbajnWV
	 9P4MJMbIlgCX9QDrD/bZi7vJ8Y9qmsAsuB1YMoLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 168/800] wifi: ath11k: Add missing check for ioremap
Date: Sun, 16 Jul 2023 21:40:21 +0200
Message-ID: <20230716194953.011425951@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 16e0077e14a73866e9b0f4a6bf4ad3d4a5cb0f2a ]

Add check for ioremap() and return the error if it fails in order to
guarantee the success of ioremap(), same as in
ath11k_qmi_load_file_target_mem().

Fixes: 6ac04bdc5edb ("ath11k: Use reserved host DDR addresses from DT for PCI devices")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230608022858.27405-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index ab923e24b0a9c..2328b9447cf1b 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2058,6 +2058,9 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
 			ab->qmi.target_mem[idx].iaddr =
 				ioremap(ab->qmi.target_mem[idx].paddr,
 					ab->qmi.target_mem[i].size);
+			if (!ab->qmi.target_mem[idx].iaddr)
+				return -EIO;
+
 			ab->qmi.target_mem[idx].size = ab->qmi.target_mem[i].size;
 			host_ddr_sz = ab->qmi.target_mem[i].size;
 			ab->qmi.target_mem[idx].type = ab->qmi.target_mem[i].type;
@@ -2083,6 +2086,8 @@ static int ath11k_qmi_assign_target_mem_chunk(struct ath11k_base *ab)
 					ab->qmi.target_mem[idx].iaddr =
 						ioremap(ab->qmi.target_mem[idx].paddr,
 							ab->qmi.target_mem[i].size);
+					if (!ab->qmi.target_mem[idx].iaddr)
+						return -EIO;
 				} else {
 					ab->qmi.target_mem[idx].paddr =
 						ATH11K_QMI_CALDB_ADDRESS;
-- 
2.39.2



