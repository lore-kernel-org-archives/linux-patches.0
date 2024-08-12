Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CB0134AC;
	Mon, 12 Aug 2024 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480097; cv=none; b=X0+gqblc995/mCoOqr2lzPaz7JSZfONIZmnuPCG/Yhf41xeDP79ubdlU4Gw2ssJihxq8x1oniKDOjSCb4U0yGezB/Yq7s8ZIGz766+fo5jMUnlXnen0sBo0hyGhHzvqu57bTwUOXp6CXFEkGdJle+4n/ZveIBGbFxT9lRCiIzBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480097; c=relaxed/simple;
	bh=P/Gl/FzYAA//A1RMqUViVpLeFZHf4r8lHIH/bKRgMpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=du6K93AYQ5/UsCQW2s3O0ZlOQt4Da+Yue3JtvQ7O1N4v/aCd31tapzSby9+K39TGfp6L/uuIboXhrVofOtbJhpJMJmyTxijUBfMQzsQ6ZXfJ7LXOdhZL0VHfpTmmqkgZM6wG6ATshliFAeLYFLEvgWvaB2SEMQC5tu3lkvEmqvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDwlLM1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDwlLM1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5E8C32782;
	Mon, 12 Aug 2024 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480097;
	bh=P/Gl/FzYAA//A1RMqUViVpLeFZHf4r8lHIH/bKRgMpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDwlLM1uQIdyuKRrl1VfhdLReBJHj/kBOLmNXDa/HRaFp4HqNKdvS4fAamryGIN/B
	 EI/KL4WmtfoyX6b0rDdyxmUoWy8nA1+5zy2kyyEWwinyoUZ+XGBh398kfkquLbYfr0
	 QpbZf5FwUciEXEauDfXRFGEzjTGEZUNPhEcivNc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 096/263] drm/admgpu: fix dereferencing null pointer context
Date: Mon, 12 Aug 2024 18:01:37 +0200
Message-ID: <20240812160150.219923851@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <jesse.zhang@amd.com>

[ Upstream commit 030ffd4d43b433bc6671d9ec34fc12c59220b95d ]

When user space sets an invalid ta type, the pointer context will be empty.
So it need to check the pointer context before using it

Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Suggested-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
index ca5c86e5f7cd6..8e8afbd237bcd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp_ta.c
@@ -334,7 +334,7 @@ static ssize_t ta_if_invoke_debugfs_write(struct file *fp, const char *buf, size
 
 	set_ta_context_funcs(psp, ta_type, &context);
 
-	if (!context->initialized) {
+	if (!context || !context->initialized) {
 		dev_err(adev->dev, "TA is not initialized\n");
 		ret = -EINVAL;
 		goto err_free_shared_buf;
-- 
2.43.0



