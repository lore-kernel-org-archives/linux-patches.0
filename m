Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192D77404E;
	Sat, 17 Oct 2026 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254756; cv=none; b=kgCYXpFdsPoPAkje287GWOk0TITp5QDaPH78g4GrkGVgT+hs7LcUdnMKftUg4dSGOpEJUvmkM+I282qnVyKTmloY1QQ9Huk1HXjDh8/NexazyjyIXjdy/qgumD9Ep0P92YO5mHUTGBD0SpahfNqzkVK4d8uIVJcnBEHz1KOvsYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254756; c=relaxed/simple;
	bh=ilbOVfdpYa4oGtgSQ3ARMKfesBpwcj7zDKu1GDZwOjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn3uXPw9DV39b3VqByMhVeLr7v6XWlfFy6cWCnlks5vW4hNrECxed2di6s244cGftLcENJiBp97/fvSPC8LT0f0mEDAd2qrtvBBHNeeSpbIxcvfQKM7JPJL3lHSl8n04ZCclwerXQt0p0lF5l3TrrMoyHBlQwTSObGeuziPucio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4bH1daB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4bH1daB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAD41F000C4;
	Sat, 17 Oct 2026 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254755;
	bh=CmSv5ZCgZ8IOxzL8ZTuG8o+6AVRe2ndh/412O7V9l1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4bH1daB9zt2+qWkM82G/9drBR6gjJhcIStU6WdSETBS7oGvCyIpS0hZ6+W/nNarJ
	 B4+6ygbPb8SLdbPtyfVsy36sN0Ane3xY64V0Ra49B1Id11BEAMRcnn8tERvkJNiQMy
	 g7YD6/nck9FSwXMgGZ2dm5C0XN+8ij7kgV8hZ56U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 550/869] drm/amdkfd: Fix infinite loop parsing CRAT with zero subtype length
Date: Sat, 17 Oct 2026 17:56:31 +0200
Message-ID: <20261017160051.189723312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongqiang Sun <Yongqiang.Sun@amd.com>

[ Upstream commit 961323c26ad4c895e3b0ea1711fc41dfd6368c12 ]

Malformed ACPI CRAT tables can advertise a zero or undersized subtype
length. The parser then fails to advance the cursor and loops forever
while the remaining image still looks large enough for a generic header.

Validate sub_type_hdr->length on each iteration before parsing or
advancing. Return -EINVAL and warn when length is zero or smaller than
the generic subtype header.

Signed-off-by: Yongqiang Sun <Yongqiang.Sun@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 6e7566ba4739 ("drm/amdkfd: Add bounds check for CRAT subtype length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index d2993594c848a..36c259b34afd9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1403,6 +1403,14 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
 	sub_type_hdr = (struct crat_subtype_generic *)(crat_table+1);
 	while ((char *)sub_type_hdr + sizeof(struct crat_subtype_generic) <
 			((char *)crat_image) + image_len) {
+		if (!sub_type_hdr->length ||
+		    sub_type_hdr->length < sizeof(struct crat_subtype_generic)) {
+			pr_warn("Invalid CRAT subtype length %u\n",
+				sub_type_hdr->length);
+			ret = -EINVAL;
+			break;
+		}
+
 		if (sub_type_hdr->flags & CRAT_SUBTYPE_FLAGS_ENABLED) {
 			ret = kfd_parse_subtype(sub_type_hdr, device_list);
 			if (ret)
-- 
2.53.0



