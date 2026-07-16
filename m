Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A79429022;
	Thu, 16 Jul 2026 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209964; cv=none; b=LNHn91P+k6Of7/JmUyiaO9qbYmLQij+GAVeUDrbIQ44lKig8jDsdo/8lKHOwj+cmLZ/OBnH3xC/uCHKKRnTK2tVfCYXwaMiChCfZnGtdnLQL8TjUX2Le7kxynoXKs5p5zm8rBPtD7ok7c0QF4AHel+jawGZ6Nz305QzLxtY7DVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209964; c=relaxed/simple;
	bh=ak4a5JNjCRYsdxHhwsWj5G5GQ1AdxVVDC/z1B9iVQVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5qbaJa1b/wJph2TIqqJ5EOmaveWOc2aTlwyqZlvaB+cDe08Od8coUp8xRVRbjbkVTTU78kKdlgK8AIljGwPOdoMOU5JFTO3iUlhg3d+jwYm15J2lojR7SqOKWFBw3xUNCvLqFm7Qebc89K7BmG30cl16aLP9ae9lR76dPZeSnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4EUIJ8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4EUIJ8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3AA01F00A3A;
	Thu, 16 Jul 2026 13:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209954;
	bh=RoU39pwboXEZcxCmVNAK4M1/TfbtGtukfgcdp709Uek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4EUIJ8/BmFeCd4LoLKX2YWU/jfzxLG65Hauk29qg8J4j2YMe39pCFj9DpbvviAWk
	 exR97o/XLA3++YC1ISGt+hKuz0pRqfm3HGqSUEjfcyKXesJFEYVXsdYDKWqpVkh3ho
	 59z7mEAdeE0WXswgIyEvlGkDm/XjeXzuOWzV/j2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7.1 381/518] crypto: qat - fix restarting state leak on allocation failure
Date: Thu, 16 Jul 2026 15:30:49 +0200
Message-ID: <20260716133056.165111390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

commit 7d3ed20f7e46b3e991936fedd7a28f3ff4aec8d2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -162,13 +162,14 @@ static int adf_dev_aer_schedule_reset(st
 	struct adf_reset_dev_data *reset_data;
 
 	if (!adf_dev_started(accel_dev) ||
-	    test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+	    test_and_set_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
 		return 0;
 
-	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	reset_data = kzalloc_obj(*reset_data);
-	if (!reset_data)
+	if (!reset_data) {
+		clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 		return -ENOMEM;
+	}
 	reset_data->accel_dev = accel_dev;
 	init_completion(&reset_data->compl);
 	reset_data->mode = mode;


