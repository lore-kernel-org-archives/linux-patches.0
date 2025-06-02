Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3937C22DF92;
	Mon,  2 Jun 2025 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874893; cv=none; b=FZiLyXsslVX2Lb5oZCyVaQaXvKzKPLN5ZJZRJ4Ogs+agz52cDWkd/2xTxjyy8SiBWiM7Aalz/BgYeVXzqsRkJ2IrHrpGHKy7zs/QMUvY4CztlUINH+b52zq+2MPu1aUDSURsBnqYWf/gTVM4VikYelOcCm+MC6yoscqPDK8u8Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874893; c=relaxed/simple;
	bh=tRRAGWuybInMft8cMvRwwZZlKC4DlVyo3ziunZm/+D8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UZUGQCPRWxEluo/ZFrH+SiICWXhwLouicEQ7apPsKIsOqlcdZVrmzsu7MQ4VNlflvoTLkT3+FnNdHApXczOwm5kzUl/YBa8gKVY5rw/YZNm0eItW5aoYq7a9fgqPxQjhtY4PCaFfHNQe3wv8icDCxTZNeFphCR3e0IKZ6yCVaqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NaQsHDT5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NaQsHDT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64EFC4CEEB;
	Mon,  2 Jun 2025 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874893;
	bh=tRRAGWuybInMft8cMvRwwZZlKC4DlVyo3ziunZm/+D8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NaQsHDT5GtOUkqkNq0M1isZeQK+6eQxjWD1OzmdlRhN9W2iZvOFzA+R6Myvy4M0fF
	 JLJFkSMMlO02tNNvJYTYEAMlrW8uY8lmGOSaHZsHmf4/NX1bJR5VHuTal0WGds/ULj
	 y0xKPcYujgIfg3EbJ+ARe0YWk1H6oAQ7mdc/XIG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/204] PCI: Fix old_size lower bound in calculate_iosize() too
Date: Mon,  2 Jun 2025 15:47:53 +0200
Message-ID: <20250602134301.151599081@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit ff61f380de5652e723168341480cc7adf1dd6213 ]

Commit 903534fa7d30 ("PCI: Fix resource double counting on remove &
rescan") fixed double counting of mem resources because of old_size being
applied too early.

Fix a similar counting bug on the io resource side.

Link: https://lore.kernel.org/r/20241216175632.4175-6-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xiaochun Lee <lixc17@lenovo.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 32e34ade736c3..1793e1084aeb3 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -800,11 +800,9 @@ static resource_size_t calculate_iosize(resource_size_t size,
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
 	size = size + size1;
-	if (size < old_size)
-		size = old_size;
 
-	size = ALIGN(max(size, add_size) + children_add_size, align);
-	return size;
+	size = max(size, add_size) + children_add_size;
+	return ALIGN(max(size, old_size), align);
 }
 
 static resource_size_t calculate_memsize(resource_size_t size,
-- 
2.39.5



