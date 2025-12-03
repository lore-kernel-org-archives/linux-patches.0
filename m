Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8F5358D14;
	Wed,  3 Dec 2025 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780293; cv=none; b=kIpw4V0U6Dkr2pvUS8OBG+yfO8aJBeEk6rjHBD/MfuNwfNeRZaWxo5FtMFiqbMJFVLP4E1fC8pW3gtw7JQOZrkS5FGEHucRXFbw3MEmN1KPabN6hxIuDX2vxbn61Y2NFio3AEdo2dpouLvW9lYz8Ob9l8fG6DdzGWDyls2cMLnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780293; c=relaxed/simple;
	bh=Ax/Tlx2NcB6dmTDtgPPXgvuTFaR5/YrVTJZxUffwstY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHhLDWyux5Jl4Izr0/q3iiDLt/+bOG+mUVeCRg5+b/WtwCgkTidBAARmAFh6PYADRpd+DZBK4ap517aZW1Otdg7d8abjfblHn1pQUD1nugAVX5RROALeb5Yr7Za/xhrFlF1yAIuN8C7ADy9scX9uNY3l+pFuhLPYdRi1tc7H64A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2OZJTwn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2OZJTwn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC23C4CEF5;
	Wed,  3 Dec 2025 16:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780293;
	bh=Ax/Tlx2NcB6dmTDtgPPXgvuTFaR5/YrVTJZxUffwstY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2OZJTwnmjNURnuxEJfyfWlWRjT++UUfpSF/Do/WuVFINNh2GFSxnUjzQKEL2RgQN
	 pmkPss+IJrO8zQzHAUJTCy8WzL1xQrjRezvVGBDJqqGUsKb5V2AgM3090WWUr4Ek0y
	 1Uw6N1h/iwQWx1XQhFkkEmTsCCzCAvR9hpWGL20Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 513/568] mailbox: pcc: Refactor error handling in irq handler into separate function
Date: Wed,  3 Dec 2025 16:28:35 +0100
Message-ID: <20251203152459.502640975@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 3a675f50415b95f2ae10bfd932e2154ba1a08ee7 ]

The existing error handling logic in pcc_mbox_irq() is intermixed with the
main flow of the function. The command complete check and the complete
complete update/acknowledgment are nicely factored into separate functions.

Moves error detection and clearing logic into a separate function called:
pcc_mbox_error_check_and_clear() by extracting error-handling logic from
pcc_mbox_irq().

This ensures error checking and clearing are handled separately and it
improves maintainability by keeping the IRQ handler focused on processing
events.

Acked-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: ff0e4d4c97c9 ("mailbox: pcc: don't zero error register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 82102a4c5d688..94e99b87496d2 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -269,6 +269,25 @@ static bool pcc_mbox_cmd_complete_check(struct pcc_chan_info *pchan)
 	return !!val;
 }
 
+static int pcc_mbox_error_check_and_clear(struct pcc_chan_info *pchan)
+{
+	u64 val;
+	int ret;
+
+	ret = pcc_chan_reg_read(&pchan->error, &val);
+	if (ret)
+		return ret;
+
+	val &= pchan->error.status_mask;
+	if (val) {
+		val &= ~pchan->error.status_mask;
+		pcc_chan_reg_write(&pchan->error, val);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static void check_and_ack(struct pcc_chan_info *pchan, struct mbox_chan *chan)
 {
 	struct acpi_pcct_ext_pcc_shared_memory pcc_hdr;
@@ -309,8 +328,6 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 {
 	struct pcc_chan_info *pchan;
 	struct mbox_chan *chan = p;
-	u64 val;
-	int ret;
 
 	pchan = chan->con_priv;
 	if (pchan->type == ACPI_PCCT_TYPE_EXT_PCC_MASTER_SUBSPACE &&
@@ -320,15 +337,8 @@ static irqreturn_t pcc_mbox_irq(int irq, void *p)
 	if (!pcc_mbox_cmd_complete_check(pchan))
 		return IRQ_NONE;
 
-	ret = pcc_chan_reg_read(&pchan->error, &val);
-	if (ret)
+	if (pcc_mbox_error_check_and_clear(pchan))
 		return IRQ_NONE;
-	val &= pchan->error.status_mask;
-	if (val) {
-		val &= ~pchan->error.status_mask;
-		pcc_chan_reg_write(&pchan->error, val);
-		return IRQ_NONE;
-	}
 
 	if (pcc_chan_reg_read_modify_write(&pchan->plat_irq_ack))
 		return IRQ_NONE;
-- 
2.51.0



