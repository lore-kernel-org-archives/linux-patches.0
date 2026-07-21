Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C561E44AB6A;
	Tue, 21 Jul 2026 22:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673146; cv=none; b=oSYw/+YqLU56hWcaEkEVFoerZ8UxdDL43b5zr9oEa9gHW3eZWJTC8xveJOkZuBKzSLzcokuYMQugTkjj51Vmksc1nrTGTSm4DBVNeOwOTVqdMNLnBlGy9F5WTabfutkM8liQ+PSuTgkVFRW8mohqdSEgCKIwU+V6zjpx/1ltssU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673146; c=relaxed/simple;
	bh=vYHmUumQZtIXJj7e3qkKP/qclsxqLu+lr7FBYqjXP5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkk62N35lB1h737tjp07tkJ1Opjjl1D7tEPLKa+4N1VWRvItUl9tHiyaCYKv3+ZuBcSwRrD8Na516JEf7wEjCi53mB9xXutPGsfY7PcepjqrQbDxKRH4UVoTOUvk0q2/PAigv1WEfawEOEVWBOI7/ifpRj5ZF4N34cyU7vIGwPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ak80GERd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ak80GERd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E4D1F000E9;
	Tue, 21 Jul 2026 22:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673145;
	bh=P3OZH3RcjMo6sdU339g21CCna/OfMEqGjNHVKpzdhNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ak80GERdc06nWwRC2xk/Idr/FHzbc6VGjCq17OnCMfBdIGLB1w3oK2sS7b3JrtG3y
	 EIKBJ49sMBBnK634c3JDzfQd+/tkCylYEkKTpYdTAZNLv+pjGXMb2lneGguAMQaFk3
	 xZTZ4eMPO2LosI22chZJ3he3UvNV3zlXBgw9jBi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 035/699] iio: accel: bmc150: clamp the device-reported FIFO frame count
Date: Tue, 21 Jul 2026 17:16:34 +0200
Message-ID: <20260721152356.501223035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit ce0e1cae26096fe959a0da5563a6d6d5a801d5fb upstream.

__bmc150_accel_fifo_flush() copies the number of samples the device
reports in its hardware FIFO into an on-stack buffer

	u16 buffer[BMC150_ACCEL_FIFO_LENGTH * 3];

which is sized for at most BMC150_ACCEL_FIFO_LENGTH (32) samples. The
frame count is read from the FIFO_STATUS register and only masked to its
7 valid bits:

	count = val & 0x7F;

so it can be 0..127. The only other limit applied to it is the optional
caller-supplied sample budget:

	if (samples && count > samples)
		count = samples;

which does not constrain count on the flush-all path (samples == 0), and
leaves it well above 32 whenever samples is larger. count samples are
then transferred into buffer[]:

	bmc150_accel_fifo_transfer(data, (u8 *)buffer, count);

bmc150_accel_fifo_transfer() reads count * 6 bytes through regmap, so a
malfunctioning, malicious or counterfeit accelerometer (or an attacker
tampering with the I2C/SPI bus) that reports up to 127 frames writes up
to 762 bytes into the 192-byte buffer: a stack out-of-bounds write of up
to 570 bytes that clobbers the stack canary, saved registers and the
return address.

Clamp count to BMC150_ACCEL_FIFO_LENGTH, the number of samples buffer[]
is sized for, before the transfer, mirroring the watermark clamp already
done in bmc150_accel_set_watermark(). A well-formed flush reports at most
BMC150_ACCEL_FIFO_LENGTH frames, so legitimate devices are unaffected.

Fixes: 3bbec9773389 ("iio: bmc150_accel: add support for hardware fifo")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/bmc150-accel-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -919,6 +919,8 @@ static int __bmc150_accel_fifo_flush(str
 	if (samples && count > samples)
 		count = samples;
 
+	count = min_t(u8, count, BMC150_ACCEL_FIFO_LENGTH);
+
 	ret = bmc150_accel_fifo_transfer(data, (u8 *)buffer, count);
 	if (ret)
 		return ret;


