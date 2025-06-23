Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0895A223DF0;
	Mon, 23 Jun 2025 22:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716728; cv=none; b=ojNVB3pvh0hnT4ko1FwE5MaJzVibC1SUYCSx19mdi+LuVWHUQIQP/ygFZ7Cs+5v6pSc+46G+QKPooK/F9J3pcVISlH/OJPHo/v6PKPu+X5ugmVSmH6flFHa6i/Mopk4JqdeYi/wIl+JE9nCSW1ICbI+zNeIIAohLksqUFkZMQYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716728; c=relaxed/simple;
	bh=Ckouslyw5UlUVp4I0xSvnxCvc7ge6h1XOPiJdMkWq2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHQckM2M6a3W9tPcnYyFEmlbznc7WHc7UGYc6xvy/tiCM8jIxUwJv6Gz4q9YCdH3zV6a/0Nvll+rS1G4szJf2aPNcNeob+42Y5kTiTEiS51fS9O/sicFhFgOLHu4WOeQQj66IXbR5CTjIchgpKrKYWwY5NLryh6E3DSbgenuN2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPtV9Im6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPtV9Im6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D199C4CEEA;
	Mon, 23 Jun 2025 22:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716727;
	bh=Ckouslyw5UlUVp4I0xSvnxCvc7ge6h1XOPiJdMkWq2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPtV9Im6IlgXLIWV8/49vfuhpisFLrmQIUTzLp2N9WcIdD2CMDOiPq9yoo9iaNr60
	 f61O7y/nuttssXaNrylgrHyyzARwcYbeW9Xd3iyn4RpInTRbw/JRFBiqBemIohLR4P
	 lAUmfJEkvMoGXvGUZIgbOZPdsN6wpPvo6zw/PFVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/290] scsi: elx: efct: Fix memory leak in efct_hw_parse_filter()
Date: Mon, 23 Jun 2025 15:09:06 +0200
Message-ID: <20250623130635.492143070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



