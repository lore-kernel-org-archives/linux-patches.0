Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2924248BDE;
	Wed, 15 Jan 2025 10:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938378; cv=none; b=m7CDd6XjNZj/TqUj06m04EUtHimi/dikE+E6jXzFelW4X2xs9rSIme/0R9qObrQWethzFrM1ljoA5CQsJ014MifEPDOB1p3Ne8oBraZwqEueYoLxYvSdPPzsunCXvQCosu2of/OdhPGiWl7xcgJyliGNwnVlMgLjEy6YiQqs37U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938378; c=relaxed/simple;
	bh=3L9kIyQ/OHOc1TsnOvq6LUDcLvH0jfP1MhtH648YJLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y21l5iqR6Tf2VZaTDaDZOyBnVpnYLLQN89bk2ZUAC67EgSpNFU09gr/UzXDN6cxoMcVs/eVBuwmU+Wc6Q3dj5djZlfOVMbuJPMvfJsD8vqjiT1QYwxwB3wShaTBJ2PEaskpbybhnBXFnuCahzYXwU1xAYH9I7XwisYoZyxLnzjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vH71FITN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vH71FITN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4F6C4CEDF;
	Wed, 15 Jan 2025 10:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938377;
	bh=3L9kIyQ/OHOc1TsnOvq6LUDcLvH0jfP1MhtH648YJLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vH71FITNZjfKjV9Cp5ko3criut5pmbdcfiKpXktAAorMOu2Riov5Hh31UF5UhJL94
	 rGYRlqUTPFuBYk6Gy6GuLifv3tWBpMViaGfLquHRUoO25wag7H3JrF0Uw4hn2Z+0pG
	 gQkky3BZWL/7r0p93xDn52u4rT5nEXGa795PJj4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 133/189] staging: iio: ad9832: Correct phase range check
Date: Wed, 15 Jan 2025 11:37:09 +0100
Message-ID: <20250115103611.748195045@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

commit 4636e859ebe0011f41e35fa79bab585b8004e9a3 upstream.

User Perspective:
When a user sets the phase value, the ad9832_write_phase() is called.
The phase register has a 12-bit resolution, so the valid range is 0 to
4095. If the phase offset value of 4096 is input, it effectively exactly
equals 0 in the lower 12 bits, meaning no offset.

Reasons for the Change:
1) Original Condition (phase > BIT(AD9832_PHASE_BITS)):
This condition allows a phase value equal to 2^12, which is 4096.
However, this value exceeds the valid 12-bit range, as the maximum valid
phase value should be 4095.
2) Modified Condition (phase >= BIT(AD9832_PHASE_BITS)):
Ensures that the phase value is within the valid range, preventing
invalid datafrom being written.

Impact on Subsequent Logic: st->data = cpu_to_be16(addr | phase):
If the phase value is 2^12, i.e., 4096 (0001 0000 0000 0000), and addr
is AD9832_REG_PHASE0 (1100 0000 0000 0000), then addr | phase results in
1101 0000 0000 0000, occupying DB12. According to the section of WRITING
TO A PHASE REGISTER in the datasheet, the MSB 12 PHASE0 bits should be
DB11. The original condition leads to incorrect DB12 usage, which
contradicts the datasheet and could pose potential issues for future
updates if DB12 is used in such related cases.

Fixes: ea707584bac1 ("Staging: IIO: DDS: AD9832 / AD9835 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241107011015.2472600-3-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/frequency/ad9832.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/frequency/ad9832.c
+++ b/drivers/staging/iio/frequency/ad9832.c
@@ -158,7 +158,7 @@ static int ad9832_write_frequency(struct
 static int ad9832_write_phase(struct ad9832_state *st,
 			      unsigned long addr, unsigned long phase)
 {
-	if (phase > BIT(AD9832_PHASE_BITS))
+	if (phase >= BIT(AD9832_PHASE_BITS))
 		return -EINVAL;
 
 	st->phase_data[0] = cpu_to_be16((AD9832_CMD_PHA8BITSW << CMD_SHIFT) |


