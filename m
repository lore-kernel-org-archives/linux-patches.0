Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE2F1E8855;
	Thu, 30 Jan 2025 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246648; cv=none; b=kTRyDDAPk0ZSWKIhIng4eyzdzY85Z0/wCVQ4B+RER91PKilbl74vJ/kI1APYLMF3RoHL0AZdx3MXZg6XkMZKmACFHeGpUAzflBPm5E1p8YYu38px+w2TyZCmQYt63zX8n94AHb1z/VrMFqWlBJAQBqlVcxBRWAMfHoC2vDgUqTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246648; c=relaxed/simple;
	bh=v89qz152XzJRLwKfc3Fi/i5oWZpi9u/sFFYYZHAXb3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTvOTVGnkk+ppXHikDi1zeyNq20Qz4Ek8YGe6iF2DVJzjR0A89TxROxDBOpzSR70Gnk5snuMcX1KEoUJSictqAiX5i/YEIQborXJZAeb5rvsnsNV1BApQB62R+TthY9EbLnndoXeBkV1h3QiNl2OFJbMToxvXv9iMj9DTCiIjrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZqRP3X0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZqRP3X0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7DBC4CEE0;
	Thu, 30 Jan 2025 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246647;
	bh=v89qz152XzJRLwKfc3Fi/i5oWZpi9u/sFFYYZHAXb3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZqRP3X0vKmAKDEC9Lz085ZemHpWkaATfLD0TPy9+wL3PBGzbqWu4O9JnO/Eb+X3L
	 j1XrX23b9PvKgYVIg4Q2VRnPZFJ4aftHiQQd65CbXMVZpxqA/faVMI1XdAx+KZYNCv
	 rG7tuFelH4Yp/hLhz35YyES4x9SZxoDLEeq5ITSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 20/91] staging: iio: ad9834: Correct phase range check
Date: Thu, 30 Jan 2025 15:00:39 +0100
Message-ID: <20250130140134.473939306@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -132,7 +132,7 @@ static int ad9834_write_frequency(struct
 static int ad9834_write_phase(struct ad9834_state *st,
 			      unsigned long addr, unsigned long phase)
 {
-	if (phase > BIT(AD9834_PHASE_BITS))
+	if (phase >= BIT(AD9834_PHASE_BITS))
 		return -EINVAL;
 	st->data = cpu_to_be16(addr | phase);
 


