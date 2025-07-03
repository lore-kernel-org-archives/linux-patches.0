Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154CA2D6639;
	Thu,  3 Jul 2025 15:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555789; cv=none; b=gnZzB0nieM8VfYiMAoEIfDLZmJpuS/utNuk8wuZV73zf+MVUfFR0Ax6VYWoE7Z2JeWm61VwkJF2oLMZivThSq9mgtEtomc3rTmYmzoPAjpbUduRcCy+tXiybKd2AAYvb4fdLhIef7hSIIRerKz56H0aF8fVQh/Y7YC70e5D1RZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555789; c=relaxed/simple;
	bh=2sdy/QDlQ4bKAnlHmhRps/lpFGsugFJ01y4AxvlBbeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O32WL52Xaohm4HWE4J/mTZcsCDyeHurCLXclgj9hWo8ExJFXwyGCE5wZwy7Mvu2b0rIcbePb/II/K1LPaBZnH96fC4KMqUfTPSToDcjm7sPuOBCVvye7K1BJLAm6/GP3YbCsnklm6hxKcgnmGJZJ4EYPVXXKiKObblwROL3V3m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fi+E5gvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fi+E5gvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79921C4CEE3;
	Thu,  3 Jul 2025 15:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555789;
	bh=2sdy/QDlQ4bKAnlHmhRps/lpFGsugFJ01y4AxvlBbeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fi+E5gvUtXAGXEpndMJ8Br0Sgq7KIVxtLA3ubtWQPSQY3XlyGXXCvVHDq2IjaYMnI
	 iOeumJIQWj+U29Z8RQWcLYZOJ223MbYrNlH6gOwyhWbifb5JnVxytG6eXeBE5ifrY2
	 UWl4BVMWRfBtZAIp78qs7p5vitxw0NH6KRCJ/sXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 122/139] drm/amd/display: Add null pointer check for get_first_active_display()
Date: Thu,  3 Jul 2025 16:43:05 +0200
Message-ID: <20250703143945.954586951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


