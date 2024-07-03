Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5D318A95E;
	Wed,  3 Jul 2024 10:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004225; cv=none; b=KhLUUk5IA4JgzZda0U9wIQBgSKOAhVdipCkukCMIRGrz/b+2CgHPmj7ue2YnKRuaZY79yAPRT0XToMmIrwKm3CJh0wEGsL3hK7qegDT8UcFCyvfdAuzBFJQ+SxNdP+AohQCpJaQ5bPcyoIqcPD6V1oe9i2/yvyFgAdCwmv4KXdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004225; c=relaxed/simple;
	bh=VQEBxE8Sxa/rL6+ZQOjr6Gipu0Y9L8uBO5dsRU/t1/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tmC1H/cwwRT6CRZoWrcJGgL6eqsUWpYFBVmXfmaynopx+ktypZk8tQbmV90jM7cTrat7br0reiu/Zrx3xfZeRpVSnSzAa1dmzvyxi/AtcfLn1whB8FyFXl48lzD5v+gaYMMLDlsbLqGKJPraMiXzHQK1NxJer/gfTcBM3wqUryE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iu090SAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iu090SAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA19C32781;
	Wed,  3 Jul 2024 10:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004225;
	bh=VQEBxE8Sxa/rL6+ZQOjr6Gipu0Y9L8uBO5dsRU/t1/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iu090SAuHDLBB9oW4zqaF8eOyJX8M3tLhvMXPsORqygs41ZRkucVaKGsKOr8coWMo
	 AcLQdozZai77JGt7rgt5S83DNmAKa2RkaAHw6rI4lvm/qSEXFGs/Y8zyvSkUnI2vl7
	 tNyeComy90iUs4ytAC0KfmgKDUlFao2jJ9twX/mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Naveen Naidu <naveennaidu479@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/189] PCI: Add PCI_ERROR_RESPONSE and related definitions
Date: Wed,  3 Jul 2024 12:39:50 +0200
Message-ID: <20240703102846.359094459@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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
index 1cd5caa567cf5..7edc6de9e88c2 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -129,6 +129,15 @@ enum pci_interrupt_pin {
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



