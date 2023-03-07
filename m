Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19995BA4F
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 19:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A65FC4339B;
	Tue,  7 Mar 2023 19:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678216143;
	bh=XZMtCxacqirtNhf3V1gRSzefMyOtNwylM05BdngGa9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TA0GH1TKrlx349V38lt4hnGW7SCzT66WaLwjk/9ww0IdjZmtT3G6mnHTyoHcK8ru0
	 Q84uhQOIh6aMXAal0tQj6yEimMW5D/mRms/HC9KPQIMXGlO8ASz+UT8rEVpdy+KaYF
	 pHhJ94AewZAjQyWFQNYXPhis4snUDzUj6q4GpcQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladis Dronov <vdronov@redhat.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Fiona Trahe <fiona.trahe@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 489/567] crypto: qat - fix out-of-bounds read
Date: Tue,  7 Mar 2023 18:03:45 +0100
Message-Id: <20230307165927.135970855@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

commit f6044cc3030e139f60c281386f28bda6e3049d66 upstream.

When preparing an AER-CTR request, the driver copies the key provided by
the user into a data structure that is accessible by the firmware.
If the target device is QAT GEN4, the key size is rounded up by 16 since
a rounded up size is expected by the device.
If the key size is rounded up before the copy, the size used for copying
the key might be bigger than the size of the region containing the key,
causing an out-of-bounds read.

Fix by doing the copy first and then update the keylen.

This is to fix the following warning reported by KASAN:

	[  138.150574] BUG: KASAN: global-out-of-bounds in qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
	[  138.150641] Read of size 32 at addr ffffffff88c402c0 by task cryptomgr_test/2340

	[  138.150651] CPU: 15 PID: 2340 Comm: cryptomgr_test Not tainted 6.2.0-rc1+ #45
	[  138.150659] Hardware name: Intel Corporation ArcherCity/ArcherCity, BIOS EGSDCRB1.86B.0087.D13.2208261706 08/26/2022
	[  138.150663] Call Trace:
	[  138.150668]  <TASK>
	[  138.150922]  kasan_check_range+0x13a/0x1c0
	[  138.150931]  memcpy+0x1f/0x60
	[  138.150940]  qat_alg_skcipher_init_com.isra.0+0x197/0x250 [intel_qat]
	[  138.151006]  qat_alg_skcipher_init_sessions+0xc1/0x240 [intel_qat]
	[  138.151073]  crypto_skcipher_setkey+0x82/0x160
	[  138.151085]  ? prepare_keybuf+0xa2/0xd0
	[  138.151095]  test_skcipher_vec_cfg+0x2b8/0x800

Fixes: 67916c951689 ("crypto: qat - add AES-CTR support for QAT GEN4 devices")
Cc: <stable@vger.kernel.org>
Reported-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Tested-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -434,8 +434,8 @@ static void qat_alg_skcipher_init_com(st
 	} else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
 		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
 					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
-		keylen = round_up(keylen, 16);
 		memcpy(cd->ucs_aes.key, key, keylen);
+		keylen = round_up(keylen, 16);
 	} else {
 		memcpy(cd->aes.key, key, keylen);
 	}


