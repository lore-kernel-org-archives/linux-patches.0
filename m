Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8C33A7F43;
	Thu, 15 Jan 2026 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496355; cv=none; b=aHN1ke2yht/EC3lJ0/y5u8c9fK8TrBOFJAMIH4e7auuM+PWhaUrfUFiZY02aUF2r29P34r/k9I4I51g/Kaw0spdaINkXYFoF4kjtbm5KNpENoF03Xy2WELONk/5nDm6RGX69E/sVq6h+85mKJb2QUzSlbvjblITwVPOd2qyMDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496355; c=relaxed/simple;
	bh=uZVyFHlzs3TQwp8HILQgZcg1VQsEU6LI67HCh4Km014=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwDIriLgAR6BAfmqsMoyXrFepuqvPYqBwU8V0VH13nL6/iWhvQiX0y8l3a08ymuxqLfb2ckC+0pMjnbqYiVUMHgxXqfvQAALenPOBRJAFjPLPpPF1vHDM7o4U0WGaFzcAHTHZewByFHJhAIEem6EhTcVWxjyaPb36z4G9K6uDRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBodCWDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBodCWDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C45C116D0;
	Thu, 15 Jan 2026 16:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496355;
	bh=uZVyFHlzs3TQwp8HILQgZcg1VQsEU6LI67HCh4Km014=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBodCWDplytF4kM/l5ijjKGfiLOaNTWUrvkWd2e2noPb/qdMLOGdotwrinXDUOq9f
	 RNqNGQAk2ai9HP0Hay/ArQlekbYmD2ai/9sx3E8hAEjcs/Ycc6wHWNi29kYqVjp83i
	 Dj2T/IBUTstNSQdBGkR/z6G6qKjetkBTyXX2Vonw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 167/181] powercap: fix sscanf() error return value handling
Date: Thu, 15 Jan 2026 17:48:24 +0100
Message-ID: <20260115164208.343329934@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d14b36b75189d..1ff369880beb2 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -68,7 +68,7 @@ static ssize_t show_constraint_##_attr(struct device *dev, \
 	int id; \
 	struct powercap_zone_constraint *pconst;\
 	\
-	if (!sscanf(dev_attr->attr.name, "constraint_%d_", &id)) \
+	if (sscanf(dev_attr->attr.name, "constraint_%d_", &id) != 1) \
 		return -EINVAL; \
 	if (id >= power_zone->const_id_cnt)	\
 		return -EINVAL; \
@@ -93,7 +93,7 @@ static ssize_t store_constraint_##_attr(struct device *dev,\
 	int id; \
 	struct powercap_zone_constraint *pconst;\
 	\
-	if (!sscanf(dev_attr->attr.name, "constraint_%d_", &id)) \
+	if (sscanf(dev_attr->attr.name, "constraint_%d_", &id) != 1) \
 		return -EINVAL; \
 	if (id >= power_zone->const_id_cnt)	\
 		return -EINVAL; \
@@ -162,7 +162,7 @@ static ssize_t show_constraint_name(struct device *dev,
 	ssize_t len = -ENODATA;
 	struct powercap_zone_constraint *pconst;
 
-	if (!sscanf(dev_attr->attr.name, "constraint_%d_", &id))
+	if (sscanf(dev_attr->attr.name, "constraint_%d_", &id) != 1)
 		return -EINVAL;
 	if (id >= power_zone->const_id_cnt)
 		return -EINVAL;
-- 
2.51.0



