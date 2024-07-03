Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAEE45945;
	Wed,  3 Jul 2024 11:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004992; cv=none; b=qJHrmZy2qWH3pm4o6VEUZAzFw8QXfOFpze2OOtcLGQGgHd1vx5Vq5xgOnmGVXgcoFVw/3LZW+hxo8sorMBRo7z2bZePC35ZXCRu72OU9HJHTZloTTGgMPIwX2YGUhWMXy20K8UF8oEfu4KRqDJREC2dOJpHemnFY/olkpZdZtVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004992; c=relaxed/simple;
	bh=SvlnkcPl5hGMl5YylRIBWDaFmK4g3KHlaoH33xDGKWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ot2fvHjmPUdBtWgW2SIBxr22OyGmetVDk7rKzMKAXRaVnf8pibQLHN8BqhL8tk7CrNkUnBkEok6DsDJ7ikXcMmrpA96EiB1v4bPeVrMuQ2kMRnk9fkXwd+HaQIIqByaPNb0Akmr2CcoMFRKcPzccsSyvlEmfY0r9zQIvZyQ5GTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PlClw9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PlClw9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76EDC2BD10;
	Wed,  3 Jul 2024 11:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004992;
	bh=SvlnkcPl5hGMl5YylRIBWDaFmK4g3KHlaoH33xDGKWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PlClw9dBukMhEtpZ9dyGUwFv9juL2cmVOmuAe18jjG8Mo2XwP56xtvx0jOltlNDt
	 3RvrsZMwmXr+igsNkNL4Pv2ZI1VcKrWeReF2NLJCd5u97+E0lH/rfHvC1rbz5O9Yo+
	 X+dRpTXFAvw8WkRMX/Vg1Q7CNeFA18WfjnoYJ1OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Naveen Naidu <naveennaidu479@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/290] PCI: Add PCI_ERROR_RESPONSE and related definitions
Date: Wed,  3 Jul 2024 12:39:34 +0200
Message-ID: <20240703102911.456755408@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Naidu <naveennaidu479@gmail.com>

[ Upstream commit 57bdeef4716689d9b0e3571034d65cf420f6efcd ]

A config or MMIO read from a PCI device that doesn't exist or doesn't
respond causes a PCI error. There's no real data to return to satisfy the
CPU read, so most hardware fabricates ~0 data.

Add a PCI_ERROR_RESPONSE definition for that and use it where appropriate
to make these checks consistent and easier to find.

Also add helper definitions PCI_SET_ERROR_RESPONSE() and
PCI_POSSIBLE_ERROR() to make the code more readable.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/55563bf4dfc5d3fdc96695373c659d099bf175b1.1637243717.git.naveennaidu479@gmail.com
Signed-off-by: Naveen Naidu <naveennaidu479@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Stable-dep-of: c625dabbf1c4 ("x86/amd_nb: Check for invalid SMN reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5b24a6fbfa0be..30bc462fb1964 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -148,6 +148,15 @@ enum pci_interrupt_pin {
 /* The number of legacy PCI INTx interrupts */
 #define PCI_NUM_INTX	4
 
+/*
+ * Reading from a device that doesn't respond typically returns ~0.  A
+ * successful read from a device may also return ~0, so you need additional
+ * information to reliably identify errors.
+ */
+#define PCI_ERROR_RESPONSE		(~0ULL)
+#define PCI_SET_ERROR_RESPONSE(val)	(*(val) = ((typeof(*(val))) PCI_ERROR_RESPONSE))
+#define PCI_POSSIBLE_ERROR(val)		((val) == ((typeof(val)) PCI_ERROR_RESPONSE))
+
 /*
  * pci_power_t values must match the bits in the Capabilities PME_Support
  * and Control/Status PowerState fields in the Power Management capability.
-- 
2.43.0



