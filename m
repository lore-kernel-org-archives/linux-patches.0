Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAF11DF749;
	Tue, 11 Mar 2025 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706855; cv=none; b=BBDpDx6gdskBd+k/X4t6tSgyuR80rM2Oilr5jm82Ti/t8wRQ64z2ngaBqoFdoH0gaCcKM93PVQr8DfqqQrBugdDA9fLebp1RtFD77Czium4YPZhZSRynlTxBk6kO6p3DvS7h3rJXiQdzQ1c7mFwqetK6ILmEtygppzAx+PTsKlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706855; c=relaxed/simple;
	bh=6zf5aQFEC3G2f7U76uJjRnqZJr0974TBbISpkGonUcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kz1cbjeBlu6CjDFINkGNtBJJEn5+wIorQiZsjaU4PerKevMNGf9S0U2Y1HOiKi2v9nkFuUmqJqkHqKRI7A9ZO7hZ9uS+rcc6BpuWomhAG7+UPdp3DFjZx5uOTA1/yLWjMbXJTPh3KArmtH9WQutPkXF7UuyhKdx8zpoxxlMbFCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgP70WhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgP70WhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC284C4CEEA;
	Tue, 11 Mar 2025 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706855;
	bh=6zf5aQFEC3G2f7U76uJjRnqZJr0974TBbISpkGonUcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgP70WhUnip1J4sO3W7eMR5/+XHv2p5F9szCHBmGw+5MHl/cDGUwQVA6foLfdD+FZ
	 YLU+sgWLDEyO8J/6DHWhI3I/M9D2GRVQkrNK4Zyz2kadO+ur95EphsVXtbfSqQ6kuz
	 PuA5Wk7PICw6fo/gMtncxyAI45WIaRoX/X0YZDYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.10 191/462] soc: qcom: socinfo: Avoid out of bounds read of serial number
Date: Tue, 11 Mar 2025 15:57:37 +0100
Message-ID: <20250311145805.906310636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -510,7 +510,7 @@ static int qcom_socinfo_probe(struct pla
 	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
-	if (offsetof(struct socinfo, serial_num) <= item_size) {
+	if (offsetofend(struct socinfo, serial_num) <= item_size) {
 		qs->attr.serial_number = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"%u",
 							le32_to_cpu(info->serial_num));


