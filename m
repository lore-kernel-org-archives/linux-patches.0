Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC44C81;
	Thu, 15 Jan 2026 17:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498781; cv=none; b=n3MAHH3eWWSH6G3n6Es55jayeyU7TJB4hr8b650iPMwnV01/JauCozM1LZnnimpO67smpAyNjK9McK3A3qxCdVdaeZ+CwsRh3Vph8jlfAZ/VT/k1FkJumuxabUoUp9eblayWrQ7gBzxHVSd9IsZM31WIE4jGLqHFcRmtj5Xsync=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498781; c=relaxed/simple;
	bh=/0AB8qhSFS0x3bbO6465w80vjtUlwbYeGZqI6/BGgRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9Ws1uVUEFymEff1sglS3bVz61pfu3O9+/zsn35XbQrwVKFs8ctxVtT2zrYKgermy05M3oSUn7f2wvbjQe6YiMoQxgdHN1CZEHSsuAms5UOZN69LXtahN9FOIW+jZfhxDa8+Gb4CqK6Dmw2dlSGMEav0NFkNSczrjitba997Vj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/wJhxEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/wJhxEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729C1C116D0;
	Thu, 15 Jan 2026 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498780;
	bh=/0AB8qhSFS0x3bbO6465w80vjtUlwbYeGZqI6/BGgRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/wJhxEGlb5217gXExabdHUWNAd+lSvRXE0x25zaqRs6B6fZTFqfGOfh8vTX9yzGE
	 V0Zjm9z/BPuQPmtuB5U9SU6lPIWjMNyj0pHQqc3uhkkLid9ifKLMXADQA0tA5jKURZ
	 DJLYSAyw7uEBtPfiaGFx3TmKsBZQruX+M15iMk+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 551/554] powercap: fix sscanf() error return value handling
Date: Thu, 15 Jan 2026 17:50:17 +0100
Message-ID: <20260115164306.273710428@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit efc4c35b741af973de90f6826bf35d3b3ac36bf1 ]

Fix inconsistent error handling for sscanf() return value check.

Implicit boolean conversion is used instead of explicit return
value checks. The code checks if (!sscanf(...)) which is incorrect
because:
 1. sscanf returns the number of successfully parsed items
 2. On success, it returns 1 (one item passed)
 3. On failure, it returns 0 or EOF
 4. The check 'if (!sscanf(...))' is wrong because it treats
    success (1) as failure

All occurrences of sscanf() now uses explicit return value check.
With this behavior it returns '-EINVAL' when parsing fails (returns
0 or EOF), and continues when parsing succeeds (returns 1).

Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20251207151549.202452-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/powercap_sys.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index d7dadcaa3736b..72fa1f5affcea 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -67,7 +67,7 @@ static ssize_t show_constraint_##_attr(struct device *dev, \
 	int id; \
 	struct powercap_zone_constraint *pconst;\
 	\
-	if (!sscanf(dev_attr->attr.name, "constraint_%d_", &id)) \
+	if (sscanf(dev_attr->attr.name, "constraint_%d_", &id) != 1) \
 		return -EINVAL; \
 	if (id >= power_zone->const_id_cnt)	\
 		return -EINVAL; \
@@ -92,7 +92,7 @@ static ssize_t store_constraint_##_attr(struct device *dev,\
 	int id; \
 	struct powercap_zone_constraint *pconst;\
 	\
-	if (!sscanf(dev_attr->attr.name, "constraint_%d_", &id)) \
+	if (sscanf(dev_attr->attr.name, "constraint_%d_", &id) != 1) \
 		return -EINVAL; \
 	if (id >= power_zone->const_id_cnt)	\
 		return -EINVAL; \
@@ -161,7 +161,7 @@ static ssize_t show_constraint_name(struct device *dev,
 	ssize_t len = -ENODATA;
 	struct powercap_zone_constraint *pconst;
 
-	if (!sscanf(dev_attr->attr.name, "constraint_%d_", &id))
+	if (sscanf(dev_attr->attr.name, "constraint_%d_", &id) != 1)
 		return -EINVAL;
 	if (id >= power_zone->const_id_cnt)
 		return -EINVAL;
-- 
2.51.0



