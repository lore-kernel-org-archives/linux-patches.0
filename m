Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03336288537;
	Thu, 27 Nov 2025 14:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255004; cv=none; b=V+/FwZ75cqXvaiskxWyRLE3NeGecDWROUiCSfMYQpXK4wmADlyFTNuuuBK2KvwUy9BFEWS3S2boAo8Wel3bXXufYhILCnizVbmFIxAAVCojRE/u/jU7JjW/a2LdzjVsEqsN1vnrokscPIIDlxBt6xKe3LTBC1VOLNtEvKe86jHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255004; c=relaxed/simple;
	bh=la1R1IXlkTt99oF0OEUel++6VYzQALvCNJaKUd8r7h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYzyAK8pzlJNrMHHK1DrnVM4Z8N0MsykLtQqqDjTIAuunib6TVWhZXXfagFe1U6NxHAhluDrxU6OuIFmb+YpLQlcaKqMiNesVS3P6NGbBxdQrNGjfGCxg0WBAxYQYNm8BgGRxySaF1MyYHPYde9Re8Ia1zGX3azDzuxKEqUEpNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRKIc1IS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRKIc1IS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC3CC4CEF8;
	Thu, 27 Nov 2025 14:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255003;
	bh=la1R1IXlkTt99oF0OEUel++6VYzQALvCNJaKUd8r7h0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRKIc1ISkIIfMgBcmiNuurSNgbVWhED1ehv1ZfiHgUyNWW73OE3Wbmtjo78/AiFuD
	 Gz4VeeuRkmDri7EnCrdscbvmMDUeXjRRMg2914vszJtueTL3bdSTP5UwfUznSbhaq6
	 QrkOrPClGygA3uKggpiP5GFgTwa49zWbmjIEYY0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 27/86] LoongArch: Dont panic if no valid cache info for PCI
Date: Thu, 27 Nov 2025 15:45:43 +0100
Message-ID: <20251127144028.814333420@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -51,11 +51,11 @@ static int __init pcibios_init(void)
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


