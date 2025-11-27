Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69E4288537;
	Thu, 27 Nov 2025 14:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255177; cv=none; b=LmHwedK4Vo9v8yPssosgWvnWiG07URU5vpMcD4yZ9Dio2aJ52O7YIBE3BYL5Vh0SDKiTA3NzamWKM10Ctfvs+UrMiWs7WliighXPd2Qv3ok0oa0hTyy6QdaHqW/mGT6fR37p2bgIalZq6UtvCSmWDQ2YAV45ZXOrhQVSKAz7cNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255177; c=relaxed/simple;
	bh=7KCq1IF8ZIwLsSx0MAqOjJc54CNCvHyLJEH5Ul79mVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/I2CCLV4IEkodkUw+SwStHE0xETOAnuaTGtwbUW1HgLvxh4iuZHpBp3E10mrlIzYVyLwpDhhEYcPTymSXrQ2TN5Nevdn4bD1sxak8ugEj+62kwiv9V/x1NY7j0y2TUyLQqFsor+v6LmUwRmYetMBS80Y4zrWi8Q6uLE5E/2m8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4HwTyx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4HwTyx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440D7C4CEF8;
	Thu, 27 Nov 2025 14:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255177;
	bh=7KCq1IF8ZIwLsSx0MAqOjJc54CNCvHyLJEH5Ul79mVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4HwTyx3iNo6LasYVqZiWmG1r+QEEHqKmSq1s28cJDzpGzVBByB568BNhWWrN2TA6
	 IFWkqA9TpeOdai7KXoghSyl8eVLTtL1MbxINF8rK53GP73MiyJEeMn48abBRbLGyRI
	 KDZMwYRirxfNo5Pi/Mc02jztyykTnJdTcN5HT8PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 035/112] LoongArch: Dont panic if no valid cache info for PCI
Date: Thu, 27 Nov 2025 15:45:37 +0100
Message-ID: <20251127144034.126544008@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


