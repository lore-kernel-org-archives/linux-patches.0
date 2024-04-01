Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5509446AC;
	Mon,  1 Apr 2024 16:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988010; cv=none; b=XIGbJ2X9Q9pDlKWBgQRG0RGG2MOuoLcjfRmKplq5OvBgq05WnR7pCMG+P6uddaoWajEMTTlGEv/K3QN1wZLPtF3Zw75/XL32xl+PimL16z+0ixr5DXVmDET0qa3SVv6xdYUfAuuBfPvriKnrMtLF+hyfB2iwLQlgYqmBcaeZNng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988010; c=relaxed/simple;
	bh=I6+2lTaIvTWiJxoQ6dJksb72tHhvoIUmTsJC9busXu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFB8XgRf9BrwY4oYBrXZ079ucZQ5Z7raUsW09ERcqD/EKkBB2ljoLrHkweMqIQ1Mv+bDAfQmmMavVtR1mv2b+MDQtkpQ7rEyHp8wA15xa1sFo1IF50fRWM/6PZF6oMi4qgbewQWA6DHgKQweMiri069luUD/dKORDu6MTVy+q0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ob3M9iEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ob3M9iEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544C0C433F1;
	Mon,  1 Apr 2024 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988009;
	bh=I6+2lTaIvTWiJxoQ6dJksb72tHhvoIUmTsJC9busXu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ob3M9iEk2XAMQaYA7glhlnng+wtXXNFmKhq/EEBUSv4oPgqbAj+wKFd0mis9XvJJj
	 b0l3QDz4KVbYHKx//mzm1Hhs6aUjB5/nQpeqaR7m7jtE8S9jb9qkYmS2T68wQnR2rj
	 riymCZgAtxUoCeA6capYC1ixDvwFTCg0isEEQXbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 040/432] crypto: qat - change SLAs cleanup flow at shutdown
Date: Mon,  1 Apr 2024 17:40:27 +0200
Message-ID: <20240401152554.326872798@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damian Muszynski <damian.muszynski@intel.com>

[ Upstream commit c2304e1a0b8051a60d4eb9c99a1c509d90380ae5 ]

The implementation of the Rate Limiting (RL) feature includes the cleanup
of all SLAs during device shutdown. For each SLA, the firmware is notified
of the removal through an admin message, the data structures that take
into account the budgets are updated and the memory is freed.
However, this explicit cleanup is not necessary as (1) the device is
reset, and the firmware state is lost and (2) all RL data structures
are freed anyway.

In addition, if the device is unresponsive, for example after a PCI
AER error is detected, the admin interface might not be available.
This might slow down the shutdown sequence and cause a timeout in
the recovery flows which in turn makes the driver believe that the
device is not recoverable.

Fix by replacing the explicit SLAs removal with just a free of the
SLA data structures.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index de1b214dba1f9..d4f2db3c53d8c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -788,6 +788,24 @@ static void clear_sla(struct adf_rl *rl_data, struct rl_sla *sla)
 	sla_type_arr[node_id] = NULL;
 }
 
+static void free_all_sla(struct adf_accel_dev *accel_dev)
+{
+	struct adf_rl *rl_data = accel_dev->rate_limiting;
+	int sla_id;
+
+	mutex_lock(&rl_data->rl_lock);
+
+	for (sla_id = 0; sla_id < RL_NODES_CNT_MAX; sla_id++) {
+		if (!rl_data->sla[sla_id])
+			continue;
+
+		kfree(rl_data->sla[sla_id]);
+		rl_data->sla[sla_id] = NULL;
+	}
+
+	mutex_unlock(&rl_data->rl_lock);
+}
+
 /**
  * add_update_sla() - handles the creation and the update of an SLA
  * @accel_dev: pointer to acceleration device structure
@@ -1155,7 +1173,7 @@ void adf_rl_stop(struct adf_accel_dev *accel_dev)
 		return;
 
 	adf_sysfs_rl_rm(accel_dev);
-	adf_rl_remove_sla_all(accel_dev, true);
+	free_all_sla(accel_dev);
 }
 
 void adf_rl_exit(struct adf_accel_dev *accel_dev)
-- 
2.43.0



