Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D662E8DEC;
	Mon, 17 Aug 2026 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979165; cv=none; b=Sy1gaJfLzV9ClLmkQPIP55SRfei2V5oP2TgWdC82/0Zciee6Bv/udQntXYvwCw6mzJ0W03vfONpUxNjRUdH/BBIBvqBlVMGjZsB8xt+OCvubqCoyjbN7/yQS2WcuSdbk/firkGXfXnSEQN0nChA8paIDzX42CVc4hjxLKNQaqkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979165; c=relaxed/simple;
	bh=L+i6PjBwStRZ1Uf3uDobhMox9F1PDoKzGpT10h7/2oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OltIWXPtb+pzpY2DZmLx/JcuVwm1xaljnT/N5KKQvEdYv6rmi6FjFlBNfdAocjUTPeXCCkx90V+hEGJvPndsVqD0WCJxa1JqVEpypzEReaYxXNG7+PtoE1nZWQT6O27fjGv4YdUD7cQ9fCJGOaWIPMpk5+Xh+nYVNkDiHZodqk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSTRuX+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSTRuX+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A9B1F00A3A;
	Mon, 17 Aug 2026 15:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979164;
	bh=hoWnwXRJIgzm8kxxB17akjgpxQDg2zwNLQ7N2KsN/CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSTRuX+rRt8CocvxzKZWcwPxjdBRkUb93SQR+8iP4X1cE41VD5mx2Qh3Zxoy4f4Xz
	 DszbSGjbRv1wTjrP2CMHxCSs8gZ+8CKjtw+V0ANu8Z5EBg4As+AEkvTbPwdhjwM0Jr
	 B4XlU6fegvIsH29ZfnQiemlimfraPugKKWBmpeMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/609] iommu/amd: Bound the early ACPI HID map
Date: Mon, 17 Aug 2026 15:27:07 +0200
Message-ID: <20260817132548.262619047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9cb53e384247e9..a0342682c01d24 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3603,6 +3603,12 @@ static int __init parse_ivrs_acpihid(char *str)
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



