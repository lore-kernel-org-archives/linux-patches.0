Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCB343B48C;
	Tue, 21 Jul 2026 22:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674759; cv=none; b=JsZqVDE4jf6Xm07uG8gJKwVK37mRk/7Z2YKXB618dooHgLiCEfegPstUnIdjWUwfvL5jPqZc6fXhMN7To0m9j879K8107jHZuhjSO95Um+s10KAqXmjRfWpUna19Vzqu5wh9X0ocFKrSe1k+aFMz6AJMVnN5Q2lyvfwk+7xwRfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674759; c=relaxed/simple;
	bh=R6tLd5JNfrIx+1Humz6xzfCzsNchAiSJPF3moOFgY2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+/NEN3+iHnMVbU49mhSux26vzTuDlZHO5N4EAiR0niVv4+cAajKkxaSWJFJnXvZ6JOKwdkOk/ZlhvWZRJ5ETferQ2T3qcopDl3S2RlwoBJQrYpOBm5fPRGteD9XnQwTRzPRr9oOKZ3Qk2D1CLUGFJjT0rz1Y3Ceik4BmTqFBfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOigC1VZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOigC1VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248401F00A3A;
	Tue, 21 Jul 2026 22:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674758;
	bh=EPn45WiADoJIBR48ycykBTczOCw6rLxKcI0bYOSxGxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOigC1VZWF70cvuD3geYgLW8BeHSvKlpgaoycDawVC5vMkT4gX2Jnq7bHKY/tqNUN
	 r8WDQ1b94NB9rAdkkoSay4eg+pfPiJ3rz7rQBbf8tMuW6j80O18P5xeEumthB2muXc
	 kjK7sy2EG41hp/T1T3h2xAQhra6rUxM4TEGYVLgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Nenciarini <mnencia@kcore.it>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 635/699] PCI: Skip Resizable BAR restore on read error
Date: Tue, 21 Jul 2026 17:26:34 +0200
Message-ID: <20260721152410.074417570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Nenciarini <mnencia@kcore.it>

[ Upstream commit ee7471fe968d210939be9046089a924cd23c8c3b ]

pci_restore_rebar_state() uses the Resizable BAR Control register to decide
how many BARs to restore (nbars) and which BAR each iteration addresses
(bar_idx).

When a device does not respond, config reads typically return
PCI_ERROR_RESPONSE (~0).  Both fields are 3 bits wide, so nbars and bar_idx
both evaluate to 7, past the spec's valid ranges for both fields.
pci_resource_n() then returns an unrelated resource slot, whose size is
used to derive a nonsensical value written back to the Resizable BAR
Control register.

Bail out if any Resizable BAR Control read returns PCI_ERROR_RESPONSE. No
further BARs are touched, which is safe because a config read that returns
PCI_ERROR_RESPONSE indicates the device is unreachable and restoration is
pointless.

Fixes: d3252ace0bc6 ("PCI: Restore resized BAR state on resume")
Signed-off-by: Marco Nenciarini <mnencia@kcore.it>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/666cac19b5daa0ab0e0ab64454e76b4d24465dbd.1776429882.git.mnencia@kcore.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/rebar.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/pci/rebar.c
+++ b/drivers/pci/rebar.c
@@ -130,6 +130,9 @@ void pci_restore_rebar_state(struct pci_
 		return;
 
 	pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+	if (PCI_POSSIBLE_ERROR(ctrl))
+		return;
+
 	nbars = FIELD_GET(PCI_REBAR_CTRL_NBAR_MASK, ctrl);
 
 	for (i = 0; i < nbars; i++, pos += 8) {
@@ -137,6 +140,9 @@ void pci_restore_rebar_state(struct pci_
 		int bar_idx, size;
 
 		pci_read_config_dword(pdev, pos + PCI_REBAR_CTRL, &ctrl);
+		if (PCI_POSSIBLE_ERROR(ctrl))
+			return;
+
 		bar_idx = ctrl & PCI_REBAR_CTRL_BAR_IDX;
 		res = pdev->resource + bar_idx;
 		size = ilog2(resource_size(res)) - 20;


