Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890DCB676;
	Mon, 23 Jun 2025 22:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716989; cv=none; b=N1NTtj0tkpSGk4p2Jx7L1Z+rfB2rMfrVYXlaIzjLSPcbWyjQdPcIG4MXWoqDM7ZifTcL6DiSj0B4pTjhasETdh1Yru7qpR5WgrQkmJUvefOGHbMynE+fB2IfKcPpYVGVnP9hYToszupFdG3Agol9MORyuCITdoJqbnEaoRKt+9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716989; c=relaxed/simple;
	bh=Mf9qyBALIeiaGApJnVDnf1WwEuwqJM0722A0RA7qZKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKXzLYMhgscWqrObZvZNITWxyaFm8PMhiv+Fwfi2pJOPgEicIfzdnpTR5bauaxGmK2pDMoYqFBZ1dgvvoi+WFIfYUnyC4M0TGkVjYePIcz9Iq2I85UF+zNcroHVArxtegVnimFvL0rNdJDkY3fXg3w2TlD/vSpgPcL3+CnHqY7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz8Cy7tI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz8Cy7tI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB83C4CEEA;
	Mon, 23 Jun 2025 22:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716989;
	bh=Mf9qyBALIeiaGApJnVDnf1WwEuwqJM0722A0RA7qZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kz8Cy7tIw8fG/wJmNgOwHAfwWZ/q1KwTF4MV7TCo625CInL3hQ9kkbBW4cxJ/+CuX
	 HMG4JAlCn3HrJfMFvqVldfqn3Ga4xfjcspiIIgT7cgxl2iGz9NGbz+oqD+z7R4uipb
	 MlHc57XrlpS/0AOHajc/0NuYjxxofw1ApGajdCFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Daniel Wagner <dwagner@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 575/592] scsi: elx: efct: Fix memory leak in efct_hw_parse_filter()
Date: Mon, 23 Jun 2025 15:08:53 +0200
Message-ID: <20250623130714.115248169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



