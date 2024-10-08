Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E751E0E1D;
	Tue,  8 Oct 2024 13:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393890; cv=none; b=fi71HG1ENUcjUNR3SD6+9R24jhD4xZRoQW/nYHSICOtyPT1ufOHGelLKqubgs4dlRzDe02OAmBsXwsHhlTXg1BY1hMIpH4eKF53JhpFzLfbOHLd9PX557gVj1HEocUTa3p//hWwUnYMhjEl7xMdDNCi3yZAlsHT4ox/uoxf+Xkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393890; c=relaxed/simple;
	bh=CpeWq77NFZLuj5NC6ZllIhrzZzYpveLd5H0pXAj3EqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DE8iAESxQPTwQtEY9D+jqs8wPTbETMn5uLa3HJVFznr6ftSXzclEpzn1w2dIEdi0qpq484LCmtrWXBAfuOew0cryeLTaCPgrhPbb2D5+y+hPXZopoupSZafAu2rkfI0iICALMqjlRp3VZv3nfr+q1y9a/B+jyVqySw5lpy/GFhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oA9qG1vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oA9qG1vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7F3C4CEC7;
	Tue,  8 Oct 2024 13:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393890;
	bh=CpeWq77NFZLuj5NC6ZllIhrzZzYpveLd5H0pXAj3EqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oA9qG1vgqSeofBjEYdmZ5ikRlbHNQmpa+gFktRjv5pIpQzWzYsSK04IjqErUugvtm
	 7QSThuqKlSddUw/+mjmIFULj1OlmdtfQaHo3BMAuJrdNFYeUI13QK7jMozfqeokKut
	 Ksq2SEsxVCpqzDgwaunvt1m8DxtbLizdT4anSx30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 284/386] clk: qcom: gcc-sm8450: Do not turn off PCIe GDSCs during gdsc_disable()
Date: Tue,  8 Oct 2024 14:08:49 +0200
Message-ID: <20241008115640.562003424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 889e1332310656961855c0dcedbb4dbe78e39d22 upstream.

With PWRSTS_OFF_ON, PCIe GDSCs are turned off during gdsc_disable(). This
can happen during scenarios such as system suspend and breaks the resume
of PCIe controllers from suspend.

So use PWRSTS_RET_ON to indicate the GDSC driver to not turn off the GDSCs
during gdsc_disable() and allow the hardware to transition the GDSCs to
retention when the parent domain enters low power state during system
suspend.

Cc: stable@vger.kernel.org # 5.17
Fixes: db0c944ee92b ("clk: qcom: Add clock driver for SM8450")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20240722105733.13040-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-sm8450.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/clk/qcom/gcc-sm8450.c
+++ b/drivers/clk/qcom/gcc-sm8450.c
@@ -2974,7 +2974,7 @@ static struct gdsc pcie_0_gdsc = {
 	.pd = {
 		.name = "pcie_0_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc pcie_1_gdsc = {
@@ -2982,7 +2982,7 @@ static struct gdsc pcie_1_gdsc = {
 	.pd = {
 		.name = "pcie_1_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 };
 
 static struct gdsc ufs_phy_gdsc = {


