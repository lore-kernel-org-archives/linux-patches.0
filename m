Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96141DA4C;
	Tue, 10 Sep 2024 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965172; cv=none; b=FZzZZFG9n7Zj1QIRU6Wj4Outf/Z8I6GoWQmDJRLYmgOiOcRrgni925lbA8ZXNe5eM9Kfr5gB7hQ3G93uKPq0hmrI8hyCjroMUTmzwacrfaeI4qUMMNP2R1hCUF8+AwLkec7YkUYbAAjafMtwI6tjQyNW9ReBnuunve4Vc9GaIiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965172; c=relaxed/simple;
	bh=cZkpI32eDzWCLa6htqS1yM7looDtFwsEJkRkGaOL5LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsTsCWhGmd22JhrpWv5Pxs3O6HSvg9UyNL7SOjRbox3p8x+zLtlmOEofpUb3+rMKsdqX7+WOysN3QYy4e1fq7MCHXZCws0Rdctcfdi0VrZC1WziD/cHjfBNg6t1h8dybRemjpBpfLZxoFnuXTkKu6HSrFc9N27ITqKzfc2WeyD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnGb8Ieh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnGb8Ieh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299EFC4CEC3;
	Tue, 10 Sep 2024 10:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965172;
	bh=cZkpI32eDzWCLa6htqS1yM7looDtFwsEJkRkGaOL5LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnGb8IehRa3kLrY50hYza+6UWHb2qdbAQzmK7G/V+fak1eJ29veYh3vMfrERRoqNa
	 DCF+fP7JBYQW585qS7w921GQ3pa/mfwtM4IMC2qR0ftLysacwCj7IuaRxqsLWco1kD
	 JZsHuyv57IXwPeC7zqpGAnTHR0pb+I+wnpIMdKPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dumitru Ceclan <dumitru.ceclan@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 162/186] iio: adc: ad7124: fix chip ID mismatch
Date: Tue, 10 Sep 2024 11:34:17 +0200
Message-ID: <20240910092601.288124497@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -500,6 +500,7 @@ static int ad7124_soft_reset(struct ad71
 	if (ret < 0)
 		return ret;
 
+	fsleep(200);
 	timeout = 100;
 	do {
 		ret = ad_sd_read_reg(&st->sd, AD7124_STATUS, 1, &readval);


