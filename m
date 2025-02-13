Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35AC26B0BD;
	Thu, 13 Feb 2025 15:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460548; cv=none; b=rl1O2vXEOKBIhB5/aYQnO1sdIpYUpBuWQMtxAXbuwIn7TDLI3+m4w8OejSnzMIs/6sm4d9e4JqBnODfbGwMU888ENMwIH0v539omF9f13m3COawiG/Lrm8eElwmWMhby7OoqQCwETaIKDa1fyPmvUVTzW8oKAB+0TOkVmDuTikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460548; c=relaxed/simple;
	bh=dtzscxvl76ywyYNRn6xVr1W/kxd5kCKUV8gGnkZh1nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpN+SEhDgFQNiqxQMih2JgZkRy1734MXMABD/pE9RlBeMpfSkrr5bA3IPFZj/OZy4mCLuIm5tYOUX10aBc9gLRaLZ3i2bkHN8R4QDJxh8qKfKEoWChyMWtxbMyJeK2PUnY3cZDhWEe5yir8z3eoK6q79i4ebf4PDWYJQfcWAg1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfokDJEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfokDJEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAF3C4CED1;
	Thu, 13 Feb 2025 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460548;
	bh=dtzscxvl76ywyYNRn6xVr1W/kxd5kCKUV8gGnkZh1nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfokDJEgFASLsQ0owVw0MvU/KG7FECSGnSIS0EdteVOzqZymg5OSeKbiynBRn4CLm
	 ChKxP1nlkBe1a5kEYeuh5CmXDQyH13ifIw12S0NVlNKxD2asM4ZMqm6TaStY+EZyLa
	 +yZKJdpRmUm9VhGuF2c73AzubjTEeyToZpRLdezA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 144/273] soc: qcom: socinfo: Avoid out of bounds read of serial number
Date: Thu, 13 Feb 2025 15:28:36 +0100
Message-ID: <20250213142413.026040439@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 22cf4fae6660b6e1a583a41cbf84e3046ca9ccd0 upstream.

On MSM8916 devices, the serial number exposed in sysfs is constant and does
not change across individual devices. It's always:

  db410c:/sys/devices/soc0$ cat serial_number
  2644893864

The firmware used on MSM8916 exposes SOCINFO_VERSION(0, 8), which does not
have support for the serial_num field in the socinfo struct. There is an
existing check to avoid exposing the serial number in that case, but it's
not correct: When checking the item_size returned by SMEM, we need to make
sure the *end* of the serial_num is within bounds, instead of comparing
with the *start* offset. The serial_number currently exposed on MSM8916
devices is just an out of bounds read of whatever comes after the socinfo
struct in SMEM.

Fix this by changing offsetof() to offsetofend(), so that the size of the
field is also taken into account.

Cc: stable@vger.kernel.org
Fixes: efb448d0a3fc ("soc: qcom: Add socinfo driver")
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241230-qcom-socinfo-serialno-oob-v1-1-9b7a890da3da@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/socinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -760,7 +760,7 @@ static int qcom_socinfo_probe(struct pla
 	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
-	if (offsetof(struct socinfo, serial_num) <= item_size) {
+	if (offsetofend(struct socinfo, serial_num) <= item_size) {
 		qs->attr.serial_number = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"%u",
 							le32_to_cpu(info->serial_num));


