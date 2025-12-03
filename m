Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4470735BDDB;
	Wed,  3 Dec 2025 16:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779865; cv=none; b=jGMa7TCNWWeBSKwBXEbH4n6CAd3mKBuPkaIzEMnPitHBb9tzCEfCLoigcxlEKpz+ZnYUKOfWZEMjjRiEMotFMnBxeuYcwUOAh6XnEok34glK0vKl3IGTOsFYvJ0S3QNnMo3Dh3+4Ktd5jHeImWjD6L5CIWnRZIhlfdwPfeEEq+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779865; c=relaxed/simple;
	bh=DrRNDl2Qcrfbr96v1/A0sq8BxEgTMA56xYV5ITNMANQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c//bWCW2otrJv5ucfhi5QQ4D73rTfWRjUDq5fQZK9G+Xc2y7MKKm4k9gWtsfh5LdeQF3MMEukiSQiMCNANvj/W3Nlyr251JYOHgTe/uvXa7fLHGmbyBdiSr2WEgH3/Eek8uj25JOprvS3RCIwhzQ6/il841JydQIg8oB3KsFz/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0lFQtYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0lFQtYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E04C4CEF5;
	Wed,  3 Dec 2025 16:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779865;
	bh=DrRNDl2Qcrfbr96v1/A0sq8BxEgTMA56xYV5ITNMANQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0lFQtYDllFP3h12ACYBFT1N2PFDtfDaK/EtwozBVJjCtiKVCIC13Dy0zyAKDxNMO
	 dT4oCojmtn21+NyPrpNaQfx8NEzVIpIuLF7h+zioLmigyLV9XHc3qh8J62Zs2SrORA
	 l+rcI3DHTuTF90gWywlhnm9pl2E35yRkjBzfOKTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 384/568] drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE
Date: Wed,  3 Dec 2025 16:26:26 +0100
Message-ID: <20251203152454.758959021@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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
index 0d12d6af67c09..247ef293bf845 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3669,6 +3669,11 @@ static int vmw_cmd_check(struct vmw_private *dev_priv,
 
 
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



