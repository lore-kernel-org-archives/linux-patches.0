Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB948635D;
	Tue, 26 Aug 2025 14:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218460; cv=none; b=hidHCa9dbtK00ZkY/R9Fd6ckr38rTl4bhxCZLp+u0QZdWVuRkxuzUrdDReEum6QyZ2cfUeQ5XQB/L7Bb+PBs0ddV3K7mOIdh0iliBEFM9TEKqLui+cPI5ke9tVLbCPE/r/073zVkY2rdBVQH61fOQU42pRswMWYReLxlyuPTshQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218460; c=relaxed/simple;
	bh=zk5+4l5YJ99GyrCyI9tLlCfGVNkXxS/xmTZacC9JO1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtOsji4rjCLtmT3oL46+L81DtoFg1CaXGP933QpqLy81EU1uGDHL9dc0Ho/A2GOjOQZpHtTHNyBq3v/9kkOtjyxjbvrZxFCCUHBX/ubmlGzYwFJztbp4cxU1C+9mzRKLJs4GB0xNyHXCAqMBQLsHQymt9v3zCVoGupOh+D4A/bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOgoX/SQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOgoX/SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1647C4CEF1;
	Tue, 26 Aug 2025 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218460;
	bh=zk5+4l5YJ99GyrCyI9tLlCfGVNkXxS/xmTZacC9JO1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOgoX/SQxjuDBWs4B4jwUu46bZgUP+3z6t+OiSISi/F6bnHVgpip+ChDayahermM9
	 5v6BRJXYUyyEpi2v4v8/XGavGhlS6KHIX26p2gAeoGvry7vM/W4ZGZTpVZ7pLeZn9S
	 KYS0k+dvxCF8qj5G3YLIZPe+s/EQ/854SFTmf6mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simcha Kosman <simcha.kosman@cyberark.com>,
	Kees Cook <kees@kernel.org>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 511/523] iommu/amd: Avoid stack buffer overflow from kernel cmdline
Date: Tue, 26 Aug 2025 13:12:01 +0200
Message-ID: <20250826110937.044877590@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 8503d0fcb1086a7cfe26df67ca4bd9bd9e99bdec ]

While the kernel command line is considered trusted in most environments,
avoid writing 1 byte past the end of "acpiid" if the "str" argument is
maximum length.

Reported-by: Simcha Kosman <simcha.kosman@cyberark.com>
Closes: https://lore.kernel.org/all/AS8P193MB2271C4B24BCEDA31830F37AE84A52@AS8P193MB2271.EURP193.PROD.OUTLOOK.COM
Fixes: b6b26d86c61c ("iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Link: https://lore.kernel.org/r/20250804154023.work.970-kees@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index e09391ab3deb..1ba6adb5b912 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3186,7 +3186,7 @@ static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
 	char *hid, *uid, *p, *addr;
-	char acpiid[ACPIID_LEN] = {0};
+	char acpiid[ACPIID_LEN + 1] = { }; /* size with NULL terminator */
 	int i;
 
 	addr = strchr(str, '@');
@@ -3212,7 +3212,7 @@ static int __init parse_ivrs_acpihid(char *str)
 	/* We have the '@', make it the terminator to get just the acpiid */
 	*addr++ = 0;
 
-	if (strlen(str) > ACPIID_LEN + 1)
+	if (strlen(str) > ACPIID_LEN)
 		goto not_found;
 
 	if (sscanf(str, "=%s", acpiid) != 1)
-- 
2.50.1



