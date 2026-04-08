Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101FC2BD030;
	Wed,  8 Apr 2026 18:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673408; cv=none; b=nD8tOqcC1ZFt/h5MEGJSUGLFmiCfiT7gJzRcx46DDrT6qohey9thWlBt8y/5epwiqDfjxcs7Igc72r1qpu81nWpS3KRLytMysSEEgCJCPf/oL1p8G9FGfJeFs3EwXghPxvRqupXj20NKGxthi6XVz//nW82DEl3q7b0aG54C/G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673408; c=relaxed/simple;
	bh=eqXoi9ncWsWForYeSrpIpyXdTE7SyWQgQNcl9/gZCCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUuaZcOJaAuVOKaXMAMPypbyEQ4cJX7eR9lG1Ta2SxX3jUbE8zXxLEfB5t5b3/9RkjxReiZFfkvJp9GhFm/6uxqzJ7+uNQv8GG0VkklOZZTJVWWqpkWItZFTxzPqwuqQi+uiNEMj0DrkjMFNZNSpAXmorbZcrbhPaE9uHh0fLM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJ+Obhvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJ+Obhvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A185C19421;
	Wed,  8 Apr 2026 18:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673407;
	bh=eqXoi9ncWsWForYeSrpIpyXdTE7SyWQgQNcl9/gZCCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJ+Obhvq+u+Lq3IPOU9GiBoTNwg7XzSFCOmFyqz42VcJLV6U6UTZnThPNlWNwzKw0
	 80S3nPSLg43M9t8JwjgqUNe4onoSWE9idTTxh2kMR+s28nlCv/mmocCtHZyOvHmbkS
	 X+ulTVnbEFDejZIVxT3DX4ZghBZW3JXlyjd7LBsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Conte <aldocontelk@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 188/277] iio: light: veml6070: fix veml6070_read() return value
Date: Wed,  8 Apr 2026 20:02:53 +0200
Message-ID: <20260408175940.884137349@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Conte <aldocontelk@gmail.com>

commit d0b224cf9ab12e86a4d1ca55c760dfaa5c19cbe7 upstream.

veml6070_read() computes the sensor value in ret but
returns 0 instead of the actual result. This causes
veml6070_read_raw() to always report 0.

Return the computed value instead of 0.

Running make W=1 returns no errors. I was unable
to test the patch because I do not have the hardware.
Found by code inspection.

Fixes: fc38525135dd ("iio: light: veml6070: use guard to handle mutex")
Signed-off-by: Aldo Conte <aldocontelk@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6070.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/iio/light/veml6070.c
+++ b/drivers/iio/light/veml6070.c
@@ -134,9 +134,7 @@ static int veml6070_read(struct veml6070
 	if (ret < 0)
 		return ret;
 
-	ret = (msb << 8) | lsb;
-
-	return 0;
+	return (msb << 8) | lsb;
 }
 
 static const struct iio_chan_spec veml6070_channels[] = {


