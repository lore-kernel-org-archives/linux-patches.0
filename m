Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B92E29D280;
	Tue, 26 Aug 2025 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208950; cv=none; b=ZAaYFHn0jCDPhZ/Xt+9W0IPBgTmuqsQr5t8zb/PaK8yHK20yB/O/dHV0Py4jYTePzoPkSwdJSNhNMd63vZEzEMKT0ZtrFlGN96Kozx2kAibegXJdMgM+P/XIVxc2HwJNEh9jfdwhoElECm/X4bwGD/LmLuekRWYB9LRM86o7PN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208950; c=relaxed/simple;
	bh=R7aUvpJ8NuPDIWqNjUlf4jQrZFngNIu+D6kAe1PQhho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poJb4RuOh+jnN7cBLaN22MgrBTyjMprgnB2DIhYlDJE+ZZrUYmHkebmDVQU3+AE/9HEF4lybJHZSQOTfgQxMbw5SMrX/YwXNVfaqJSnMTe3l8MAUPMabsglH0orHy25WYYRaCWl1rp4dzJWKIxeX0Bs7/1L/QYXgMh2KkoaK9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JqK779RC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JqK779RC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63B0C4CEF1;
	Tue, 26 Aug 2025 11:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208950;
	bh=R7aUvpJ8NuPDIWqNjUlf4jQrZFngNIu+D6kAe1PQhho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqK779RClY0hp4Tmz7o2JbDP0oeUt8x5pz1cpVe1kdLRc3Tb4O3fuSopKWGK5WWZs
	 GckIV/05u+mA/mfgjttiIvxoqKfYvR7ephORhabLjz5WTH/t4lQe6+xu5RoLyMmpev
	 J8JM3hDZO0SJx+L59yA/4h8cvuVfB8HsiZ/9RmmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simcha Kosman <simcha.kosman@cyberark.com>,
	Kees Cook <kees@kernel.org>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/322] iommu/amd: Avoid stack buffer overflow from kernel cmdline
Date: Tue, 26 Aug 2025 13:11:31 +0200
Message-ID: <20250826110922.739734461@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff11cd7e5c06..f5b544e0f230 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3598,7 +3598,7 @@ static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
 	char *hid, *uid, *p, *addr;
-	char acpiid[ACPIID_LEN] = {0};
+	char acpiid[ACPIID_LEN + 1] = { }; /* size with NULL terminator */
 	int i;
 
 	addr = strchr(str, '@');
@@ -3624,7 +3624,7 @@ static int __init parse_ivrs_acpihid(char *str)
 	/* We have the '@', make it the terminator to get just the acpiid */
 	*addr++ = 0;
 
-	if (strlen(str) > ACPIID_LEN + 1)
+	if (strlen(str) > ACPIID_LEN)
 		goto not_found;
 
 	if (sscanf(str, "=%s", acpiid) != 1)
-- 
2.50.1



