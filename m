Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF42B45A2A8;
	Tue, 21 Jul 2026 21:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667898; cv=none; b=gl0wvuNBGTmvAUazEYs2CquUzgX64FDthmzy1v3Rf9p0tAiwO+OLGlIgxVb9n6qtW4c2Qr6tf/Q2BKQsB7oMEVFzZ/j0jrXqbuo6xkGkaFqqaNUgzOWjzzRf7Z7SmMmloa0glKSmJa9WmllFXLRzsBYTWFiMxiYYfrMXK/9sYP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667898; c=relaxed/simple;
	bh=4DSVtMCKhv5I7M3aqEf8Naft3fVpByXVHzpW4tAgcDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQOXKh1hUmIW3p/TjtiDxWVyirxNgimZpooSqd0TLBzDyoTBplztMhx9eirDQ82orl8ncfVvV4QODf3AzzdKdALUJp5N1rojymZWpooIW0LdWnEFrXuZxSZKhhMrhoudGz3AS/lz7qPfsCgm3e6lYukbYJlyaj55ITfZdTcyGoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5dSB7Pc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5dSB7Pc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82B51F00A3A;
	Tue, 21 Jul 2026 21:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667896;
	bh=JPUrcLMzDxrOWG/UhSNX5Zd3yZTvGFZMni2M+TUjOOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5dSB7PcIub64vwBA5/JIkPDCGQQTHqSXGYJiDQL36Fixkjny7e4mjajkzGNNttRR
	 7Pme+lWdpyEc8ybp+DbLhtMrJh+2HyFnzPlvzFOIr3WAcietp3M3FEDnymDoLDlZda
	 86PK3iZNThkzmq+3ksWxeCDsTD31iGkNjnYjYewQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1233/1266] crypto: qat - fix restarting state leak on allocation failure
Date: Tue, 21 Jul 2026 17:27:50 +0200
Message-ID: <20260721152509.400024817@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/intel/qat/qat_common/adf_aer.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -113,13 +113,14 @@ static int adf_dev_aer_schedule_reset(st
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


