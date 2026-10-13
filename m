Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E7D4F3EB0;
	Tue, 13 Oct 2026 12:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893849; cv=none; b=slrfTA0pC6WkuG9g0CUT3HVxrK/IdWnCTEJ41G/MMN6blO7S+UAERL38n8jcPNnvnSOBzUfe3hT8k3DXTkZDzZWs9I0+FX91TMNdlFnoXzpni3m3nCuo3R/kF9Wlzk390XRQX2d5qfA0Z+Z0e6yJwLfgbxnlMuiNzXVd8qcJL98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893849; c=relaxed/simple;
	bh=SLccd6KKdE3XTWEote002M7/whZitdDjO8mB7aq/TAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZBnQSkfzaCc4cdbFoZZFcILbebW8xpMbKUav0MP/rWcLCHs3wkKvEsrYjOGQx+Vh4RPWPDZbDPbWdkMDAt7Ar0Z9MlrSOdDFc9Wf9Lc87OJTlN1PnOmAwSi4JiA9QDaZoQbfmP+T+lnSCm3yzHhbI9eDcPlZUadLEZ9Z5EnSCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B0ZPg52n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B0ZPg52n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39781F000FF;
	Tue, 13 Oct 2026 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893848;
	bh=oSBXk1lXI4nvNUz7l0y4x1yoMwUg0wxWryELq+xybDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0ZPg52nLyYXq2m9QBHs6IiZKmKqcdfPz9HGOLbSLRaVceSqaCK/SPK/LE+uCGvzX
	 DYRpSekqVTNl3iiG46NQsU1X0j3tPixV8ir3biCiUZfhCvSDpGVuQO+iL/wuEm+mqx
	 7BOvk2pURS4B6i+hRwRZPC7Gd9bJ9W8qRbjiq62w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 363/621] drm/amdkfd: Add bounds check for CRAT subtype length
Date: Tue, 13 Oct 2026 13:35:58 +0200
Message-ID: <20261013112929.464454954@linuxfoundation.org>
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

From: William Palacek <William.Palacek@amd.com>

[ Upstream commit 6e7566ba4739dd573c331adde1c96690f7a567bd ]

The CRAT parser validates that the subtype header fits within the image,
but does not verify that the advertised subtype length fits. A malformed
CRAT table with an oversized length field causes out-of-bounds reads when
kfd_parse_subtype() casts the header to specific subtype structures.

Add validation that sub_type_hdr + length does not exceed the image
boundary before parsing the subtype contents.

Signed-off-by: William Palacek <William.Palacek@amd.com>
Reviewed-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 48e1d1e6e8798aef0312e68d8e586021b5b3cf4d)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index ee8660a88060c..b0e87bdc29114 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1412,6 +1412,15 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
 			break;
 		}
 
+		/* Validate subtype fits within remaining image */
+		if ((char *)sub_type_hdr + sub_type_hdr->length >
+		    (char *)crat_image + image_len) {
+			pr_warn("CRAT subtype length %u exceeds image bounds\n",
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



