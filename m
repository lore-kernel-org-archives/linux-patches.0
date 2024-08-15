Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C691A01B6;
	Thu, 15 Aug 2024 14:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731366; cv=none; b=REq9AWsK86+xewsRyIGXPzED6qYd/Ctb/O1YJlQhRvlmJHQBZ16Mbw+iDoyo0QzAU4iSS2EujfUyzqMcOSQPFo7VWyB425mRKCx1UoyJ4HocZcPokdaBM3JHU/HH07z1ACOoqtZdybR5HpTLR9KqyUf8YtgcGboMsvA22XoMvuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731366; c=relaxed/simple;
	bh=2kYScAh2aqVhVaf2NKz0RjEaMCo4SN/U6tR3kJ56ERk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qh0+kZhRB5lKyf8HtGGbV4EEikxsCcM69FRfwEyruiwG0KSQTdS1PP7P02qoLAf6k+aZr5DvXXfYsghWAoBr0TBXLD2CZUBGWEQXjFabojQwMig5r9cO1LsuSLN5r7CHC5Oyox7mbpAEvZfSyBr0w1pTqlTJEm5qMoEUpwF8HtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0aUdAjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0aUdAjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503EDC32786;
	Thu, 15 Aug 2024 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731366;
	bh=2kYScAh2aqVhVaf2NKz0RjEaMCo4SN/U6tR3kJ56ERk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0aUdAjnwWhEnAA9Ii7Bjn8b83MDivsARBs7M639Yf0dABoqcGAtEFxnLwu0OXtXe
	 Flb1ThD7FbLVpxq+ay5tMX/+MhBHJKNYo5Y0DS/EGEmE6NESad4e46c4hy0m6lIlhV
	 DcUSP19jtKlEp6Fu0rspO+txmqhEx6Nr8LKUWOeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Liu <wei.liu@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Michael Kelley <mhklinux@outlook.com>,
	stable@kernel.org
Subject: [PATCH 5.4 107/259] PCI: hv: Return zero, not garbage, when reading PCI_INTERRUPT_PIN
Date: Thu, 15 Aug 2024 15:24:00 +0200
Message-ID: <20240815131906.936933627@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu@kernel.org>

commit fea93a3e5d5e6a09eb153866d2ce60ea3287a70d upstream.

The intent of the code snippet is to always return 0 for both
PCI_INTERRUPT_LINE and PCI_INTERRUPT_PIN.

The check misses PCI_INTERRUPT_PIN. This patch fixes that.

This is discovered by this call in VFIO:

    pci_read_config_byte(vdev->pdev, PCI_INTERRUPT_PIN, &pin);

The old code does not set *val to 0 because it misses the check for
PCI_INTERRUPT_PIN. Garbage is returned in that case.

Fixes: 4daace0d8ce8 ("PCI: hv: Add paravirtual PCI front-end for Microsoft Hyper-V VMs")
Link: https://lore.kernel.org/linux-pci/20240701202606.129606-1-wei.liu@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -682,8 +682,8 @@ static void _hv_pcifront_read_config(str
 		   PCI_CAPABILITY_LIST) {
 		/* ROM BARs are unimplemented */
 		*val = 0;
-	} else if (where >= PCI_INTERRUPT_LINE && where + size <=
-		   PCI_INTERRUPT_PIN) {
+	} else if ((where >= PCI_INTERRUPT_LINE && where + size <= PCI_INTERRUPT_PIN) ||
+		   (where >= PCI_INTERRUPT_PIN && where + size <= PCI_MIN_GNT)) {
 		/*
 		 * Interrupt Line and Interrupt PIN are hard-wired to zero
 		 * because this front-end only supports message-signaled


