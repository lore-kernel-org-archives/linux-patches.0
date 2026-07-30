Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5072F44AB64;
	Thu, 30 Jul 2026 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427907; cv=none; b=AdlEQ0PqtLShG3i7fr464+TW1xkE2wf78ajIoC9fJsMSCKSSOAyWBeE1a7mXRg/MuPCS1q8ShaUPYf764duEjmiK8DaXJQ2pRkaPl5xCRUAh/PsxC3YL4Y4gxYJk3NTUF8iPbq9nf5u9Qp8jKv51d8TmS/uJFsSvrVdLM9wG/xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427907; c=relaxed/simple;
	bh=3bCi6vTPALg7XLrobQ6W/mhQcHRkv6ZND/1U4i5FniI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8+CD/3ZvVuX1aPRUOVsd71hAh3WYPBqKwe1jXM3D5329Ki7hW3qa7PSC1OL3Gg/uz+YUdTmaMrj2BZJekW2qrG3qXqiH41oyS3/qMkoFgXkDGlUSeHSNwkV+RvhZ9lacVvbE6TJvs3DQLypvbDo3XbLXgg8jyRcn2ecw93kjno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxdsP0Vt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxdsP0Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBAF1F000E9;
	Thu, 30 Jul 2026 16:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427906;
	bh=3Al5y/DMD3j3MdwFnLqpe3U6ftBRz9YXoxgI9Rwo57o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxdsP0VtKJcf00nrBtwPRsCXUEGMZDYTE74Hdy1X+kot553YyG3aOfFgjfH3Pfixc
	 piwnjs5eOLDXf+ouGrjgJZnvlpE7Y76D//YYzNNdYBTtJWKOX+V1OLihzPTu15qMQZ
	 8yfH9Xx8WDIEFmQMORXNn1H2SsrSde+wb4ejro/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 336/484] drm/amd/pm: make pp_features read-only when scpm is enabled
Date: Thu, 30 Jul 2026 16:13:53 +0200
Message-ID: <20260730141430.782608215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

commit 53c78ab388bfc1a4d72e756815d0db0a842c812e upstream.

SCPM owns power feature control when enabled.

Make pp_features read-only during sysfs setup by clearing its write bits
and store callback.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 6a5786e191fdce36c5db170e5209cf609e8f0087)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2055,6 +2055,11 @@ static int default_attr_update(struct am
 		     gc_ver != IP_VERSION(9, 4, 3)) ||
 		    gc_ver < IP_VERSION(9, 0, 0))
 			*states = ATTR_STATE_UNSUPPORTED;
+
+		if (adev->scpm_enabled) {
+			dev_attr->attr.mode &= ~S_IWUGO;
+			dev_attr->store = NULL;
+		}
 	} else if (DEVICE_ATTR_IS(gpu_metrics)) {
 		if (gc_ver < IP_VERSION(9, 1, 0))
 			*states = ATTR_STATE_UNSUPPORTED;


