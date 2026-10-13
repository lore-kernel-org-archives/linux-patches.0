Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7617C4F4D0C;
	Tue, 13 Oct 2026 12:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893846; cv=none; b=WmNEICMzUniw1VnCNfppKbeGVK8Bp3mcTi3qibYnVqf8R4zAqZBcE+L6w2/XeQV0ZgdbZU1Her87wfY8Sm5Ns5ofw2PQ52VQCgGfWe0DYJ+MetH12E5CJWCLosbW7c3iQo6BszqeO0hSv4P+vky8DzKWQ3UEcWPsk72SU+X+v94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893846; c=relaxed/simple;
	bh=leP1k2pt1U11QVA0nDqsE57YlHl5U7OIngqXAC6W3oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLrRbpqnvBUDNb4wFzpX8jMeeO2EeKEIzpLWJjxcLCApm3y9xy77k1oKaFjNtCaZm7CyUcfCxSILcrC6y9mVL4GQ+lB5/IS83T8bivM5KVWi07hpyUVHYqxD/OVzaNMwlNuYBszLFI7luZsHoO0U1t2kni293poJhv+Q6IAAdMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GY+WzBBg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GY+WzBBg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7661F000FF;
	Tue, 13 Oct 2026 12:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893845;
	bh=885RaKHm6W6kCKDWyLoLq3z8yReUsQ57BayJCA368mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GY+WzBBgN3HSuR2FCEaei2KZD7wKj0IDZsbULZH2j8UzU0K1o8Lo9W/I4ly4JqkPa
	 fEoVKTZRX42K2O02JjFl+RC4ULsLW31401Y2WyRRXxcA3C0s5LpjfVP0lsGomeVWhk
	 +DxTWovlF8A5p4Nyb8k+SokGFuexTI7BHTNUaK+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Sun <Yongqiang.Sun@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/621] drm/amdkfd: Fix infinite loop parsing CRAT with zero subtype length
Date: Tue, 13 Oct 2026 13:35:57 +0200
Message-ID: <20261013112929.439317428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 4a7180b46b719..ee8660a88060c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1404,6 +1404,14 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
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



