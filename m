Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427C943DA4B;
	Thu, 30 Jul 2026 14:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421881; cv=none; b=EhCXpAtXK4CAF/7RHnq3bZp+NzhbF3VTx1w4B+J7eVH+ppHDuIH9AaYCCM2gq7Jnq3jS4qkrJ54m6ZCdlq5u3XEyMIW3JnYOf+u9p1MouhhUvRTZ6CeojpE8FjtT90I+ikmV6isYSqXgmv1+er2UKZb/tiwbuYY/1rQy7BvcAWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421881; c=relaxed/simple;
	bh=U2yI2shkeI9QsS/xB9Y1Xuznhz0RrwsyaBbIqIlNldg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyqO9OtXqyaxePyp/HAjc88gT/WKIiZ3nMh9GmZtwnXyCy3XthacjZlgE6Y+nnqYZfce+38QU4H3/STitr2GHfcm/JJWJ5kXthQ1c70gfcqQRBcl3SCIwJfz+ZxofFZfA3E9Sjg8k3b8Vrbtx6fkMqdadMD6se6QtVGBAH96iC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQpZhgOS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQpZhgOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5C51F000E9;
	Thu, 30 Jul 2026 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421879;
	bh=TvlM5tIQRPEg7AcR+QOGMOflxGBLka8jTBFcCt0OpJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQpZhgOSwXHKYpgxYX6xNFztfesnZVw38yxm8B+DnrU7R8LzVT7uO0p+wHhCa9r9q
	 A9Qz+UYrB77cdct4Har3W1xEmdgfBBUi0kULsgg1K3+4SFT2UDfKg1GWlOFqunwlW1
	 XPRSa2+g702Q02PeMwe2a98HeqPuILYPqAcbmG7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 250/744] iommu/amd: Bound the early ACPI HID map
Date: Thu, 30 Jul 2026 16:08:43 +0200
Message-ID: <20260730141449.606425801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9a846dcd030638..0df711c082cb20 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3872,6 +3872,12 @@ static int __init parse_ivrs_acpihid(char *str)
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



