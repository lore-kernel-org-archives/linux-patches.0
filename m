Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29BA2ECEAE;
	Tue, 17 Jun 2025 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176878; cv=none; b=cTvB4rm/hL7fBKyo9TziEZHGGQP5dzH2DQMrCCvOwA6WWNdAW6VG0/6rD0pnwWhoZOqJQ18TuskcB8hASPPZ5rzgbignjppLGAIUQdOxXADktnDR17gfhZsGv19nbTByX2e09lcv9ZCB7Y4mU9hXKSVb6aovt4DSxqUmVkkp4X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176878; c=relaxed/simple;
	bh=AJK/WDHkqL0swgjbygnTQ6xllN47Lu9u9NDFZnmpMdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdqIB2+jClT8tmvCZegUHvi/sr+z7vSRp38+dEN1lJ0zeiN/tZCYkwDrX4VpeE1s9uijkBLnrm0zMYodWLlOV4pOkQGlnhDvizAHhFVZz93GCxjf1nbLl50xKIhGEsbJZOW0zjZx/CFDRCw/Enyzs5pFo0sG7tcQKP701iB8qd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nROSNiJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nROSNiJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22634C4CEE3;
	Tue, 17 Jun 2025 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176878;
	bh=AJK/WDHkqL0swgjbygnTQ6xllN47Lu9u9NDFZnmpMdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nROSNiJD119m0nnzJyNB+ws2i8np+Uj/HEvOe2y4wJd0z62xTvLMCB72q4ragiBg2
	 sd6+glO4VZzeMI2NcQIazWGZtC1NN2gemSTQvAwEsW1YSxTyRCVdmN51ZIZcqG4rOp
	 klXL7K9WlkuTs0vZrUJkBzwtcW0VqQM8SXpyHY04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/512] backlight: pm8941: Add NULL check in wled_configure()
Date: Tue, 17 Jun 2025 17:24:01 +0200
Message-ID: <20250617152430.737635583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit e12d3e1624a02706cdd3628bbf5668827214fa33 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
wled_configure() does not check for this case, which results in a NULL
pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: f86b77583d88 ("backlight: pm8941: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: "Daniel Thompson (RISCstar)" <danielt@kernel.org>
Link: https://lore.kernel.org/r/20250401091647.22784-1-bsdhenrymartin@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/qcom-wled.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/qcom-wled.c b/drivers/video/backlight/qcom-wled.c
index 10129095a4c17..b19e5f73de8bb 100644
--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1406,9 +1406,11 @@ static int wled_configure(struct wled *wled)
 	wled->ctrl_addr = be32_to_cpu(*prop_addr);
 
 	rc = of_property_read_string(dev->of_node, "label", &wled->name);
-	if (rc)
+	if (rc) {
 		wled->name = devm_kasprintf(dev, GFP_KERNEL, "%pOFn", dev->of_node);
-
+		if (!wled->name)
+			return -ENOMEM;
+	}
 	switch (wled->version) {
 	case 3:
 		u32_opts = wled3_opts;
-- 
2.39.5



