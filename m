Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E124307AD;
	Tue, 21 Jul 2026 22:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672972; cv=none; b=KMO/GqenO1aDDP3TCPM9xbaNM3q7XvuxQcqFdGjT4l9A0o+zxS710hx/uRXo0wqEsrnqSOfPeM+Wi8q4Qg1jULax9RDWvaIXz7ncPtqNWfkT/UANtnmcHnM8SDfBs6tShSEk59Q0G7eiAXpQyTxcEVhIcoUfzGL5pVg294+pGa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672972; c=relaxed/simple;
	bh=kG/AKrpfg8FOjXGeVjlj+lY6E/HNRCPFVJcMkbhbLDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNJaLeTgwxPeVU8+oVHjA7+FHR8LqGJjqRwko/ShyJ2CllhtZEVSsSFKW5o6xsLjj5c0ok00CbAE/17TH7h7Ac0KhkWUv1i6fhonQ3OTCz4xZtaev49rFKZ7LoSMiAp16CfMwOjV4jbUexihXEUwPRVAhGx3wSrE8+opAjyDooo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1/3sfWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1/3sfWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680AB1F000E9;
	Tue, 21 Jul 2026 22:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672970;
	bh=cmN5o+nvwBGHsosDWK8yJChR+OmgSBRxzFSoB49X0xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1/3sfWULMfFDCCQUhSs9CgRKC3SzIbZ7jrE0baLKjiWSVrVlKWpJRW/tqeQNWQ5o
	 qouURo8ApPiiYOcMmBga/8Ye+ImLrIgjhyIQ8T7O8/eJhAJTz8BS9haCn+IfAnv5Xz
	 C4M3LlRcshRfDTmyqTpUDl/MUatBAuRb8emcEW+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 827/843] crypto: qat - fix restarting state leak on allocation failure
Date: Tue, 21 Jul 2026 17:27:42 +0200
Message-ID: <20260721152424.680918829@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 7d3ed20f7e46b3e991936fedd7a28f3ff4aec8d2 ]

In adf_dev_aer_schedule_reset(), ADF_STATUS_RESTARTING is set before
allocating reset_data. If the allocation fails, the function returns
-ENOMEM without queuing reset work, so nothing ever clears the bit.
This leaves the device permanently stuck in the restarting state,
causing all subsequent reset attempts to be silently skipped.

Fix this by using test_and_set_bit() to atomically claim the
RESTARTING state, preventing duplicate reset scheduling races under
concurrent fatal error reporting. If the subsequent allocation fails,
clear the bit to restore clean state so future reset attempts can
proceed.

Cc: stable@vger.kernel.org
Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Co-developed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/adf_aer.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -116,13 +116,14 @@ static int adf_dev_aer_schedule_reset(st
 	struct adf_reset_dev_data *reset_data;
 
 	if (!adf_dev_started(accel_dev) ||
-	    test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+	    test_and_set_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
 		return 0;
 
-	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	reset_data = kzalloc(sizeof(*reset_data), GFP_KERNEL);
-	if (!reset_data)
+	if (!reset_data) {
+		clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 		return -ENOMEM;
+	}
 	reset_data->accel_dev = accel_dev;
 	init_completion(&reset_data->compl);
 	reset_data->mode = mode;


