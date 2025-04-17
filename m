Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3456E250C15;
	Thu, 17 Apr 2025 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916174; cv=none; b=KpbdYciA5fGtM8SP3rI85KbeKFrzbtQvkUlJJx6pgBtCyuPBMLkbG6HwYGSIjNB2cdqk1HSlK91IhkZhnCjM0uvfEyXOY2hYSgGpIMBeF+ZXXvpMkN5x6HTJ3eR5NFwPPD1e0ehe34VupYOhWu4xOBzNm/90nOW21Pdpdqzo3tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916174; c=relaxed/simple;
	bh=NWsMOZT17UhHO4WJ1HH4mj4kb4NPlmzyqPCoJMYvDIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hideXdjPunBD26CdseG/PlyBTVKeMlKDIdwu5WJ3+lDVjjY2gMaKCC5Frwwd67+6iABqqPbkQygYrvlpUx1UbhcyMxOaJk7KhaKxnUZNxGzrJMiUqcdTNaZ9y+WHaXkg1MiwuTcSLGB4+58ExAZ5xzcg2yVmXbv6cE9ngMyXYWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXO5dyBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXO5dyBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934C9C4CEE7;
	Thu, 17 Apr 2025 18:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916174;
	bh=NWsMOZT17UhHO4WJ1HH4mj4kb4NPlmzyqPCoJMYvDIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXO5dyBQ2EpllOmZDfd07txp0VLd1qHBCsFqZa+aeLh/bhMEf9UhuhJNC333Rox6+
	 4r6HIbfzu/aL511QT+CPO8blyCflKzBUlHJBB1eli1VnAJsmMamajxp1i+ij49d1fb
	 42P8+sBIIp0V299a3yqANL1D54CuoWefVe9vhiDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 367/393] PCI: Fix wrong length of devres array
Date: Thu, 17 Apr 2025 19:52:56 +0200
Message-ID: <20250417175122.364214374@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

commit f09d3937d400433080d17982bd1a540da53a156d upstream.

The array for the iomapping cookie addresses has a length of
PCI_STD_NUM_BARS. This constant, however, only describes standard BARs;
while PCI can allow for additional, special BARs.

The total number of PCI resources is described by constant
PCI_NUM_RESOURCES, which is also used in, e.g., pci_select_bars().

Thus, the devres array has so far been too small.

Change the length of the devres array to PCI_NUM_RESOURCES.

Link: https://lore.kernel.org/r/20250312080634.13731-3-phasta@kernel.org
Fixes: bbaff68bf4a4 ("PCI: Add managed partial-BAR request and map infrastructure")
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org	# v6.11+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/devres.c
+++ b/drivers/pci/devres.c
@@ -40,7 +40,7 @@
  * Legacy struct storing addresses to whole mapped BARs.
  */
 struct pcim_iomap_devres {
-	void __iomem *table[PCI_STD_NUM_BARS];
+	void __iomem *table[PCI_NUM_RESOURCES];
 };
 
 /* Used to restore the old INTx state on driver detach. */


