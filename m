Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D64D2EC0B0;
	Mon, 17 Aug 2026 14:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975585; cv=none; b=MT0zqAwFnoVmj8Exb4NwH4LJs0quls7exOPiJAIRiVNK0UfnqaKMqxCPE1ZTlffSbzNhtHot+FOqRPSh1MrZeXBnOfWQdaHQOtZHMGu7ouLyWMOVPCRCQRD25yZiNTuFytDwEJL0m9cOZ0KHPQJAaF0/2lYlrUWNa4T/B9R93+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975585; c=relaxed/simple;
	bh=mdWtjO7hGzGxZYMZLKb5rG9B1mjiiXtOBtrW4HagvZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhT/45OaK/ZC6WwZ7z3a4OBJBWvBQEhBJCbhdVnXohHPyoqD4svzUWxbJiEkqi0efZNsQnpSVdqPPZ+6rFk2geR3pOHq8lRqlGeVzQppBR711R5JjsMkJSUUcPDi02JH0sZxbOiDqrBNZx8RWLSxeO7kFoji9wNqXQruPZkZ+AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nc4gz7Tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nc4gz7Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D716B1F000E9;
	Mon, 17 Aug 2026 14:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975584;
	bh=Mnf/0s4m8OXwEvlRWgE/yrcrTpWsBNUaslUcaHKm4hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nc4gz7TxtGstFEKrYYRhQ2BjIXxMAjZL8i0OhSyLBlnmI6Zu5CcOGqFFOXa1pev8H
	 r8LrY5qqYz/YYwXUYGns73yNMOUnZ8/UsIoEgW/+rYKQwM7g9+Jx93gmP/wdtLyqLX
	 4HMXzIMqDQZxRziu111P0gT8TUtHllpYYDy0zmx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/389] iommu/amd: Bound the early ACPI HID map
Date: Mon, 17 Aug 2026 15:28:38 +0200
Message-ID: <20260817132542.180923599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit fb80117fddb5b477218dc99bb53911b72c3847f8 ]

The ivrs_acpihid command-line parser appends entries to a fixed
four-element early_acpihid_map array. Unlike the sibling IOAPIC and HPET
parsers, it does not reject a fifth entry before incrementing the map size.

Check the capacity at the common found label before parsing the HID and
UID or writing the entry.

Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 1ba6adb5b91241..1b7a0fae423ce9 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3227,6 +3227,12 @@ static int __init parse_ivrs_acpihid(char *str)
 	return 1;
 
 found:
+	if (early_acpihid_map_size == EARLY_MAP_SIZE) {
+		pr_err("Early ACPI HID map overflow - ignoring ivrs_acpihid%s\n",
+		       str);
+		return 1;
+	}
+
 	p = acpiid;
 	hid = strsep(&p, ":");
 	uid = p;
-- 
2.53.0



