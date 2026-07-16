Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139553191C8;
	Thu, 16 Jul 2026 14:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210554; cv=none; b=uyzxvwaVmd/nLrBtZvWQHHAc969NNWZWLo1Rzg395U7BpPkRQHIyqecoTb/v8EcEU82TMZRP2GMz5dC+PFtmgOoT83L4/0Sy9wWxzt+74V0wAedNeWIQTDsS7y4XsDp7zgi8zJs6KDprFyzJ23/SpghChyJ5sudaBt60lFYQvPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210554; c=relaxed/simple;
	bh=7ZhVGwlPlJfKfhTVTkOX/V2GOOf5Dwi7ByispOJKG6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUSG06iXrnvL0X0U5nB1FoeOlHB4PQKRXKZFhrfbzDjn4QvOW/0aOaQTujTTv6CL5Fw0hN1Q9pShFqA2Wv6aJ3//7YAoUken7mUPVlTS6Xwq0023GKqs3f8eO2hwibKcmOACstJiidHQsxAI/61Kg50GSXRfC5S38YKXnBJ6NtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqNiJH7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqNiJH7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786D51F000E9;
	Thu, 16 Jul 2026 14:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210553;
	bh=7xxx/sTuEv8Tz2lV5t2UliTIBCPIB12YwG6yHHS69QM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqNiJH7OAXFnKmKUxIkTYVPOGq3SDzJYHgbHsXc6R8Kyy6sP0CGFYRSOcG1+5A2cT
	 TOpWEwIAJ6PWeYpaS6wpCv3ok9eCi+rns/CVbb9fZcj6ICYW+rSlUqF5rHao0NK3U4
	 I7kfBa+pFpGOqeAYdbDY0IHzPhZ4LRAlv9S3I/kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 048/480] iio: accel: bmc150: clamp the device-reported FIFO frame count
Date: Thu, 16 Jul 2026 15:26:35 +0200
Message-ID: <20260716133045.748499308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -991,6 +991,8 @@ static int __bmc150_accel_fifo_flush(str
 	if (samples && count > samples)
 		count = samples;
 
+	count = min_t(u8, count, BMC150_ACCEL_FIFO_LENGTH);
+
 	ret = bmc150_accel_fifo_transfer(data, (u8 *)buffer, count);
 	if (ret)
 		return ret;


