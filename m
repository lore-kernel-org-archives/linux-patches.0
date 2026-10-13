Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5264EFFB7;
	Tue, 13 Oct 2026 12:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895363; cv=none; b=tKhC2NkWpO7WBw6U6hlzxIRZPIs45vELaOJjFRlJpr3LWLtp9ONv0/jMv/WZKJb8dRDAA7Rm/mH8Jk4xq+CLrFbdKTLRdoNAT/qar75HR17AB85cxdylz4hJkcYsMoS1miblop/PSkOTRyUbPgYJ6/DeCji9AIeclrZhMNPyp3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895363; c=relaxed/simple;
	bh=brafgsZU9GvukvErgGvh4h3I7MKGGQDcY0QKMhDEn00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a60vsp/Q9AYuUH9L7rvG0PuWpW14PPMfLx4vayLmRx1+K+zlRK9JBQQUKboUtRY++KOsYXQhayMTPPJLLh8G86CzBzGttd/Gk7jewjsuTNFNw2KtxsJqd/Xje2mztCsnFUbYRTBTI9z3BN4shb4c2RHt46dG3HnguIOUpwCpotQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8UonkMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8UonkMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CAA1F000FF;
	Tue, 13 Oct 2026 12:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895361;
	bh=ZtKuQT/9CKZFJn6TuB1OGoTfDpQAoP12cS6QqOYbShw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8UonkMRhjDKzFtGe0ry8UOyfJgIFaWDuTVPCXdApekRyaXLFphMeOlmHq7z2+dQu
	 qNegfLCY6jNm2307TJZR+g/o9tXFe7FU8+fMznpzSCL/gBUmxgX+QyyWcRTZbmmwH3
	 FBF2OXgLavqekXfosp1uqCeBFB6pa5gRxUoULcmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 249/497] iio: proximity: isl29501: Fix return type of isl29501_register_write
Date: Tue, 13 Oct 2026 13:36:56 +0200
Message-ID: <20261013112913.802307249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit e8dd273d199f5bbe295a8e3d8b777c5505b6b2e1 upstream.

isl29501_register_write() was returning a u32 instead of an int.
Since the function returns negative error codes (such as -ERANGE or
return values from i2c_smbus_write_byte_data()), returning an unsigned
integer type prevents callers from correctly checking for negative error
conditions.

Fix this by changing the function return type from u32 to int.

This was found through manual code review.

Fixes: 1c28799257bc ("iio: light: isl29501: Add support for the ISL29501 ToF sensor.")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/isl29501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/isl29501.c
+++ b/drivers/iio/proximity/isl29501.c
@@ -227,7 +227,7 @@ err:
 	return ret;
 }
 
-static u32 isl29501_register_write(struct isl29501_private *isl29501,
+static int isl29501_register_write(struct isl29501_private *isl29501,
 				   enum isl29501_register_name name,
 				   u32 value)
 {


