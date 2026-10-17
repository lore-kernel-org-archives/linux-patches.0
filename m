Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9C129B795;
	Sat, 17 Oct 2026 16:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254759; cv=none; b=Ht59TcafdjG6xgZGOL66VfbxasR7RCC68owlTx1n4hunPB4yHXx/x0V3sAz6l6u+wVP4VbKmQ4zHPRN/2gRiLM/OF11Pv00nyVAhjOWie8Wrj8WQBpSr/lkETQUS0MCl1ioJZ6SEE3sOXsu9gz4/CNQB/DNsXtlTXd0OQMjwvAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254759; c=relaxed/simple;
	bh=71cbOy3i/U+8U+3FiMNc/rTZ+sOjuuz1+TTxHxYPgpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7e8gefsMXjDbRs93jNtJzwLfGOxfADtpwJpjdHHiPNPxvFGvEatAB0RQqtnWm1LNAcVXJBFDjoXJunjskGVTLmFfGO7Z/bhgsUuzrhOCq2VsdHA/u3pQtX4NpNzdGyR6D8wvxl3IfcQ0rJp03sKUyPq8UAYl1rkmVFvhrsBCcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufXcFzZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufXcFzZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828D31F000C5;
	Sat, 17 Oct 2026 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254758;
	bh=pynOI/990mQdV9TNzf9sxqDLIpe2vu58GpPcSkyV3sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufXcFzZt6MZNY3VddFFKenZ/mWbv6paVw5V4OSzFOeAz3+PoA9ybC5vCm6RWOpg9G
	 3Q0wkL6xQIFPQ4vwRxsGQrj8Ytf+4EWuDYqXoyz2V3k6uHBin3N0OUzbd6yQht2Sht
	 ji7Sfxz25YhztlQ+0jrok7T9YBHxtLdRW0rG02lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Palacek <William.Palacek@amd.com>,
	Alysa Liu <Alysa.Liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 551/869] drm/amdkfd: Add bounds check for CRAT subtype length
Date: Sat, 17 Oct 2026 17:56:32 +0200
Message-ID: <20261017160051.214527084@linuxfoundation.org>
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
index 36c259b34afd9..f4e40ed231fb0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1411,6 +1411,15 @@ int kfd_parse_crat_table(void *crat_image, struct list_head *device_list,
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



