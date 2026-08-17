Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A374E2DC783;
	Mon, 17 Aug 2026 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976906; cv=none; b=KrNJDLsKaFMq20fr5MtakqFhcZ6/t2J9cGR3F6KoLBBH5XA5Rycv3gxXjX/Cu36NlYBUuA+3hkFVD6/KmIWoaDaumjwdx33kRNwrJ+n29SL+gO2dGCpTuj9D4cfymPzEsF11CYXRnpg3PCki/fsgoScFtEQThA9FTfgJ8VlE2F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976906; c=relaxed/simple;
	bh=jR3Y3hqvausVAyb/varYl7+2FwYDlzBnQDkHsiCgEvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7c7/qa7xOw+Jorck1SzXyQCHukxrgJObgu/4L3iOSFfLeLU5Ra4M6aXtBu4/sWedmbiEKKTRwoWSjN5OGk0X0eoxDDwyWDC6Iawo5jc3oDExqf0y1GO9mNNuJbLJiTx6diP9cqAQ9CB+27RiJfn7LLKQummN5MwpMiaIgeqO/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wk5uwJHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wk5uwJHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE09B1F000E9;
	Mon, 17 Aug 2026 14:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976905;
	bh=/Y6zWCk5WxeZPl2q1U/LYgaB8fQ5X2czRqu4TmSH8Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wk5uwJHA1Cnp/LYAfMm6CzKELArWjBqU58/B5qytj4qK8HQ6v+RPRKvx4SI74xqOy
	 8Dc+bVMat19c5yIA0UGZhM3cjXcPJt6P7J4/Ab53oekpW0I68kULSCE053zhTh6Qut
	 Ygp9FIQv0ed37yhWM8UkEmZHWwtadKL7XaUm2JZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/456] iommu/amd: Bound the early ACPI HID map
Date: Mon, 17 Aug 2026 15:28:16 +0200
Message-ID: <20260817132544.240715673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 065d626d590505..b9754219e5d9df 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3327,6 +3327,12 @@ static int __init parse_ivrs_acpihid(char *str)
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



