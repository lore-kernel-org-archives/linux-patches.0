Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0960838DC5C;
	Thu, 30 Jul 2026 16:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427398; cv=none; b=eL/VaIkUWd5Awo7ezSnCPA9UhZQ6k7M14rb5gb5vd4g+xzY8QVZwZrSQrdzTS3UvjfJmBzBlotyFz/Uk6koJsWDrOPZ8OZvk6P2Hs1THSuFo35fD/xL3Vu3W8pD3vsqy++zMK7ixGwJDhFZSBEh0tPCH8n9Z3QBJO866BDIDjaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427398; c=relaxed/simple;
	bh=q2lKcO+ms4rA113FGKdRiyyBpCuIXKHeaTpun8nQh1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzsDaCPg9q7UEpBVqzBy0+atCffpAzZGJMFghi5Fu31mhUz7sSaFbCpkdIxKblQ6GXNy3eYqzDB6gZeUaD99FURgjMnntObugFXpqVBCHq97oQx/EU6KbTxIiw5mgJ8966QfAJG4MkhtVV4rU+49o9Qw1symCA+ekGJgLt4IhQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCYFy9ck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCYFy9ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E101F00A3A;
	Thu, 30 Jul 2026 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427396;
	bh=SyDc6i3IsciZE15tclNI3A+n/X/oS/y5o5EALWUENKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCYFy9ckIsLerfeWD8zITslzAx3zSyO3eEHbpbZNwMjBJGWUBrviwXvthHgQNErDh
	 Zlkk5XNnsyAe6m08zEbYPaFfK87FOZG/UCi8/bVzzJbFYo70tqGANaFfWoUmAzVtnV
	 D02pOjnqge5Jzn9Fxwe7IuDmTJHY2mzHCfCHGyno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/484] iommu/amd: Bound the early ACPI HID map
Date: Thu, 30 Jul 2026 16:10:53 +0200
Message-ID: <20260730141426.854004410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index e5fee1aae587be..d3dc03fa93c652 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3675,6 +3675,12 @@ static int __init parse_ivrs_acpihid(char *str)
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



