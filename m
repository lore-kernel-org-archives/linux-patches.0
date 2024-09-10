Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C875224F6;
	Tue, 10 Sep 2024 09:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962087; cv=none; b=S1gFVpBI0qV5RjocshAFYAaXWujG2JEwSFlf4x54TaQvjxJW3GqwT9cFy5WETW7kKK0u+KX2c4vxfjf92CFEUgKz9i6bMT/e+HVCdLCHO6WueHOzL502eIz/c9RdwtP3ROoTdzT/eyXqr2BksWfIB3VfdNecFZ2bIlTuLKxB+Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962087; c=relaxed/simple;
	bh=eAaByXSZ86Kl5EYyxRVidVs7tjqEmuKPbqMR69fpnYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1QxmfjA2Dzy4R6wBWiqNPQv+y0BDNvnJXzT65q1lwUFCC0IZAeROLAf+wMiLMEV1L+2ltMwdKLin3RN2WSt48vQVOdxsav7E0CNFE5nJiru2EeV0usCLyLUfpLHu5ZIpVpx1G598FjyqemRtxUj/EIgQ+4BCKXvD7u0uMvXJBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMJ1jom5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMJ1jom5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE658C4CEC3;
	Tue, 10 Sep 2024 09:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962087;
	bh=eAaByXSZ86Kl5EYyxRVidVs7tjqEmuKPbqMR69fpnYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMJ1jom5FKWlOx4tzXP62sKxcF5dPPIUQze58NaUHWpyAVtTldy5+k0FvN93l6Ldm
	 50wmXxdakwjPFHfXRz1/af/hG19nJHPG/D0Cd073+otUjF5YDRSUgB3aX7rMgv0416
	 58icJQrzxQboceh96EqlFKeO5bU1deUPAYRq9UBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dumitru Ceclan <dumitru.ceclan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.10 291/375] iio: adc: ad7124: fix chip ID mismatch
Date: Tue, 10 Sep 2024 11:31:28 +0200
Message-ID: <20240910092632.339767090@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Dumitru Ceclan <mitrutzceclan@gmail.com>

commit 96f9ab0d5933c1c00142dd052f259fce0bc3ced2 upstream.

The ad7124_soft_reset() function has the assumption that the chip will
assert the "power-on reset" bit in the STATUS register after a software
reset without any delay. The POR bit =0 is used to check if the chip
initialization is done.

A chip ID mismatch probe error appears intermittently when the probe
continues too soon and the ID register does not contain the expected
value.

Fix by adding a 200us delay after the software reset command is issued.

Fixes: b3af341bbd96 ("iio: adc: Add ad7124 support")
Signed-off-by: Dumitru Ceclan <dumitru.ceclan@analog.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240731-ad7124-fix-v1-1-46a76aa4b9be@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -766,6 +766,7 @@ static int ad7124_soft_reset(struct ad71
 	if (ret < 0)
 		return ret;
 
+	fsleep(200);
 	timeout = 100;
 	do {
 		ret = ad_sd_read_reg(&st->sd, AD7124_STATUS, 1, &readval);


