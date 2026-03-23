Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1FF23B62C;
	Mon, 23 Mar 2026 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277188; cv=none; b=nuXczZyEcLEuJZtNwY6pyyqvxvf/p17CQT8OS/fNan+iaLhuYuwSQKLvPJzZZkb5XR6eP7zYcKLojfPpo/XfrRFisJJd8kf28xVHLvrwa/dRrkxm+UZ7tQf8fU8SIKC+Xiey7CllnuPiv0fnecVsDiDz/JjkfLtUk956F3FHQWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277188; c=relaxed/simple;
	bh=S1vm/XtUhJqBJvOJkc04X66LiXOEpoWGjro2yNxKPYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3Z3XL1cro56/jg06iiqxBfEoGw2ciZeB7U2tDkDlsxiUk87LqcXEm2MzD0stSna9MIzVtk2yLaPt6dwFoto5lWhiRIuOYViBPN66GT9Igz6B/I+WM5oN8dd/5nM/bSsVhatxWaCYXTAcLZgG46C5jFmXobMAA3ipgDGvppVV/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o6f5gVby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o6f5gVby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A012C4CEF7;
	Mon, 23 Mar 2026 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277187;
	bh=S1vm/XtUhJqBJvOJkc04X66LiXOEpoWGjro2yNxKPYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o6f5gVbyUs4V1vC+J6GayekqGnizImiOGCXVQR8JPiDzrzVnHr0OOml9V8cGT14SJ
	 7bqs4L404oWXul0iNEEYLin5xXu6Z410vqPVR41Z1NMx9jG0olVb9uB8AEtoxMMkPC
	 YPXxVvYVShbAlw6BoHDsRP8oVcXmOVmEnSw04iZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiarOnce <liaronce@hotmail.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 350/460] drm/amd/display: Wrap dcn32_override_min_req_memclk() in DC_FP_{START, END}
Date: Mon, 23 Mar 2026 14:45:46 +0100
Message-ID: <20260323134535.149263917@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Xi Ruoyao <xry111@xry111.site>

commit ebe82c6e75cfc547154d0fd843b0dd6cca3d548f upstream.

[Why]
The dcn32_override_min_req_memclk function is in dcn32_fpu.c, which is
compiled with CC_FLAGS_FPU into FP instructions.  So when we call it we
must use DC_FP_{START,END} to save and restore the FP context, and
prepare the FP unit on architectures like LoongArch where the FP unit
isn't always on.

Reported-by: LiarOnce <liaronce@hotmail.com>
Fixes: ee7be8f3de1c ("drm/amd/display: Limit DCN32 8 channel or less parts to DPM1 for FPO")
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 25bb1d54ba3983c064361033a8ec15474fece37e)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1784,7 +1784,10 @@ static bool dml1_validate(struct dc *dc,
 
 	dc->res_pool->funcs->calculate_wm_and_dlg(dc, context, pipes, pipe_cnt, vlevel);
 
+	DC_FP_START();
 	dcn32_override_min_req_memclk(dc, context);
+	DC_FP_END();
+
 	dcn32_override_min_req_dcfclk(dc, context);
 
 	BW_VAL_TRACE_END_WATERMARKS();


