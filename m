Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F0A22B8AB;
	Thu,  3 Jul 2025 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556225; cv=none; b=Fn2+Vw4mDftlpsCTndCLEWrLYRBu7ig5dPxeUMuw3nEym/m//Z7HPwiMseZfyajOcviLQcFs79baE9FLzQITN/E46FRpn3/iDmQ2mmmxtYl++yzQJgBErsuxkVa7G8XmM0zieJtOzlS7a4PqmqTxt0SAwHHgJ+E36xHa2IEGqLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556225; c=relaxed/simple;
	bh=7mOubytuXOTgGe80tbscs8AK6MDkmeuEXtHwsemMTXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfQ6tdyAXL3RX9JLipQzVqVo49E58OkARnhVsE/T0V5RWiRK+su9SfYPT/EG5E7xn22FIfYxYwl1qMTcGac3aTU7XLn8v4kxfu9Kr5uTVUvFmAjLZmk1h2nPMGF0ppktVPMMSUjYpBQA3ltOWLmLRJFsuXaY02MW3VR4DylyCfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jn/niCpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jn/niCpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2DAC4CEE3;
	Thu,  3 Jul 2025 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556225;
	bh=7mOubytuXOTgGe80tbscs8AK6MDkmeuEXtHwsemMTXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jn/niCpjgNKab2TgVwEISghJp3DOLcf34zjH2w9Rxej/j7OBCgmvstisayZCq8Xvw
	 fqkCwpam1uIDPPe7uacqpkNcm1i2Zc3Vtm01DH9cTgpPn89bqqlCQ/oWXH4N9witkq
	 z0rP7bxvYC41IxHOws/A12uw5TMg7lBAHA7sOKIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 113/132] drm/amd/display: Add null pointer check for get_first_active_display()
Date: Thu,  3 Jul 2025 16:43:22 +0200
Message-ID: <20250703143943.824815228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit c3e9826a22027a21d998d3e64882fa377b613006 upstream.

The function mod_hdcp_hdcp1_enable_encryption() calls the function
get_first_active_display(), but does not check its return value.
The return value is a null pointer if the display list is empty.
This will lead to a null pointer dereference in
mod_hdcp_hdcp2_enable_encryption().

Add a null pointer check for get_first_active_display() and return
MOD_HDCP_STATUS_DISPLAY_NOT_FOUND if the function return null.

Fixes: 2deade5ede56 ("drm/amd/display: Remove hdcp display state with mst fix")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # v5.8
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -368,6 +368,9 @@ enum mod_hdcp_status mod_hdcp_hdcp1_enab
 	struct mod_hdcp_display *display = get_first_active_display(hdcp);
 	enum mod_hdcp_status status = MOD_HDCP_STATUS_SUCCESS;
 
+	if (!display)
+		return MOD_HDCP_STATUS_DISPLAY_NOT_FOUND;
+
 	mutex_lock(&psp->hdcp_context.mutex);
 	hdcp_cmd = (struct ta_hdcp_shared_memory *)psp->hdcp_context.context.mem_context.shared_buf;
 	memset(hdcp_cmd, 0, sizeof(struct ta_hdcp_shared_memory));


