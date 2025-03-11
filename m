Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B344C25E83B;
	Tue, 11 Mar 2025 15:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706216; cv=none; b=bq7UaDEt+CbbH811ryPKyoO6CnfrGfaswLVrxBZJcol4DGmDVTMCJsxr6BrmT8VPjCqdKTRtSMUGQdbjvMGOK9lkYEKwOA31QqTyzr9oQH8pImIbTTAjbclIE1yutudl/qDst35CmWeZ0oK1mOW7RnVcLWizCevLV0RW13Tut/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706216; c=relaxed/simple;
	bh=2rOzjLWupE/+qGhGqGgEPmt+o6VKbyh8d7/z19yyLbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRbWCAcsaHqLs/cP5WCa1qjWfp3HeNZizjBvQkPIOwt0LOx1NrDXprHVJdhcYP6Pwut4+cXsqDjNTLKOnSyMXrQ7T1ZipTsChClOEnfqLdj0uNHFrLn2ioqheEXAbOVS2qH2/c9pHvCQxJZyS9THd8SFkL9uw+wIRRVD5v1jJkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoFLoahm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoFLoahm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8BDC4CEED;
	Tue, 11 Mar 2025 15:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706216;
	bh=2rOzjLWupE/+qGhGqGgEPmt+o6VKbyh8d7/z19yyLbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoFLoahm+a2apKXfdRW2uC6JczY6GueouD0FfwMIRqHNAkIFqBQCpkVk4m9liHmGJ
	 VjcHBmoXqCY9TLrcAT0tSuCafODStYCXmEAojATnu/ktuHSfqSs2MdP/AK5SzPA1PE
	 rBm/j/QEi+GE1mjoPKe7Qdcvospv+mJIbLuqVcMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinghuo Chen <xinghuo.chen@foxmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 302/328] hwmon: fix a NULL vs IS_ERR_OR_NULL() check in xgene_hwmon_probe()
Date: Tue, 11 Mar 2025 16:01:12 +0100
Message-ID: <20250311145726.909443738@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinghuo Chen <xinghuo.chen@foxmail.com>

[ Upstream commit 10fce7ebe888fa8c97eee7e317a47e7603e5e78d ]

The devm_memremap() function returns error pointers on error,
it doesn't return NULL.

Fixes: c7cefce03e69 ("hwmon: (xgene) access mailbox as RAM")
Signed-off-by: Xinghuo Chen <xinghuo.chen@foxmail.com>
Link: https://lore.kernel.org/r/tencent_9AD8E7683EC29CAC97496B44F3F865BA070A@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/xgene-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index f5d3cf86753f7..559a73bab51e8 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -719,7 +719,7 @@ static int xgene_hwmon_probe(struct platform_device *pdev)
 			goto out;
 		}
 
-		if (!ctx->pcc_comm_addr) {
+		if (IS_ERR_OR_NULL(ctx->pcc_comm_addr)) {
 			dev_err(&pdev->dev,
 				"Failed to ioremap PCC comm region\n");
 			rc = -ENOMEM;
-- 
2.39.5



