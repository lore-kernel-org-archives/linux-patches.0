Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9744D384CED;
	Sat, 17 Oct 2026 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259641; cv=none; b=dkZzjlmOd89qCn2NprHgXUqXRAKH8426FISspQ8pj3sDI+rQ+E0cvejRP83lwyh/CyhEHxjRzOA+VlsOqIjt58Xvm27owqnbELmUbj46rob9RAnc75jj1PkztNwMoxdd3MdV1Cgyc99OPYbhzFWCYq4Oy+ANFLfNFZKiaKgoJsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259641; c=relaxed/simple;
	bh=a2MyGlRGepsNFoa1vKhycpjzHYI2Y056o6WFcBfs0Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwWLvzstwJHMf9FE5yGOOwWv1vmOfGJkvp2Cd6shxpO+zfQEb2B37n/mmkwN/PYGJi6XOtqnA7jBpRTYxKouBUbFZRKvRjcbcYCsbcLC24NxGgGqhIRQbimrN7d4dlb57l0yNhCt6eVSTCdn7OnUwSq6Ei6GWCjIUVN5NEUfX5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bob2GHzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bob2GHzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927CA1F000C4;
	Sat, 17 Oct 2026 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259640;
	bh=HOkLf74+14kpiKEMBJxS0rY0MxJGJvkbReVpILOd/Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bob2GHzlf3jnqGtuRVsdfpzs1P2gGJPqgWluRS/EZx1BiJ9f4w4/t0RhA5zjq95a8
	 dLLS7FVegAJja1DTd+Vre+SNWKE6iRrZ0vsPsKCytUiNSGAfk1iFp1NMCIX9VxvoHn
	 PeKQHszPdt4ZWHUgirY/BFdFaooqPh6h/ZBq7Q6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1240/1674] drm/amdkfd: Fix infinite loop parsing CRAT with zero subtype length
Date: Sat, 17 Oct 2026 17:58:32 +0200
Message-ID: <20261017160502.965130692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 29a02c1752289..aadfc8b9e76d1 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1314,6 +1314,14 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
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



