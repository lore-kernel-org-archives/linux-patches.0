Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298541CFECF;
	Wed,  2 Oct 2024 13:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877300; cv=none; b=MHFRwVCrB51pxN+0cHt1/7+t5YMfU2IaJy7VPYp0HeF6PbhEUgnJd1nNsczfcjxcsEC7EaTaOwZQCr/qI8PYq1Uis6h2zv/Yl2S/GCZjTGvgognAz8rPMMmy+pNq4rO+mV4Oi1hkAf/9zBSw+bZJPzlKIisxvThSHWWDUaOYjoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877300; c=relaxed/simple;
	bh=GhFTIITOsWIEEhqUxzL8qZFPxEcZLJz39REo+ZF48xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP/tGNKJ2g+kXrxTOWRIOvnrnG9ANYmOaJvoI7Zvy1WDfIa5e79cUUy5Ur4dltyALQ7BtWLXPmmzez9KVKWEYnKAjZ5lRQ2vydW/22mcJG/QyloB+4A2UqCCFXHTeTBjO9yIERCfjbzjOLXjOwcKUwtP2YIWDtidwbzeRyGJkbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jfwAkEEd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jfwAkEEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FF5C4CEFC;
	Wed,  2 Oct 2024 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877299;
	bh=GhFTIITOsWIEEhqUxzL8qZFPxEcZLJz39REo+ZF48xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfwAkEEd+E8/kxwKO9icuMw/lT6zdi7qS12X9V6CA6Ab9P8YDnggeiu4l1L00I4J4
	 7ZDzeTtja6gfZ6saZAhTfQrpHqNp9cseviafRtxND/SAcmkR2iKdNax+Vafgs/zQh3
	 BxPrz7hOQDDZm1TeYs+LdMcF+g8ZXVUYL4w+PjQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tom Zanussi <tom.zanussi@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 008/634] crypto: iaa - Fix potential use after free bug
Date: Wed,  2 Oct 2024 14:51:48 +0200
Message-ID: <20241002125811.419406352@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e0d3b845a1b10b7b5abdad7ecc69d45b2aab3209 ]

The free_device_compression_mode(iaa_device, device_mode) function frees
"device_mode" but it iss passed to iaa_compression_modes[i]->free() a few
lines later resulting in a use after free.

The good news is that, so far as I can tell, nothing implements the
->free() function and the use after free happens in dead code.  But, with
this fix, when something does implement it, we'll be ready.  :)

Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management along with fixed mode")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index e810d286ee8c4..237f870000702 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -495,10 +495,10 @@ static void remove_device_compression_modes(struct iaa_device *iaa_device)
 		if (!device_mode)
 			continue;
 
-		free_device_compression_mode(iaa_device, device_mode);
-		iaa_device->compression_modes[i] = NULL;
 		if (iaa_compression_modes[i]->free)
 			iaa_compression_modes[i]->free(device_mode);
+		free_device_compression_mode(iaa_device, device_mode);
+		iaa_device->compression_modes[i] = NULL;
 	}
 }
 
-- 
2.43.0



