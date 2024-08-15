Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CCC1A00D2;
	Thu, 15 Aug 2024 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731363; cv=none; b=LGy53hvY6M8eqP6k+bxfgObGZAjeYUdGKsxQUjcxfgDterBCSlfn6d6HnIB5QqlQnVbuAD5dt+qfTI/9QDS8L7Eo772auubNKF3eoJRispRKK9wZpBMy2jEwBhud6v1xP40RuCvTBsfRIg8pV3G1LRNMHrCrDfonikzGtuRXSAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731363; c=relaxed/simple;
	bh=AeWq6fuDRO65o9cOiWGLokKj3GqnYploKdyp0hK+gIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IPNqoSAMdK4TpJT8EMCJVJo9cwG1EcoKGGe35NGF2lzF1kc+nuBglRhPPip9LgxuWOBkBu9lnnq4RjRPR1oRRMAMWZbum+6pS55dAnNyIOBRvnC/RzLmJc3JAI7n5TbI/wPAeKUMJvIlLqJSlm9ULm3cobgkgh6tTdkwGjrnC1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRW4ATwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRW4ATwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B889C32786;
	Thu, 15 Aug 2024 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731363;
	bh=AeWq6fuDRO65o9cOiWGLokKj3GqnYploKdyp0hK+gIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRW4ATwDhfJbb/asmz+tmPF2n/Mn/T2CIqQJYS3lsKNBq2Hcyrb6DEF6NfQTYl0nt
	 SvYCSo3wacSqSzEWzfDaJSux6H2wiSwuoiWAZL+v78droKnOAA0QxPRBrfZswx8rxt
	 PztYBTkeEb5HcBOthDV6ltPjdOQmtkhgi+EM1xag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 106/259] hwrng: amd - Convert PCIBIOS_* return codes to errnos
Date: Thu, 15 Aug 2024 15:23:59 +0200
Message-ID: <20240815131906.897797711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 14cba6ace79627a57fb9058582b03f0ed3832390 upstream.

amd_rng_mod_init() uses pci_read_config_dword() that returns PCIBIOS_*
codes. The return code is then returned as is but amd_rng_mod_init() is
a module_init() function that should return normal errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning it.

Fixes: 96d63c0297cc ("[PATCH] Add AMD HW RNG driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/hw_random/amd-rng.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -142,8 +142,10 @@ static int __init mod_init(void)
 
 found:
 	err = pci_read_config_dword(pdev, 0x58, &pmbase);
-	if (err)
+	if (err) {
+		err = pcibios_err_to_errno(err);
 		goto put_dev;
+	}
 
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0) {


