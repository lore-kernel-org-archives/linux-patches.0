Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F37330B06;
	Fri, 17 Oct 2025 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716118; cv=none; b=HCgO10zSyNV3qt4QgaToJb4q29FzqY7nq8pWFVA02MpciWNNIQMZQcBwS5o+C2mYVnfCZWuvjHHzohWwNUR7m1VBR4RsONrnQEPdjW5Oj7/GuDF7TL3Suw1OSbNchxlxBKUSCtjgj9+MhW9TjQOB7g8aodZHv6bq/fz8IyBJ534=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716118; c=relaxed/simple;
	bh=PG0ZqXrF5GWH85BsXMtgF1id3vvt/07sF2AI6pG1PaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k16QIsb4idVxnTOM2yS5+ajkWSSlhJZNVpWROimdSLBLcX05rjrmq+rMngumh5b8wCqrAXNjQukfgPS0L2MYqDtIy/DdWJkGsTUb6DGgPEgvU887yfT+3KI0bO8ODFwrbVCt+J4sY9lnR3uyE8SQlEEWQ1K1nrIzxp5R+2P8SIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r7iqFI+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7iqFI+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D38C4CEE7;
	Fri, 17 Oct 2025 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716117;
	bh=PG0ZqXrF5GWH85BsXMtgF1id3vvt/07sF2AI6pG1PaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7iqFI+9RmO/5aCxJO85KvcfTaF/4KWzoCOBnQBLOjWNZSnKCKhRtiGmgWz8V7Lgu
	 71vbfAO8pjBWFR/oWbzqUQespWm6B0F8F6MJvoSerWF7UYQWDUEH4dlk/C4frGQKHj
	 h66YJLCzWwH1JnWWGlQR5cUlPsqD0emv/Hpdnw5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/276] regulator: scmi: Use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:09 +0200
Message-ID: <20251017145143.723643422@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 9d35d068fb138160709e04e3ee97fe29a6f8615b ]

Change the 'ret' variable from u32 to int to store negative error codes or
zero returned by of_property_read_u32().

Storing the negative error codes in unsigned type, doesn't cause an issue
at runtime but it's ugly as pants. Additionally, assigning negative error
codes to unsigned type may trigger a GCC warning when the -Wsign-conversion
flag is enabled.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Link: https://patch.msgid.link/20250829101411.625214-1-rongqianfeng@vivo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/scmi-regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/scmi-regulator.c b/drivers/regulator/scmi-regulator.c
index 41ae7ac27ff6a..7c0d29c7856bb 100644
--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -257,7 +257,8 @@ static int process_scmi_regulator_of_node(struct scmi_device *sdev,
 					  struct device_node *np,
 					  struct scmi_regulator_info *rinfo)
 {
-	u32 dom, ret;
+	u32 dom;
+	int ret;
 
 	ret = of_property_read_u32(np, "reg", &dom);
 	if (ret)
-- 
2.51.0



