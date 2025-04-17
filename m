Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23E62566DA;
	Thu, 17 Apr 2025 18:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914964; cv=none; b=CTdz8e1y7T0KJJoTvdRUoD+FEGQeRwXecjHfeDPdApZvSsJ+GpNiXuuT/uTJ/NzpPfkoKAtk9zbg+jrsLkYr/ZiFRjcGH+hl2DEely4BrVcnxAbhgbnmEdny/eLAV7JCk2NMq12OYWvmO/DwD9Twjf1GZ1r9DJjFpuik3PQZbMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914964; c=relaxed/simple;
	bh=uENVxNJBxcAo2QfiyAUbZXWIQ6AW8t+b3rfQdtfXafg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nIfaxfwTW7Mmz4Enfhf8JMGSPIe13u4ircHtlNqvXyhY65SFKvWhKvsIYHGX/DhJh78KP7b5Tcm8QBUCOrPHArStLbh6lOD/bmlgfEFvZd2jLx+Ep3JkhNIkIgVAof0DWbaRXSr0D1GEnxx01IT0k5HeGrrP2HeP/dX2HG3WAok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJd+9zJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJd+9zJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2603AC4CEE4;
	Thu, 17 Apr 2025 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914963;
	bh=uENVxNJBxcAo2QfiyAUbZXWIQ6AW8t+b3rfQdtfXafg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJd+9zJRToDkoFA6wNDuc088/NW0V3+82c/XnRZlAERbP1jjAV/GkJW0PN647dsUR
	 ugC2+0PjvolvN6GG7ddwDawjJssYl5OD2YlP9KpuonAObBaWost/HQumfRke23KfUW
	 CVuNTVBSegRcNBShEZS0Bz7Ui+R6wjFnBOZvSPKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.13 389/414] PCI: Fix wrong length of devres array
Date: Thu, 17 Apr 2025 19:52:27 +0200
Message-ID: <20250417175127.130644570@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


