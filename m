Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9054A3161BC;
	Wed,  3 Dec 2025 15:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776537; cv=none; b=EbZaNza/0CaMXqSpoSBaBcmZfo2KcoGs4foiU3U9HfEmPX3gz/CQuE+xMe534f7CTK3J/A5PgMzu0b2I8Wcb1W9ytXcjJDtQguMkH2rVKuLWm5V2z9lX4RNa8Q6vAoUhlGSACd65jc5fTa325tndxjydqw0KJHbhiS4QkQa6oEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776537; c=relaxed/simple;
	bh=LftdVImH2mB0LPHx/ADMMcvZXTulyyNUyV/ODs4zOQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMsjLQq2BdHxIO9GQ6o/9vyeP0DolAKLMjQYHoqYQoIV6tOUv9OSOnG046loz2vpccaf0exXOO6pOMZKon8uP+qryFYMMK63M0D8Fg0NtjyrWsicqizde8iaAESVy/ejnEQlJNd6C94VYUDtbcwYFv40EVSV0JJ8We9q/gE10rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqBEl2Gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqBEl2Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B81C16AAE;
	Wed,  3 Dec 2025 15:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776537;
	bh=LftdVImH2mB0LPHx/ADMMcvZXTulyyNUyV/ODs4zOQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqBEl2GrfR/Z1ODhaXCNFJjS6htEje50RpPQ9fxyJMlHQNYzE+VFk8rpIaQqlslGn
	 7x2JW+JUsu3Evum61ZKo+j2S6PJHDDvBLP0Md0dEhFy6y+qXb4YuyBB1Vims1O7OTU
	 7oQMX8vpr7GYmIX6MEqfxZ/2BngobS6a0S7W3ais=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.10 213/300] EDAC/altera: Use INTTEST register for Ethernet and USB SBE injection
Date: Wed,  3 Dec 2025 16:26:57 +0100
Message-ID: <20251203152408.513207195@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>

commit 281326be67252ac5794d1383f67526606b1d6b13 upstream.

The current single-bit error injection mechanism flips bits directly in ECC RAM
by performing write and read operations. When the ECC RAM is actively used by
the Ethernet or USB controller, this approach sometimes trigger a false
double-bit error.

Switch both Ethernet and USB EDAC devices to use the INTTEST register
(altr_edac_a10_device_inject_fops) for single-bit error injection, similar to
the existing double-bit error injection method.

Fixes: 064acbd4f4ab ("EDAC, altera: Add Stratix10 peripheral support")
Signed-off-by: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251111081333.1279635-1-niravkumarlaxmidas.rabara@altera.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1332,7 +1332,7 @@ static const struct edac_device_prv_data
 	.ue_set_mask = ALTR_A10_ECC_TDERRA,
 	.set_err_ofst = ALTR_A10_ECC_INTTEST_OFST,
 	.ecc_irq_handler = altr_edac_a10_ecc_irq,
-	.inject_fops = &altr_edac_a10_device_inject2_fops,
+	.inject_fops = &altr_edac_a10_device_inject_fops,
 };
 
 #endif	/* CONFIG_EDAC_ALTERA_ETHERNET */
@@ -1422,7 +1422,7 @@ static const struct edac_device_prv_data
 	.ue_set_mask = ALTR_A10_ECC_TDERRA,
 	.set_err_ofst = ALTR_A10_ECC_INTTEST_OFST,
 	.ecc_irq_handler = altr_edac_a10_ecc_irq,
-	.inject_fops = &altr_edac_a10_device_inject2_fops,
+	.inject_fops = &altr_edac_a10_device_inject_fops,
 };
 
 #endif	/* CONFIG_EDAC_ALTERA_USB */


