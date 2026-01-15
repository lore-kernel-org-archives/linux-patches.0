Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A97B3BC4D7;
	Thu, 15 Jan 2026 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497007; cv=none; b=b1SCkn9Q6uDv6NoTFHklDKwPEamhQqjKC8xxHn+jYLFsSt28lfGDDgdNSaqOYJNfxSk4x5UEzyFlhqXcbuGwO/HT58nOERNWZxiSy40tkSjGcBuWvCgqhVEMXW6wVvH+kzqRtPR58iH+LKkKx4XH/X9Fxm93beoj7wRjT9+/3sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497007; c=relaxed/simple;
	bh=28rqhXGbb7an3ve7Ya/V50K3VjoL3kqXKOMz8M2k1N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NH90z8F7Y/idmOkgwsTIExrsqI4AyRFBH1XnW7UoRcHrEmLdIs5hK8nZ7di/C4oYUKHI5qsk+B3X3GfUbTnDiNdSHIB512PM4ih0SXWSQt1F+iHAA0BaSBoh3m7t8Z0ziYnW3h0HvGuzRRxOlbqJmAaV7zg06K3PjYME8WwObHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvhC2xLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvhC2xLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF94C116D0;
	Thu, 15 Jan 2026 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497006;
	bh=28rqhXGbb7an3ve7Ya/V50K3VjoL3kqXKOMz8M2k1N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvhC2xLtvFCQQwPCWqmgBP5vLnAY3NSyekjQkSEw819tccXs2h86Mupk5NYjBQ4bs
	 SEmPiG5hZiN2VgorRLGt2yb8aZMod1+l69t0pWTWvahg+EYQ0YbX735c5DMxwrveCY
	 tef+7vyf16M8IPeh7H7pjt7Md30Ki62kuMST9bZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 79/88] powercap: fix sscanf() error return value handling
Date: Thu, 15 Jan 2026 17:49:02 +0100
Message-ID: <20260115164149.175839787@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



