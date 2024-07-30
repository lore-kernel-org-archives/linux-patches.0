Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901611A618F;
	Tue, 30 Jul 2024 16:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356138; cv=none; b=PDVGpmZdV3YcSxRISctRC7/1d5tsjwos5mSY3WOqwi26qrdsOH+FuvFF00mWI4Noz3PcvUrKrWItjnh2RmoqPUcWXeq0VCFvSAVvT3aVW72MK2a+6T4WUre8H5l7qj7Loe6Za3ys8RfAFPj681dxpJLUaQLu743Hf7J5MvCWD3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356138; c=relaxed/simple;
	bh=/SV3mfQsCZvdn7q0KgMYpgXdOEaxJAuVL+4R86eTBS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blukkMfTI2VvnvKfzpzKGZ0V7Ru+nC+jqONCho/mKyS9HoRGL9Fg7P6xlEgLO6bSQuS/iiQHCsZDSc/Bnpsq2gm9ghcFOVawXlg3x93kQTxpSGZDpyBxLhJpubxx4D+2wAC37zNo464e8mKB/ORB8O6U1H/SQLBean8k1uvKmRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMKsDzp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMKsDzp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D74C32782;
	Tue, 30 Jul 2024 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356138;
	bh=/SV3mfQsCZvdn7q0KgMYpgXdOEaxJAuVL+4R86eTBS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMKsDzp9DespHdPEHl3RCcXFlZEcq79kVMw3K0wDOML+ixnyfVqfUiIVBYkZ7SM+Z
	 gYrXWpLADFliQstnizA9KzAdnbdHdGLoqeACo7DpoSGzLMjFC/GVsg3fcCRe9l+p27
	 EvJD85pRNTeF+Hn1JriLlg2I3A2HHJXMNRvCD3hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Heng Qi <hengqi@linux.alibaba.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/440] drm/qxl: Add check for drm_cvt_mode
Date: Tue, 30 Jul 2024 17:46:35 +0200
Message-ID: <20240730151622.200994648@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 7bd09a2db0f617377027a2bb0b9179e6959edff3 ]

Add check for the return value of drm_cvt_mode() and return the error if
it fails in order to avoid NULL pointer dereference.

Fixes: 1b043677d4be ("drm/qxl: add qxl_add_mode helper function")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Heng Qi <hengqi@linux.alibaba.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240621071031.1987974-1-nichen@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/qxl/qxl_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/qxl/qxl_display.c b/drivers/gpu/drm/qxl/qxl_display.c
index f91a86225d5e7..462a4d2ac0b95 100644
--- a/drivers/gpu/drm/qxl/qxl_display.c
+++ b/drivers/gpu/drm/qxl/qxl_display.c
@@ -236,6 +236,9 @@ static int qxl_add_mode(struct drm_connector *connector,
 		return 0;
 
 	mode = drm_cvt_mode(dev, width, height, 60, false, false, false);
+	if (!mode)
+		return 0;
+
 	if (preferred)
 		mode->type |= DRM_MODE_TYPE_PREFERRED;
 	mode->hdisplay = width;
-- 
2.43.0



