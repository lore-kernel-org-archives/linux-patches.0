Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3503AC0C9;
	Mon, 23 Mar 2026 13:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273992; cv=none; b=LbmHflNs3W2T7bQ3bav4JVjIXeOemk69Wf8cPFoIjDbmkLnsnGp1hkXRUulVOXnNOJjSuf9oF25DffhRz/MQB/SjCEyA0fsqls4Cdn3WPeLSY5h6IMAkuEK7FUOH0hfbyqc1tBPu6AGkWpXotUM8rrAeL2H0g04YYVESiBgjn+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273992; c=relaxed/simple;
	bh=L9MOWb1cNo9UtGpzUBiYJZ6DNmw+7HkhcCU0U3al404=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNtOlmfzPiBSoh7dQEcq+hDNr5Dy7mSoDfdemcw0jqjwSrUISZ7MfUoXhYML1v5+TabSvkmqV/4aaDhh+L+h299pbKOI9sPfWIzQSIyT+iXVkE99rJ8pINkrPxzyN/7FTThJKcXTSXkZTgV/ei19l/3uXGzWXIS4N75oq8jYNNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7982YCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7982YCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4E8C4CEF7;
	Mon, 23 Mar 2026 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273992;
	bh=L9MOWb1cNo9UtGpzUBiYJZ6DNmw+7HkhcCU0U3al404=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7982YCJiu5r1iqrVWowpqNufZI1QxFyEFcjpGxcdGYjsOSbb4joYRKVNfp5tcX3u
	 pleYzNAI7m9bq/zW+rv8ELbCLtf7ej6rv4C3YHRzesSeUETjCKYUaqDNyzKNcje3aG
	 glNzpymNNw82Chl+UBR50IkoEk3aG0S6u1/5T8/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LiarOnce <liaronce@hotmail.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.19 072/220] drm/amd/display: Wrap dcn32_override_min_req_memclk() in DC_FP_{START, END}
Date: Mon, 23 Mar 2026 14:44:09 +0100
Message-ID: <20260323134506.870793368@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1789,7 +1789,10 @@ static bool dml1_validate(struct dc *dc,
 
 	dc->res_pool->funcs->calculate_wm_and_dlg(dc, context, pipes, pipe_cnt, vlevel);
 
+	DC_FP_START();
 	dcn32_override_min_req_memclk(dc, context);
+	DC_FP_END();
+
 	dcn32_override_min_req_dcfclk(dc, context);
 
 	BW_VAL_TRACE_END_WATERMARKS();


