Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EF114D29D;
	Fri,  6 Dec 2024 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496709; cv=none; b=rjL6jZT1YFPMN6acX7x/An/CcsNSyo/gvXwAyqp90OvWJahggMXjuMwkqjivztQkfHy1E8YISGsvudRprpgDmqtFFvqe84y9lyqc7XR/dCwTjwfYxrArXjTm+5VDF9aUvrNsBa7WWqX2cPqmWPpNbbNpn2yfwmVOSkTEFe7p8fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496709; c=relaxed/simple;
	bh=cE/5aEZ0O6z02pMkHlijrIKlkFZmptPVmWrnW/+WFWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz7exs5wXYA/RQZ/rjmTQt7zfWrqmpur+ryMHr/6cwemAPJo2G67n4oi06AMzAubQ6libGyfjkh5oXnGpniO7qAIU4y7l3taX+x64iJZVeQWcR4ktMLjp1QOIcMw/jvixfSjNvohJtWumlULoLaaR3+DmoX7rp7ctgQxEJcCViw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERlS71JH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERlS71JH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E97AC4CED1;
	Fri,  6 Dec 2024 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496708;
	bh=cE/5aEZ0O6z02pMkHlijrIKlkFZmptPVmWrnW/+WFWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERlS71JHrv8h8/J3gvAV2ZVUn6ePgM75hcnK+mPJ8ye3yd7YyZWM+lpx1xGmwUXBl
	 wUUnQRWMA54TR5oBu9bJGmFH7GUwsMESP/yLOkCGaB/ODy2I55pojVBQNbbMKu5kmN
	 JHGR7YX8S5wb9W5F8q7FVFVYjzwKvNOX/0Q5bTiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/676] crypto: qat - remove faulty arbiter config reset
Date: Fri,  6 Dec 2024 15:28:21 +0100
Message-ID: <20241206143656.567986799@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 70199359902f1c7187dcb28a1be679a7081de7cc ]

Resetting the service arbiter config can cause potential issues
related to response ordering and ring flow control check in the
event of AER or device hang. This is because it results in changing
the default response ring size from 32 bytes to 16 bytes. The service
arbiter config reset also disables response ring flow control check.
Thus, by removing this reset we can prevent the service arbiter from
being configured inappropriately, which leads to undesired device
behaviour in the event of errors.

Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
index da69566992467..dd9a31c20bc9c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_hw_arbiter.c
@@ -90,10 +90,6 @@ void adf_exit_arb(struct adf_accel_dev *accel_dev)
 
 	hw_data->get_arb_info(&info);
 
-	/* Reset arbiter configuration */
-	for (i = 0; i < ADF_ARB_NUM; i++)
-		WRITE_CSR_ARB_SARCONFIG(csr, arb_off, i, 0);
-
 	/* Unmap worker threads to service arbiters */
 	for (i = 0; i < hw_data->num_engines; i++)
 		WRITE_CSR_ARB_WT2SAM(csr, arb_off, wt_off, i, 0);
-- 
2.43.0



