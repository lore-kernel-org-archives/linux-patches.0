Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2989326CE32;
	Mon, 13 Apr 2026 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097190; cv=none; b=rXjK7p4uV1KPU7IGUiT66widQ9QGzp3QZVMW6JdFH5mep+zCBFcWKHERGee5YtS3BYIJA63pdU1poKbpLq4V4Bz9QahhH1gv/t+sp7tC1IOd2K2TNTdy+jcxlbb2Naqx3uyXdXR3kU+b+0Av6v5jfHz8L7J0InLYxHkDQCzbR7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097190; c=relaxed/simple;
	bh=wpZnTTXddp/XN7U8+aV3VX8L58EAk5rq3HbeFOq+bvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IANVJtjxoUUZH3+C0CIPkpk04DzavaptJdUCLiOchJS/zAynTh0o93lXRrCn9w4GMh/efxFELeLFDrEGakljL0bIlmtd7HtClYbJ0dDAwrj/izTmhEiOQFQgHQwTv2i+fLh7x+otDhgj+X+GeLC5A++S3XHhTEyN8rbjtZ7mKI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8J4uQZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8J4uQZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B456BC2BCAF;
	Mon, 13 Apr 2026 16:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097190;
	bh=wpZnTTXddp/XN7U8+aV3VX8L58EAk5rq3HbeFOq+bvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8J4uQZRuP+3j2diR3omoOOPLQxFg/YqBesl+d0Ne8G3dEK+6V3A2VWA+wnRwts88
	 M3tM9oTpjzAVDYo+j/glpia1NPdUPqABnSFrbk+tZCSuSip+UmmdPXjH24AzzeeRgd
	 nQATnuo7eIxPxGy9PLmSKs5fEkPjFjyCh5W1nI6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/570] net: arcnet: com20020-pci: fix support for 2.5Mbit cards
Date: Mon, 13 Apr 2026 17:52:51 +0200
Message-ID: <20260413155831.929436654@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

[ Upstream commit c7d9be66b71af490446127c6ffcb66d6bb71b8b9 ]

Commit 8c14f9c70327 ("ARCNET: add com20020 PCI IDs with metadata")
converted the com20020-pci driver to use a card info structure instead
of a single flag mask in driver_data. However, it failed to take into
account that in the original code, driver_data of 0 indicates a card
with no special flags, not a card that should not have any card info
structure. This introduced a null pointer dereference when cards with
no flags were probed.

Commit bd6f1fd5d33d ("net: arcnet: com20020: Fix null-ptr-deref in
com20020pci_probe()") then papered over this issue by rejecting cards
with no driver_data instead of resolving the problem at its source.

Fix the original issue by introducing a new card info structure for
2.5Mbit cards that does not set any flags and using it if no
driver_data is present.

Fixes: 8c14f9c70327 ("ARCNET: add com20020 PCI IDs with metadata")
Fixes: bd6f1fd5d33d ("net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()")
Cc: stable@vger.kernel.org
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Link: https://patch.msgid.link/20260213045510.32368-1-enelsonmoore@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/arcnet/com20020-pci.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/arcnet/com20020-pci.c b/drivers/net/arcnet/com20020-pci.c
index 00a80f0adece4..7cea482f2d5f9 100644
--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -114,6 +114,8 @@ static const struct attribute_group com20020_state_group = {
 	.attrs = com20020_state_attrs,
 };
 
+static struct com20020_pci_card_info card_info_2p5mbit;
+
 static void com20020pci_remove(struct pci_dev *pdev);
 
 static int com20020pci_probe(struct pci_dev *pdev,
@@ -139,7 +141,7 @@ static int com20020pci_probe(struct pci_dev *pdev,
 
 	ci = (struct com20020_pci_card_info *)id->driver_data;
 	if (!ci)
-		return -EINVAL;
+		ci = &card_info_2p5mbit;
 
 	priv->ci = ci;
 	mm = &ci->misc_map;
@@ -346,6 +348,18 @@ static struct com20020_pci_card_info card_info_5mbit = {
 	.flags = ARC_IS_5MBIT,
 };
 
+static struct com20020_pci_card_info card_info_2p5mbit = {
+	.name = "ARC-PCI",
+	.devcount = 1,
+	.chan_map_tbl = {
+		{
+			.bar = 2,
+			.offset = 0x00,
+			.size = 0x08,
+		},
+	},
+};
+
 static struct com20020_pci_card_info card_info_sohard = {
 	.name = "SOHARD SH ARC-PCI",
 	.devcount = 1,
-- 
2.51.0



