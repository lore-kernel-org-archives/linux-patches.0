Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B82222581;
	Mon, 23 Jun 2025 22:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717528; cv=none; b=Zs0sS9trzrRXQ9H0nbU2RMvjt8aGdYiEkZRfd1rNWwr5pwRuhnbHfKVc07/EbIBDSxDDnke4UhtvIYI4LlLcEXBYVAZ3KRu0rDdqjXd1FYmwSl0B0dE/Nfhv/DLPiGzFktXqLjG+S/7reJnVMkt26nIEJZ00utnrXh6/wkGUNAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717528; c=relaxed/simple;
	bh=MXzvnJA9D7nQ4E18LkmG8aNVVmfu/LECdTcA2UBBTlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPFy6RbBXdhjFyk7sY7tWEtQ4KTNY9DOHbTQ8PW8j9NXrYbkLeB3dz+krw06ahhFVX1nkVKS2cBxj1jJNc1R8gTlFjIOc4biPUh5NE5bRWwnLS2faxrLJXWQae33D1EJgKcaZWOatnb++ZuRQrwxCSzkXUAohX2wObHDEnQaVIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPToCjL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPToCjL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3572EC4CEEA;
	Mon, 23 Jun 2025 22:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717528;
	bh=MXzvnJA9D7nQ4E18LkmG8aNVVmfu/LECdTcA2UBBTlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPToCjL/PAOMXfyAlpE3QDRcTZgGR7gPTFXnxJC6W6l8/OYoGPJBaLKYcCvRjUiL4
	 c8z5C2gSacYqLXz5t582OvkmempG5FuUIwASIDK2hKClMs/DceLljBmEa4hlGgwSz/
	 4Xt1m4RZL2aHpXiMVFxj8rBoCumbiaFksBdYnFG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 407/414] scsi: elx: efct: Fix memory leak in efct_hw_parse_filter()
Date: Mon, 23 Jun 2025 15:09:04 +0200
Message-ID: <20250623130652.119903106@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

[ Upstream commit 2a8a5a5dd06eef580f9818567773fd75057cb875 ]

strsep() modifies the address of the pointer passed to it so that it no
longer points to the original address. This means kfree() gets the wrong
pointer.

Fix this by passing unmodified pointer returned from kstrdup() to
kfree().

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Link: https://lore.kernel.org/r/20250612163616.24298-1-v.shevtsov@mt-integration.ru
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/elx/efct/efct_hw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 5a5525054d71c..5b079b8b7a082 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -1120,7 +1120,7 @@ int
 efct_hw_parse_filter(struct efct_hw *hw, void *value)
 {
 	int rc = 0;
-	char *p = NULL;
+	char *p = NULL, *pp = NULL;
 	char *token;
 	u32 idx = 0;
 
@@ -1132,6 +1132,7 @@ efct_hw_parse_filter(struct efct_hw *hw, void *value)
 		efc_log_err(hw->os, "p is NULL\n");
 		return -ENOMEM;
 	}
+	pp = p;
 
 	idx = 0;
 	while ((token = strsep(&p, ",")) && *token) {
@@ -1144,7 +1145,7 @@ efct_hw_parse_filter(struct efct_hw *hw, void *value)
 		if (idx == ARRAY_SIZE(hw->config.filter_def))
 			break;
 	}
-	kfree(p);
+	kfree(pp);
 
 	return rc;
 }
-- 
2.39.5



