Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAE4B676;
	Mon, 23 Jun 2025 22:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717695; cv=none; b=CuCBclBhPoBejGmzrWomsYeq8QY8vx37Snp250KmIUp/x8b+Qk9kMF/q0Ony5gqRzBRpRVPkPhYNn0QQMgZytQ1Md3sxc5nfyW+OrdhHsYI903rAI6LfzlKvDMBzNHGBVo8x/PgyZ2FjwHB2kirAlB1RIeuv+Whf8VfGXWsty9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717695; c=relaxed/simple;
	bh=NSnahcZ36qcfJOc+2TLmn21QvJTwx3oXk3rzv5JvF5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=treqC6lU86Zv1UI7497eujSxOIbRhFH38PUwG0fSoUPG1wSIThxQ5m4QVRGfgVlctELqvr179zMIZ1k6HBU0kyQtwfEzmrnvS7KNWd9MkueRPYNnkQv9jETLPCf4lg+h4qOSLcP6TphP77OKBiWvpVw3pWndDRSUt61sjR2NgAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0m70AsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0m70AsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DBEC4CEEA;
	Mon, 23 Jun 2025 22:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717695;
	bh=NSnahcZ36qcfJOc+2TLmn21QvJTwx3oXk3rzv5JvF5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0m70AsEyY07cDtjTO5KOvHv3vFDiydp21BW8XF8ZWhMxaImgnxq+85rDwQeXVzZS
	 WtTbXFtNdnmZyQHMu7/ZVswqNmoqIBtNweWyVufj681An4qipoLB/EDEa8eSm98+Rc
	 Dz0DwpW8IgyOeoonzG7CueQUjBqSo6Z+B4ij1RWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 506/508] scsi: elx: efct: Fix memory leak in efct_hw_parse_filter()
Date: Mon, 23 Jun 2025 15:09:11 +0200
Message-ID: <20250623130657.446430274@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



