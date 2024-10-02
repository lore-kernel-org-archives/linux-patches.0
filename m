Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772F51D096E;
	Wed,  2 Oct 2024 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880671; cv=none; b=bk7iYyDcWzIL4+TmE6D4QIVWBTk+FZC4wMkec4OK0XuasHsW0pr3/rKrlgg2Zu1yEaJ7XsSc1dBLOdRNAOh0SNm5my0RChR37hFUrnpQAr1vOn9gzSKjUvzc4cETtXLQeyuFk3Pb/CkpEUZqkai9nWySMfJK9qO9l2PABgu0m10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880671; c=relaxed/simple;
	bh=pdsmgKPYXjJIb9t9YcRlMDO4Tp/attZFJeX80cAb0r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLOhkbEdqwBj75kuE4pkyqTNif1g22Q4U2eCdpNagNkeO/I3QZRlkss7o5Syo3gwVi8rFk+gHaNBZBk8JFw+3xoPO5Wjhou2p5SlOninIHCmT8lN4IWOs/dtbgjdTnpINZ3fqMsEtYGQGosJ7hZDfSiwGCtCvV/TuZVd6L561/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWyz4Q2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWyz4Q2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E95C4CEC2;
	Wed,  2 Oct 2024 14:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880671;
	bh=pdsmgKPYXjJIb9t9YcRlMDO4Tp/attZFJeX80cAb0r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWyz4Q2ClaG5047wFyG256Y36G7hEIAQUtSm4joArgBVrJyZZH0H+RQAj6Bx6iYaa
	 b3XGW2rRB+fwyYnqVJznxcMwpkY7CsH5dBE9VKyWOZXDWFWoFrE3dbCtiejGvi4P4g
	 TKudYnI+8+P7tV2rC+GhsodfALikPatj5FH5gE3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"qin.wan@hp.com, andreas.noever@gmail.com, michael.jamet@intel.com, mika.westerberg@linux.intel.com, YehezkelShB@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, Alexandru Gagniuc" <alexandru.gagniuc@hp.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Qin Wan <qin.wan@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Subject: [PATCH 6.6 507/538] thunderbolt: Use weight constants in tb_usb3_consumed_bandwidth()
Date: Wed,  2 Oct 2024 15:02:26 +0200
Message-ID: <20241002125812.454262736@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 4d24db0c801461adeefd7e0bdc98c79c60ccefb0 ]

Instead of magic numbers use the constants we introduced in the previous
commit to make the code more readable. No functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Qin Wan <qin.wan@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tunnel.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -1747,14 +1747,17 @@ static int tb_usb3_activate(struct tb_tu
 static int tb_usb3_consumed_bandwidth(struct tb_tunnel *tunnel,
 		int *consumed_up, int *consumed_down)
 {
-	int pcie_enabled = tb_acpi_may_tunnel_pcie();
+	int pcie_weight = tb_acpi_may_tunnel_pcie() ? TB_PCI_WEIGHT : 0;
 
 	/*
 	 * PCIe tunneling, if enabled, affects the USB3 bandwidth so
 	 * take that it into account here.
 	 */
-	*consumed_up = tunnel->allocated_up * (3 + pcie_enabled) / 3;
-	*consumed_down = tunnel->allocated_down * (3 + pcie_enabled) / 3;
+	*consumed_up = tunnel->allocated_up *
+		(TB_USB3_WEIGHT + pcie_weight) / TB_USB3_WEIGHT;
+	*consumed_down = tunnel->allocated_down *
+		(TB_USB3_WEIGHT + pcie_weight) / TB_USB3_WEIGHT;
+
 	return 0;
 }
 


