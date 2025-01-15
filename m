Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5916C1E7C02;
	Wed, 15 Jan 2025 11:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938838; cv=none; b=b5sHgYbRz6eBq4b9BU+bV25t8JsN0jLUPG39YCqcAEpgdgA9SeNjsb8mfZC9xidaypoDYw4CkdNNw0i19uHIaIHWLceMjJ1+60H9yXGqwwwJUoWibU3buvBdUOUxBWTe8TG63TcteWE+0+HhhU48L9WiQrPopx34PJIrZYx7LK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938838; c=relaxed/simple;
	bh=LYOxLF00C04gVuYxFh4lqKrYZzp3YynA1WIhWgWC9Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R++zxxNG6XRSqpewDqBYl3MedA1Wa2PCE856ZfJHbaFVPf1/fJvYDSlp3ygDhFyddoEUH+Mz1F5R+AuUyaomgUq9Ngfd2mp/uLOkMbNLvi5leJ2n0SkmRH8FVe8ZvJcnpX0VuwYzZzQUnhNKO/mvDPmcRB7pvNLZLdiD6Ffd4GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAXt+qnP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAXt+qnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A3FC4CEDF;
	Wed, 15 Jan 2025 11:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938838;
	bh=LYOxLF00C04gVuYxFh4lqKrYZzp3YynA1WIhWgWC9Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAXt+qnPVMC5HJExMQWEfNY5g0LnXtNWaFt8+21xIUFLg/2lByB3sq7BCPXRrvrpY
	 qFy01ZPCaYsjoqY5JNafUYqQN5F7gjwg+DZPuF5nvNw3EtmE8dGJ8ELVS4WmeEDUzn
	 cP2Hdb6Ls97KJ5RsAH3cZD//QROjqTL0bLVSrk7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 081/129] staging: iio: ad9834: Correct phase range check
Date: Wed, 15 Jan 2025 11:37:36 +0100
Message-ID: <20250115103557.597334066@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

commit c0599762f0c7e260b99c6b7bceb8eae69b804c94 upstream.

User Perspective:
When a user sets the phase value, the ad9834_write_phase() is called.
The phase register has a 12-bit resolution, so the valid range is 0 to
4095. If the phase offset value of 4096 is input, it effectively exactly
equals 0 in the lower 12 bits, meaning no offset.

Reasons for the Change:
1) Original Condition (phase > BIT(AD9834_PHASE_BITS)):
This condition allows a phase value equal to 2^12, which is 4096.
However, this value exceeds the valid 12-bit range, as the maximum valid
phase value should be 4095.
2) Modified Condition (phase >= BIT(AD9834_PHASE_BITS)):
Ensures that the phase value is within the valid range, preventing
invalid datafrom being written.

Impact on Subsequent Logic: st->data = cpu_to_be16(addr | phase):
If the phase value is 2^12, i.e., 4096 (0001 0000 0000 0000), and addr
is AD9834_REG_PHASE0 (1100 0000 0000 0000), then addr | phase results in
1101 0000 0000 0000, occupying DB12. According to the section of WRITING
TO A PHASE REGISTER in the datasheet, the MSB 12 PHASE0 bits should be
DB11. The original condition leads to incorrect DB12 usage, which
contradicts the datasheet and could pose potential issues for future
updates if DB12 is used in such related cases.

Fixes: 12b9d5bf76bf ("Staging: IIO: DDS: AD9833 / AD9834 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20241107011015.2472600-2-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/frequency/ad9834.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/frequency/ad9834.c
+++ b/drivers/staging/iio/frequency/ad9834.c
@@ -131,7 +131,7 @@ static int ad9834_write_frequency(struct
 static int ad9834_write_phase(struct ad9834_state *st,
 			      unsigned long addr, unsigned long phase)
 {
-	if (phase > BIT(AD9834_PHASE_BITS))
+	if (phase >= BIT(AD9834_PHASE_BITS))
 		return -EINVAL;
 	st->data = cpu_to_be16(addr | phase);
 


