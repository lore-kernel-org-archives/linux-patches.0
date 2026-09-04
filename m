Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95341401A25;
	Fri,  4 Sep 2026 05:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501473; cv=none; b=DwPsJnTBoHd0ZC3WIHoayplnQmh9Yp8IeqYjjfKKHkHIiGzCGqyM+tbS539OjceUmO2qNsIInweOis2+FRzx6n+Lm8f68R7ZYDQE6uodSMZ0lkhy5EtlaoNRF2LrtTzgj6W9uFuVIYvje0YLWy+g//GE7v5TxUa1bBkeW+Xr1nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501473; c=relaxed/simple;
	bh=J0uqNBqgytlrTsL/xqbQ/7Ub13NEb4XCye/ERdGPe4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdqvOMVNZJEgACLsCrf9uYUN0SUtmBOeeXB7hK721HG0fIqB0lUAdSr/CEGv54z7o/DQtWJ26+rEHvY6r5s961VQLcGN49925wg3dqT8aFv6WAw5CHxWYacySkSpEFVrORKG7DSZ53K3TYUIIKfPOqmGtEVQNFzQuIq/nCZsP20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbfyUo1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbfyUo1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDC31F00A3D;
	Fri,  4 Sep 2026 05:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501472;
	bh=ADFYM9/yQa0LIy1PPP1ENdRwDPjA7hJJFcw9ogcD2D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dbfyUo1ctea99R3TlSJCkSDIN74bY1+bNvnlWGZRZdzpI2933l5eXUfBDyLlhMNb5
	 XhLo7A4bVZ+iC8lXMn8B/+uKI8GEQ0ai1oZ5H2C5fhlivL1fAwOhxX88Q8/dlhd8xW
	 Fb6sHYf0gZarijbPA1JmLSUR8bslOKeudFKANxpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 395/552] PCI/AER: Fix mapping of errors to agent & layer
Date: Fri,  4 Sep 2026 06:59:12 +0200
Message-ID: <20260904045759.257943743@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

commit 1017599755b8b578a671f8fac175bce56189d01c upstream.

PCIe r7.0 sec 6.2.7 documents the agent and layer of each Correctable and
Uncorrectable Error.  Based on this spec section, the AER driver maps
detected errors to an agent and layer using a set of macros and logs them.

Most errors listed in sec 6.2.7 map to the "Receiver" agent and
"Transaction Layer", so the macros use these as defaults unless an error
maps to something else.

However the macros have not been amended since their introduction in 2006
with commit 6c2b374d7485 ("PCI-Express AER implemetation: AER core and
aerdriver").  They are still based on PCIe r1.0 sec 7.2.5 (renumbered to
6.2.7 in PCIe r1.1 and newer).

Amend the macros to map errors introduced since then to the appropriate
agent and layer.

PCIe r2.1 introduced a new "Component" agent and "General" layer for
Internal Errors and Header Log Overflow.  Add them to the macros.

Unsupported Request is currently mapped to the "Requester" agent, even
though it is reported by the "Receiver".  Fix the incorrect mapping.

Sec 6.2.7 neglects to list an agent for Data Link Protocol Error and
Surprise Down Error.  Map the latter to "Component" because PCIe r7.0 sec
3.2.1 states that the error is "associated with the detecting Port".  Map
the former to "Receiver" because every occurrence of Data Link Protocol
Error in the spec refers to it being logged in the Receiving Port.  I have
had these errata reported to the PCI-SIG Protocol Working Group.  (There's
also a layout erratum in the REPLAY_NUM Rollover row wherein columns are
shifted to the left, but that's already corrected in the PCIe r7.1 draft
as of 2026-04-07.)

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/aec4820a75e949b332585a08cb1808fda7f40ea4.1784905909.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/aer.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -427,23 +427,32 @@ void pci_aer_exit(struct pci_dev *dev)
 #define AER_AGENT_REQUESTER		1
 #define AER_AGENT_COMPLETER		2
 #define AER_AGENT_TRANSMITTER		3
+#define AER_AGENT_COMPONENT		4
 
 #define AER_AGENT_REQUESTER_MASK(t)	((t == AER_CORRECTABLE) ?	\
-	0 : (PCI_ERR_UNC_COMP_TIME|PCI_ERR_UNC_UNSUP))
+	0 : PCI_ERR_UNC_COMP_TIME)
 #define AER_AGENT_COMPLETER_MASK(t)	((t == AER_CORRECTABLE) ?	\
 	0 : PCI_ERR_UNC_COMP_ABORT)
 #define AER_AGENT_TRANSMITTER_MASK(t)	((t == AER_CORRECTABLE) ?	\
-	(PCI_ERR_COR_REP_ROLL|PCI_ERR_COR_REP_TIMER) : 0)
+	(PCI_ERR_COR_REP_ROLL|PCI_ERR_COR_REP_TIMER) :			\
+	(PCI_ERR_UNC_POISON_BLK|PCI_ERR_UNC_ATOMEG|			\
+	 PCI_ERR_UNC_DMWR_BLK|PCI_ERR_UNC_XLAT_BLK|			\
+	 PCI_ERR_UNC_TLPPRE))
+#define AER_AGENT_COMPONENT_MASK(t)	((t == AER_CORRECTABLE) ?	\
+	(PCI_ERR_COR_INTERNAL|PCI_ERR_COR_LOG_OVER) :			\
+	(PCI_ERR_UNC_INTN|PCI_ERR_UNC_SURPDN))
 
 #define AER_GET_AGENT(t, e)						\
 	((e & AER_AGENT_COMPLETER_MASK(t)) ? AER_AGENT_COMPLETER :	\
 	(e & AER_AGENT_REQUESTER_MASK(t)) ? AER_AGENT_REQUESTER :	\
 	(e & AER_AGENT_TRANSMITTER_MASK(t)) ? AER_AGENT_TRANSMITTER :	\
+	(e & AER_AGENT_COMPONENT_MASK(t)) ? AER_AGENT_COMPONENT :	\
 	AER_AGENT_RECEIVER)
 
 #define AER_PHYSICAL_LAYER_ERROR	0
 #define AER_DATA_LINK_LAYER_ERROR	1
 #define AER_TRANSACTION_LAYER_ERROR	2
+#define AER_GENERAL_ERROR		3
 
 #define AER_PHYSICAL_LAYER_ERROR_MASK(t) ((t == AER_CORRECTABLE) ?	\
 	PCI_ERR_COR_RCVR : 0)
@@ -451,11 +460,14 @@ void pci_aer_exit(struct pci_dev *dev)
 	(PCI_ERR_COR_BAD_TLP|						\
 	PCI_ERR_COR_BAD_DLLP|						\
 	PCI_ERR_COR_REP_ROLL|						\
-	PCI_ERR_COR_REP_TIMER) : PCI_ERR_UNC_DLP)
+	PCI_ERR_COR_REP_TIMER) : (PCI_ERR_UNC_DLP|PCI_ERR_UNC_SURPDN))
+#define AER_GENERAL_ERROR_MASK(t)  ((t == AER_CORRECTABLE) ?		\
+	(PCI_ERR_COR_INTERNAL|PCI_ERR_COR_LOG_OVER) : PCI_ERR_UNC_INTN)
 
 #define AER_GET_LAYER_ERROR(t, e)					\
 	((e & AER_PHYSICAL_LAYER_ERROR_MASK(t)) ? AER_PHYSICAL_LAYER_ERROR : \
 	(e & AER_DATA_LINK_LAYER_ERROR_MASK(t)) ? AER_DATA_LINK_LAYER_ERROR : \
+	(e & AER_GENERAL_ERROR_MASK(t)) ? AER_GENERAL_ERROR :		\
 	AER_TRANSACTION_LAYER_ERROR)
 
 /*
@@ -470,7 +482,8 @@ static const char * const aer_error_seve
 static const char *aer_error_layer[] = {
 	"Physical Layer",
 	"Data Link Layer",
-	"Transaction Layer"
+	"Transaction Layer",
+	"General",
 };
 
 static const char *aer_correctable_error_string[] = {
@@ -547,7 +560,8 @@ static const char *aer_agent_string[] =
 	"Receiver ID",
 	"Requester ID",
 	"Completer ID",
-	"Transmitter ID"
+	"Transmitter ID",
+	"Component ID",
 };
 
 #define aer_stats_dev_attr(name, stats_array, strings_array,		\


