Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8ABB25A355;
	Tue, 21 Oct 2025 20:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077390; cv=none; b=hIC7KPPPTWTQNHy3JmTkVhieGNnqlDxLIWw9iONcgfv/2c6wI2GO7sftSHKjlnRM6Mc1dCgMHUJd2CHCVErUj9AkqmOqNtOwrfdSfA/X19RY+k7tHvQyvuXtxNhSGydmySlPC6hXp1ch9uJUjIojlAHqiC03HGUuXt3yc3JwB4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077390; c=relaxed/simple;
	bh=Yo2mzVcgwMBDzLwEq0xs4bah31PoOlbTFWZoEKpP2Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9MJQ3Wus0aigUWCAFmnwIDgU3PWWEu/owUX69A3bYGRo6nmP3tvNiEJk/Zp/tzKDW7s5BYuzFxavi3ycJ7ZFo3Z0bDXtjrZFz4Yt7O+t9NdomIBETerNBKeN/aEU7Iu01714BbT6jUDlWTYd5Z+okhO7QQ1nsogeHa/UOGmVwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxQQsedt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxQQsedt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6851BC4CEF1;
	Tue, 21 Oct 2025 20:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077389;
	bh=Yo2mzVcgwMBDzLwEq0xs4bah31PoOlbTFWZoEKpP2Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxQQsedtxATBBC1eUHejTpkRM4sEsjHx8r1Xx9TZ9MJJQMtOURflWxLvy2VU2pqTU
	 U2EBkEEWJ0V1823ZF+g32NyUAjFFGM/ZVzaAFaJ73u8gDAc7PeeGDs4TN0a3zN7CYZ
	 rbgVQEmq/vlGGSlIJ3sxF6f/EF5pVhtUSxS4JXnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Adrian Yip <adrian.ytw@gmail.com>
Subject: [PATCH 6.17 047/159] drm/amd: Check whether secure display TA loaded successfully
Date: Tue, 21 Oct 2025 21:50:24 +0200
Message-ID: <20251021195044.339275661@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2350,7 +2350,7 @@ static int psp_securedisplay_initialize(
 	}
 
 	ret = psp_ta_load(psp, &psp->securedisplay_context.context);
-	if (!ret) {
+	if (!ret && !psp->securedisplay_context.context.resp_status) {
 		psp->securedisplay_context.context.initialized = true;
 		mutex_init(&psp->securedisplay_context.mutex);
 	} else


