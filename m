Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44713346A7;
	Thu, 27 Nov 2025 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255607; cv=none; b=iAcN/bToXpZ52OVSBYNl5N6sNYyq6A22uf4b9f7Lct5Me7ie0nFlHew72AcODOlps25mHjvBNbX6DI+79WUZeJjkBBg7lV0/KcnpKL1XF6CeoHeqmYq/J39jC/xGgh8sjS9yjblIcYYgUldd4+Ajf8Wz8+mDeAM0aVbLKkF5CSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255607; c=relaxed/simple;
	bh=d9/zhtngoT6Ycn8QLiNjU4VbBtc5CnQ5+PyFfM90yqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX6jU+ydNlIbN+NxI/XrEtI+4lEsgmWw2EJ5Ue2bF3GzQo4ddsoD01px63VZ6Fgh0KdGa1PybwLJGXdN0K4R3MBFOphhBvct/CyMq5s2iyKshkLdmnvIr4JRtg+9aVW4qrL5JKtHv5jjM6+ZX++iIA5i4ANbhlarw9wZ28OHfqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kotbW5Nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kotbW5Nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF75C4CEF8;
	Thu, 27 Nov 2025 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255607;
	bh=d9/zhtngoT6Ycn8QLiNjU4VbBtc5CnQ5+PyFfM90yqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kotbW5NvnpffvS59w0SxpkCeclcuvjxqpdD9dupY+25rXQnchsSYgYX+smAOnP3te
	 /sXRCsxkK0CScqfeQB5P6M+vyQ/XKYBxiPvdTxivqA/mUhJxfkEhokD3DtK+P5Ux5F
	 oB5bvZO3Ma+yCHvxKyHKPo6SpGVyWR27+DKL1sdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 051/175] LoongArch: Dont panic if no valid cache info for PCI
Date: Thu, 27 Nov 2025 15:45:04 +0100
Message-ID: <20251127144044.829793395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit a6b533adfc05ba15360631e019d3e18275080275 upstream.

If there is no valid cache info detected (may happen in virtual machine)
for pci_dfl_cache_line_size, kernel shouldn't panic. Because in the PCI
core it will be evaluated to (L1_CACHE_BYTES >> 2).

Cc: <stable@vger.kernel.org>
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/pci/pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/loongarch/pci/pci.c
+++ b/arch/loongarch/pci/pci.c
@@ -50,11 +50,11 @@ static int __init pcibios_init(void)
 	 */
 	lsize = cpu_last_level_cache_line_size();
 
-	BUG_ON(!lsize);
+	if (lsize) {
+		pci_dfl_cache_line_size = lsize >> 2;
 
-	pci_dfl_cache_line_size = lsize >> 2;
-
-	pr_debug("PCI: pci_cache_line_size set to %d bytes\n", lsize);
+		pr_debug("PCI: pci_cache_line_size set to %d bytes\n", lsize);
+	}
 
 	return 0;
 }


