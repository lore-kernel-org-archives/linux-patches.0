Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002A244213E;
	Thu, 30 Jul 2026 15:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423966; cv=none; b=tLC02aOWyFEKZvZHimY5uoEuchzb4G/crhEbHtXTZGVzqosUZ+a4c/zNsCrw4EeEkKgAjRAg0VUoylWDRYzShpQNJao65CHQkSUJ1JekIC7EVA3xn+VuF0ziA1e1vDE+KRRDdR18Cy/zmeaYBJVMlbwiUEnNq+AcyWYb46cJfow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423966; c=relaxed/simple;
	bh=0FL1W9C2HnQvilFL+LgjYk22zs9DeKlBXts+Zh5dASU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxc2q+xaQaAMgp6Cis1VvudUgyDUDpdM1inOvzFyq9nG2PonT4lEgNcPzR+V2Z9hl0rywi37dUhE+/WU8wGN0HrWtz/5CV7B1VlTxifsUaoVIuA0VoOpTn12iHA1hjzf9W34ub4jz4S/0wlGqXLKmAnAH6080UBJt/qhczIPJcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cryujlhR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cryujlhR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FE61F000E9;
	Thu, 30 Jul 2026 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423964;
	bh=Lcmo7mTK+fmLq9wJ0XkLz0Dj9J3//VhtCfSQpEeTu80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cryujlhRGfuA8gf6ihdu/zDdGYRyBA6s8x/jbv+m6JFe4AwOSLy1KNQLy8nlZx+/C
	 FeQ5QkJwLV3NPnjq2bsAMAM640opVQmDrN2eWgFfwXyyx8696pitEkX4zPBA17IB4M
	 fY/G3z9nW6CpH2bZ/Z6ro3UCNVosmyjASLczaqdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 229/675] iommu/amd: Bound the early ACPI HID map
Date: Thu, 30 Jul 2026 16:09:19 +0200
Message-ID: <20260730141450.006223017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 32175daa3dd8a1..69170146d44217 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3860,6 +3860,12 @@ static int __init parse_ivrs_acpihid(char *str)
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



