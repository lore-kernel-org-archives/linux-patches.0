Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3A380FD6;
	Thu, 30 Jul 2026 15:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425922; cv=none; b=Rs99hAtU9wnpprzk7DlZhXfB/Il1QjJeW71+6Ls5BE/HXXBHpJtZJRWxeYIW5GOWvUAJ152z2nP+FSOMthvkghWnRM4ClnyZyQlVTzKyoe9tJ1KaPqJ7Vw45Lpzje6Ug3pnD1zs5k/s6kOxh5LmKKE7P2e0nOhzcLze9NJaDJfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425922; c=relaxed/simple;
	bh=T9UJalMal35VZa7BvE57CXClUZ1dnVqzSFtJA46CyBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avXB6xUYYvUKhvkYRqCDFlZbmsVavUw57dsVORnKjnBwhsHPyC+J127BNoCsTDvf2UE/Q61gB353XJ4IjIgVvOzjMubbG6FA2bvmUCRSTvTQ1tV+DtW5sWYggN1HErVuL67wOoykPGdHAMFTodKIqhK46gonu24k3yA1mf9Eeb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuAx0R+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuAx0R+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA0A1F000E9;
	Thu, 30 Jul 2026 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425920;
	bh=F1k/H016ky0HlA5tNBCDwXMMLKK9ZBN3hgBYFMenLCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuAx0R+Kzy62ruQCqAlzgBA0qmTLsz+P6sYKHtjSPZQH9ZU4hNChoii/dEWFXkPVl
	 lzWL0O85y/x8kMoy4zzordgvWW4NNwRMAZ0bUaequZaETvL7Ct0sRyu3yvDt8f6huO
	 yOSdYMIniK8dlDZJDpjm+73/lH450MJbIeg0tLXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/602] iommu/amd: Bound the early ACPI HID map
Date: Thu, 30 Jul 2026 16:09:36 +0200
Message-ID: <20260730141439.828998199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 7fa340281b9fb2..36a814b6c4de56 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3696,6 +3696,12 @@ static int __init parse_ivrs_acpihid(char *str)
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



