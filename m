Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0341F75AF;
	Tue,  3 Dec 2024 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237891; cv=none; b=A8mGvmyw0uVJ+VjfRY3KWINHTtp5d1C5TauvQnQkvE+5wWW4XQuVRTwn+NiWZz8h59HDN0dgSWUdU6oa2AKmqZzM+tlfbDc+3k4CL4TKZy0i/UN6eC8ang5Qtdp/xIB36z2R/u3wpOjNnodtw72WecfUvpK2V901kaL77qCmCAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237891; c=relaxed/simple;
	bh=xeHSGiZu4Y9YH8u7wKaLwD1Eu/3DYTTXRxo1M4yixcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rY7dmQLD72temD3FcqXI9bCvynh5LN9JDUoY3iq5Y/ehHU0aB3bw4UyWnoEWBkSpKLPH/iylcAbE3X+gEKub5dVa3hFq7Sn2RcwmMHcqUUA6ADssl2cRq6i6kcp9BnVVXGg2nxhlpDeoj7ZzZwRNB0xXPV37q9hpAwn1SBrmhgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyGSNxzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyGSNxzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BAFC4CECF;
	Tue,  3 Dec 2024 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237891;
	bh=xeHSGiZu4Y9YH8u7wKaLwD1Eu/3DYTTXRxo1M4yixcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yyGSNxzNOFpXf6bcIiabCBX9DNg3kj1Pbt98MVHtw8Ed2nVfbVrjdZoJZcoHkDQSz
	 Zs2dJ/7kYBReCFk9tPBuOVaa+dbwC1jFw23V4zuNvlbOZkovFykYFCK58GLRHBYXu9
	 YctiFqh3m6nezegU+fL3wzin/SsjVWWSgr9YaZ7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 097/817] crypto: qat - remove faulty arbiter config reset
Date: Tue,  3 Dec 2024 15:34:29 +0100
Message-ID: <20241203143959.491426979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 65bd26b25abce..f93d9cca70cee 100644
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



