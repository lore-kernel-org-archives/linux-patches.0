Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7012D2398;
	Mon, 27 Oct 2025 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592255; cv=none; b=TQdWt5chi1BrvG4eYQBXN9r/5U4tHw2lDwZFIBD7IwuspZrPcquHrrqs6ndrBK6d9Vx7SZYFShv2WVWJ8jR3hnss1w0Kp5beAesew11cSQvufiPFPgreYMd/rKqOqN4heOC334Qge/ohQXEhGaHLKEiNerBtLAVXF5S8mLNGeJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592255; c=relaxed/simple;
	bh=ow99g91JJMNSSZ6BW2i70o9r0dxSwx8TfuJTGT1ZTOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dT5+xrHusZazTNQxUCvVpWvfcI7ZXxK4THsdxC90+4SiJa6z4y8j8zqr5OKmbcjcC8owt+Do8tPPYbTXuEdBzLMLlojvL9vhMQCAh/jwAuKIDU8Iw3nJKgWoTmvRfPlPAO2CNySuFX3LXBbOkySu1YaBbH9lotnsnsPAqhmHBJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMOMA1lC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMOMA1lC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B81C4CEF1;
	Mon, 27 Oct 2025 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592255;
	bh=ow99g91JJMNSSZ6BW2i70o9r0dxSwx8TfuJTGT1ZTOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMOMA1lCXQ7Jw++vzTvIBbJn+iB1AjA4R+x4tB8az0H8fG2MKqNLYuE23xQA17NOz
	 6JIyrKpmPsKMAlONyb2cWUOe+EQu54n/PCQ+DufhexlEoNdwKZK93AkLkSZWvND/Oh
	 uMQklJV4RlzSsIh2eRSiD/jHYNwt75i+ZSDNl7WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Adrian Yip <adrian.ytw@gmail.com>
Subject: [PATCH 6.1 010/157] drm/amd: Check whether secure display TA loaded successfully
Date: Mon, 27 Oct 2025 19:34:31 +0100
Message-ID: <20251027183501.527018614@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit c760bcda83571e07b72c10d9da175db5051ed971 upstream.

[Why]
Not all renoir hardware supports secure display.  If the TA is present
but the feature isn't supported it will fail to load or send commands.
This shows ERR messages to the user that make it seems like there is
a problem.

[How]
Check the resp_status of the context to see if there was an error
before trying to send any secure display commands.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/1415
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Adrian Yip <adrian.ytw@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -1959,7 +1959,7 @@ static int psp_securedisplay_initialize(
 	}
 
 	ret = psp_ta_load(psp, &psp->securedisplay_context.context);
-	if (!ret) {
+	if (!ret && !psp->securedisplay_context.context.resp_status) {
 		psp->securedisplay_context.context.initialized = true;
 		mutex_init(&psp->securedisplay_context.mutex);
 	} else


