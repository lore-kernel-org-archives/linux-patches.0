Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F3C15749F;
	Tue,  9 Jul 2024 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524356; cv=none; b=reOzXFMQ7YO+9Wq7hdWrYv6fc6CBKXn+O8tRGchHGwuuo27XeBDtSwWBk+A4aQfG/zVFTQJNp2HCyDyvRXn0a8R8sgB7lw2iMltjpseLYrp4gatcWm7+PF4gzrbvisWY/5WiPfJlF/sh1vjpkksu6qtuDbgmiJzgyH5kO8bAFL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524356; c=relaxed/simple;
	bh=E01VzoxTCt45+lzolq2fjh7aupBfIt6p1uNSDCqaASg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER4mBDyr1ry1+9v0pK6Ik5wg1XWvvUccabqef2yrf3rdK1Rh/A46YAQQVoyF8sXJlXNW83WLi6pfTgMU9t2eth5EapuWuqEp7FFAzYvd/VymqAYzuSay3lLc8gWWXb+OMkBOQnQZztKEwCoyyyGZ/H5VzUOAhVWaCUILnJCC0e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBJHTNNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBJHTNNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8E1C4AF0C;
	Tue,  9 Jul 2024 11:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524356;
	bh=E01VzoxTCt45+lzolq2fjh7aupBfIt6p1uNSDCqaASg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBJHTNNc502q5UajfO64SvQH8oZNFBSBuMhKRtqIkkyj6veWGnWyMSrPmgtC9YoD9
	 C60AfJSAlRxS3VmtxCmjCn5DGLVa1MI33aSGLylg8BRXPYBls7nNkbFBcy2KEMZtae
	 UmHqEuE6E5fxziYP6v7SwovpAMIb8jhcexTZ4kXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 154/197] clk: qcom: gcc-ipq9574: Add BRANCH_HALT_VOTED flag
Date: Tue,  9 Jul 2024 13:10:08 +0200
Message-ID: <20240709110714.913524780@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Md Sadre Alam <quic_mdalam@quicinc.com>

commit 72ceafb587a56e26c905472418c7dc2033c294d3 upstream.

The crypto_ahb and crypto_axi clks are hardware voteable.
This means that the halt bit isn't reliable because some
other voter in the system, e.g. TrustZone, could be keeping
the clk enabled when the kernel turns it off from clk_disable().
Make these clks use voting mode by changing the halt check to
BRANCH_HALT_VOTED and toggle the voting bit in the voting register
instead of directly controlling the branch by writing to the branch
register. This fixes stuck clk warnings seen on ipq9574 and saves
power by actually turning the clk off.

Also changes the CRYPTO_AHB_CLK_ENA & CRYPTO_AXI_CLK_ENA
offset to 0xb004 from 0x16014.

Cc: stable@vger.kernel.org
Fixes: f6b2bd9cb29a ("clk: qcom: gcc-ipq9574: Enable crypto clocks")
Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
Link: https://lore.kernel.org/r/20240509105405.1262369-1-quic_mdalam@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-ipq9574.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/clk/qcom/gcc-ipq9574.c
+++ b/drivers/clk/qcom/gcc-ipq9574.c
@@ -2140,9 +2140,10 @@ static struct clk_rcg2 pcnoc_bfdcd_clk_s
 
 static struct clk_branch gcc_crypto_axi_clk = {
 	.halt_reg = 0x16010,
+	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
-		.enable_reg = 0x16010,
-		.enable_mask = BIT(0),
+		.enable_reg = 0xb004,
+		.enable_mask = BIT(15),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_crypto_axi_clk",
 			.parent_hws = (const struct clk_hw *[]) {
@@ -2156,9 +2157,10 @@ static struct clk_branch gcc_crypto_axi_
 
 static struct clk_branch gcc_crypto_ahb_clk = {
 	.halt_reg = 0x16014,
+	.halt_check = BRANCH_HALT_VOTED,
 	.clkr = {
-		.enable_reg = 0x16014,
-		.enable_mask = BIT(0),
+		.enable_reg = 0xb004,
+		.enable_mask = BIT(16),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_crypto_ahb_clk",
 			.parent_hws = (const struct clk_hw *[]) {


