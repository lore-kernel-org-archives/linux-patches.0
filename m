Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E0316C688;
	Wed,  3 Jul 2024 10:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003686; cv=none; b=KvNzwRviTu66IzNwpyzTdGQMNi9IuzRwRnKkhDrm0WK4uZli7Vlrs233wg0cFeNbKINs5+yZ4HIJyPTQ2jSsUki9oUkmtKI9nFOJp19uPjbFuCZN2XWlC/WdkwMT+U/I/UPJuWz/Xn9HqqJ+P1h9z0yH027c8lGTuz5dutyewyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003686; c=relaxed/simple;
	bh=h1OIrPRlt2fcX0VMynGmgQwXHa0TaiWWU3pA0fd+CwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X4Vnd7c6+pgLAsaf2B2Y9S3wR3TQseHDSJ6NXuNXfn8pS8xvus0vzILf5il7Df+4yEWhrL1R/At9MKqTHvVbq57N489ql4fAal5lFd56Yk8qE/jjnRjEEHIQIXYYhGVRfNyPPOa05QukFLdN872iXA3xGmoEdiigTRFWwchd4NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/X2NEHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/X2NEHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DABC2BD10;
	Wed,  3 Jul 2024 10:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003686;
	bh=h1OIrPRlt2fcX0VMynGmgQwXHa0TaiWWU3pA0fd+CwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/X2NEHb37Z3+q8THzLyZmS+57LgH/64G3rWfDD1ll+GlaQtYH9kqMducbJRpuNJ+
	 +THB8JemBwJRRaX5/YR8+hgn4RxDlpXgHijRj3NWm3lJXIq4fOvJWUPRj8Su9JI2yO
	 ozVvi3s59qrlwxMkg+miqv7FMGcEiJXXt585OOnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Naveen Naidu <naveennaidu479@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/139] PCI: Add PCI_ERROR_RESPONSE and related definitions
Date: Wed,  3 Jul 2024 12:39:45 +0200
Message-ID: <20240703102833.762408932@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2636990e0cccf..edb37a5050da8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -123,6 +123,15 @@ enum pci_interrupt_pin {
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



