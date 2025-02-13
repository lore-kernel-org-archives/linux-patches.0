Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921DA2222BB;
	Thu, 13 Feb 2025 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457842; cv=none; b=ZBxOLCgI7cxnoRzWAU9kUX3wSTL7c4w2VUR37qM6dYXv44sSmDLRf6DqYC9h32mIkmUJdM9APFzlfHxJ7Ph1TjWmDfmDOZ+Xe+TRYg8AHG0fMbqr+PIdBMOv3M32atOO6Dsgpwj1fHuk0R9HRmE/WKcy8RdvZ4pvTFdLpoYab90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457842; c=relaxed/simple;
	bh=OW4FyHHpl1A2YPXEgGjCbhI11COOJotXnfzG/H3oirs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEVJJ6jjXLsN01QF72KqjGyWrp7kydE5GWiEMdbhE/iIxuxtqfN2baKT2LxmzKw24isHMJcmMs01KzTlQD9JzZbLi/rjjyWWT91IwWROv+2VgfMCTsWUxXCVQGvWYlc4mZ57zciCnvwtGFvpcN0Lr/xtY5cF7eOuwGTqM009Ytw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUcerAkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUcerAkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D41C4CEE4;
	Thu, 13 Feb 2025 14:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457842;
	bh=OW4FyHHpl1A2YPXEgGjCbhI11COOJotXnfzG/H3oirs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUcerAkkPSDsW+EOTMHXe5WKLpSe1iIjaJXw8rKZJgyuJ49kF1d21YHQtWf8RSfv5
	 QvbnDAfh3AwPwH/9hoJR4N2X6iljPqt7F5egNlMHS7JdgvX0yNYVkCFOmmsaGWylth
	 rORyhx2GDf5JQJmqorL7p8mJpWISVFq32MS6tW4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 227/422] soc: qcom: socinfo: Avoid out of bounds read of serial number
Date: Thu, 13 Feb 2025 15:26:16 +0100
Message-ID: <20250213142445.296428857@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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
@@ -789,7 +789,7 @@ static int qcom_socinfo_probe(struct pla
 	if (!qs->attr.soc_id || !qs->attr.revision)
 		return -ENOMEM;
 
-	if (offsetof(struct socinfo, serial_num) <= item_size) {
+	if (offsetofend(struct socinfo, serial_num) <= item_size) {
 		qs->attr.serial_number = devm_kasprintf(&pdev->dev, GFP_KERNEL,
 							"%u",
 							le32_to_cpu(info->serial_num));


