Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BF61F12E0;
	Tue,  3 Dec 2024 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240174; cv=none; b=tPM47ECKevASAy08vbS17CRwi+a67tC/YUBeMjraFHpNKpjpWTmv7Hx38BpeKa79emWMyuvPYlDlVjlxyGSsFcrAGMnuDkjBtV9LAMCMkQ6VY3UzYccR+3706pqA/M7xWgzy3bJJIGcpEco+R9FB5PLwPFCkwWsnKHfWsi0DZ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240174; c=relaxed/simple;
	bh=1mReyumraKDnMG2VX/+OJdxKiAwtTRugzyoxLm/KDAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRHvQPUNgu4A/AzwHZ/Fe73hvjNHitvBvGyLqTUKRfFco7rjODaWflonMA2q23J+YM6WP2WxgA9cVQIG23nhWNsn16oM9667xlSk3yYkr6uYPpfeCOpkQligm7q8iOd9uCLBqKHvz7EBUSd1mabfv0VGx+3Z90l6fNLJrkwVePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGQ1nAsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGQ1nAsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0F7C4CECF;
	Tue,  3 Dec 2024 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240174;
	bh=1mReyumraKDnMG2VX/+OJdxKiAwtTRugzyoxLm/KDAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGQ1nAsnLJResZGp0tNG7+VpuR2+p7yPdJkRljfHaY/d/Cf8/I1p7yH59kLFvuuTL
	 MOPd1tSPnA/Oc4oe3TZNF6oGaOlgm61ZPl1iz3EfwTUUgTRFwPHZlo9FfFDmMx8J9Z
	 Xs4e0ay0Ioo9p8aO9BI3sEjyYsu86JoLp7IxmUUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/826] crypto: qat - remove faulty arbiter config reset
Date: Tue,  3 Dec 2024 15:36:16 +0100
Message-ID: <20241203144745.383515618@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



