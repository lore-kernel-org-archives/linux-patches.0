Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2AE343893;
	Sat, 12 Sep 2026 09:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206393; cv=none; b=bjFD1BrvRzHHzcfgzTFTXXgS6EwBl8eXZSJ2IpJmCcmNhjbyKcvCToFfcFn2ZuYLbdOc8vq3FDejMePPNffnxbLoSc700pyABismoOHez3Pe+lMNvK8veMYCiM5ok4cA4Hzb4s6uVual70Dybb3uRhgDABzW2eWuxTF2SFpwtrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206393; c=relaxed/simple;
	bh=I8ppWXTWq5AZntu+yWMy+b+S0hHkhUxxJEuRpXrPEFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdlunyxSK/+e9GAEiUHkHyBxQByM7emDtxvNtZUmw6I3/YaJh9pTkPuny0TdjTcDaAY8B6fcHGgYkKrsRxbDyxA/iEMrPVTpAdVECzR02A0YgYnLzvcauHd0zlzA2LvCk2fW6X36EX1cd4WGlkelpdLYSp2KlSUifrbxXVTxuZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGmlG1iR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGmlG1iR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B3E1F000FF;
	Sat, 12 Sep 2026 09:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206392;
	bh=LTapE6D/i9i/e/90V+P/s+6EReYCJhJV2HRkjP1ru40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGmlG1iRwwW+cWWaa2J3nlDMNgtzgl7c87wcfJQeQ6QTgbwS3usE++c2cZj/N8o4E
	 1gjGQJJi+oGJk+2Y3n36n66OQRKUN69HjI0M9jrbMnbAw8oWc/0VDIj/8bD1x9roBW
	 z65fDSbpE07v6JVyLxlQmJP/cpKP04c2zn9sX+4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0199/1518] crypto: qat - cancel work on re-enable SR-IOV timeout
Date: Sat, 12 Sep 2026 08:39:28 +0200
Message-ID: <20260912065627.991154163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 455b0f3ac9e254edab9f5a873d337abe5e6e3604 ]

The QAT reset worker queues SR-IOV reenable work using a work_struct and
completion embedded in an on-stack adf_sriov_dev_data. If the completion
wait times out, the reset worker can return while device_sriov_wq still
holds or executes the stack-backed work item.

Cancel the work on the device_sriov_wq on timeout before the stack frame
unwinds.

Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index f26cadc19d6bb..ea826333c45f4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -190,6 +190,8 @@ static void adf_device_reset_worker(struct work_struct *work)
 	queue_work(device_sriov_wq, &sriov_data.sriov_work);
 	if (wait_for_completion_timeout(&sriov_data.compl, wait_jiffies))
 		adf_pf2vf_notify_restarted(accel_dev);
+	else
+		cancel_work_sync(&sriov_data.sriov_work);
 
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
-- 
2.53.0



