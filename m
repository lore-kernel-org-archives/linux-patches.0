Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9CE3BB690;
	Sat, 17 Oct 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259644; cv=none; b=leH9aNuTGJiFlYgRZv5AmkuHOclGJftaZ3GKI2oPMeCBlTRCLqOHRROaVgW42dHZOyWbTtdEMaEUcp+M7PO9ZD/NJPa282aAo6TB6edVeOICHodBPHY/Rt4RKQs0YXa4XbbXirUbpr9te+y9I9W+RKeHA5ialVcLLbSexXYAbUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259644; c=relaxed/simple;
	bh=shWONSZUFHdLbPIR947CkDlFihoIna0I/ZpL/WIzJb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mg2Ndsdt2OGiwlk/fIFJcum9RmXlujdZvhieU379Fv8syeXzW2w9XSg5TbfP94H1d16yNw6MPfZMuA0RJ2sCP5SJyb0K++3Tw3ZaWenBlKo+JsGr0BIwz/wE5a+FSdgUOJmzzEmZOkPNHOqqv5mxMWWd55204XBhEQYe+GJhthA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7mymXBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7mymXBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7F21F000C4;
	Sat, 17 Oct 2026 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259643;
	bh=DZVdLU2DnsAnXYe2h34HqnN06IcuQ5YlK9xi4lOrHHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7mymXBRmtzw6pybBHCjIlO9sqr1Hzdqj25yyrzFJzzkfIhofuJoPelDWd71sRdOM
	 7ca/9wzSkwFwkLjD729NX2VuhV1fWR2rVTP3NGDahgPrwUM2uD6uRbTd4GXWVm3mDX
	 YLfAramXsyh+PwDg4JkxCzF9bmrTER1mzhDZCuF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1241/1674] drm/amdkfd: Add bounds check for CRAT subtype length
Date: Sat, 17 Oct 2026 17:58:33 +0200
Message-ID: <20261017160502.990023638@linuxfoundation.org>
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
index aadfc8b9e76d1..2753e98dac2f8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1322,6 +1322,15 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
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



