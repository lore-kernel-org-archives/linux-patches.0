Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CD71C4A24;
	Mon, 10 Mar 2025 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629487; cv=none; b=rd+pBRpJmF2LoId/yVZJeImD8UoPh1BcLBDRkBJVVVVp3VQPHXy3YFQKivHHJbVmqcTe58Kd3oQ2zmNMkSzwT7KYMgeawskkZE5Aey1jJEYr2EV+ZTCRss0bNGkWr1hJKLJIvQoG/++NccoacdT7yKzTPNu6JLUomfsC7sNlFmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629487; c=relaxed/simple;
	bh=QgITL5UApmGFYgsRFq73XVBpivUfmkvjHbPHF2I5n8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvVH2HTJR7KzXaEZdS+vi7TnEAwRpGinsute9DwknFWVysu8rsG9D06JJRAJ7PYHi+zWfpUXJrus8qWrDe7WQK3fARxcDamksPYjSyjvWB0yu5Lx24UCwuuPnGoR1M8uolTNYXShO1zPPYOaTp0A5ZxrjPg47ydW1lq76aKxGlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iR1Tspw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iR1Tspw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257A2C4CEE5;
	Mon, 10 Mar 2025 17:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629487;
	bh=QgITL5UApmGFYgsRFq73XVBpivUfmkvjHbPHF2I5n8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iR1Tspw8DWFCLOFEyFEw60C3S2I4X3+h0UffKfWC2m1WzRbJWOWd1wyNdTO+P37BE
	 xrfr05L1prqhfgkqpS8mQrgPG77YCM+IaK3Gydy8nmhulHcMLrkfgRkOJN/dxCnTCT
	 xGPer0VVNEuo5oGzJaK4QEVCLYETPm1T/z2SLbdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 284/620] soc: qcom: socinfo: Avoid out of bounds read of serial number
Date: Mon, 10 Mar 2025 18:02:10 +0100
Message-ID: <20250310170556.824901319@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -617,7 +617,7 @@ static int qcom_socinfo_probe(struct pla
 	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
-	if (offsetof(struct socinfo, serial_num) <= item_size) {
+	if (offsetofend(struct socinfo, serial_num) <= item_size) {
 		qs->attr.serial_number = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"%u",
 							le32_to_cpu(info->serial_num));


