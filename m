Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0188526B756;
	Wed,  3 Dec 2025 16:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778160; cv=none; b=S9m7seDtzoCISe4dGgtwdyeto/QcN3YvvbGycGNRBWrufRUbz6yMDI7pog3QcKamGJt9xlF+aM3ciD6zUxdJYUCPv2FC/qccT1VDzegiIUMlJtPYJU/XR1MRzNydajVXs0ewaXUrDugjOVD3qqEPyRl2HJ2qilMwskK6uivSmx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778160; c=relaxed/simple;
	bh=MsxDUDxKxcRfoMJbs8RSTlfok9jjziOn6OtLPWlIpIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3B86d/Kl66drN2hRF3EkA21xcHsWn8hfW+69tX7FDfai9i7EmFb+Lo9gV/SELOPtbWmp9kkMGWXSLmyVQxUfLhpsoppsBXFqlSEhNhHy2ETR4/Z2SvJrrOoX3qTyeVXKgKKosHY3z5iXZbc9aH7mg2ji9D/MYrM598TpynYaL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0ue6Tuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0ue6Tuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF691C4CEF5;
	Wed,  3 Dec 2025 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778159;
	bh=MsxDUDxKxcRfoMJbs8RSTlfok9jjziOn6OtLPWlIpIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M0ue6TuqhEFMBNtF00Tav7pBnaxA06FmLrKOvXc3dkRQajgOcRMI6plEyv4zpIXSp
	 ChVV0BrLaMBhEiFvXy2DAurZQ9HiHF+oBRj3MPaHj5fIMnX6vRtHpy/O2wVqn/M+mx
	 2dhEQguZ5UMJJ2eaxVFwg9kD8oqBJl+ysIOM3ncM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/392] drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE
Date: Wed,  3 Dec 2025 16:26:51 +0100
Message-ID: <20251203152423.771956247@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 32b415a9dc2c212e809b7ebc2b14bc3fbda2b9af ]

This data originates from userspace and is used in buffer offset
calculations which could potentially overflow causing an out-of-bounds
access.

Fixes: 8ce75f8ab904 ("drm/vmwgfx: Update device includes for DX device functionality")
Reported-by: Rohit Keshri <rkeshri@redhat.com>
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20251021190128.13014-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 7dd42c5a7fd62..fd7d6987f9134 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3627,6 +3627,11 @@ static int vmw_cmd_check(struct vmw_private *dev_priv,
 
 
 	cmd_id = header->id;
+	if (header->size > SVGA_CMD_MAX_DATASIZE) {
+		VMW_DEBUG_USER("SVGA3D command: %d is too big.\n",
+			       cmd_id + SVGA_3D_CMD_BASE);
+		return -E2BIG;
+	}
 	*size = header->size + sizeof(SVGA3dCmdHeader);
 
 	cmd_id -= SVGA_3D_CMD_BASE;
-- 
2.51.0



