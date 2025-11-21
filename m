Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A713557E5;
	Fri, 21 Nov 2025 13:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733419; cv=none; b=P0KIBlnZMofnZ4QiMv6UPkdG5+dXjc5aLqGodLasEdFbneoLVLemofFsN1Uaq7Er2wVllST794iJbznhpJm8+Q12dAVQMYN4rQf99MWLNpha3fUBhdkdMJqGdAfA6+5AolqjPdAZQpwK896i4JjN/RUTSBswMqGztd9w3AwCq3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733419; c=relaxed/simple;
	bh=o0YrOdvBn09LuJqqLIfZNsZGgl6OzOVsldm/7hUUC70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcKTtF/30YvVLcJS0PAvQSya0R9e+Yd0MTUofcH6V1vyNF4rZbxb0dEyeaXIppE6A2A0LGWJOyd29KXfE9JJzTjVjllWVaax24JcMOr/sYDI8H1i+ZwEY7988x4xmJesq/xyVDRl9OiVM9+/R39ZhF+f1nijkLCKu8Eg6YZ/GQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOHzCKkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOHzCKkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53893C19423;
	Fri, 21 Nov 2025 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733418;
	bh=o0YrOdvBn09LuJqqLIfZNsZGgl6OzOVsldm/7hUUC70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOHzCKkf/orugjZAAztNDAF2th7CVwDQD9pjFwtVz2ln8AIbGVqNlW0aaVHW5c+27
	 WawTWL1EBpr9Zm/ybOn/SPJIH7DU917bqfWl7ZrieN+V1umv8gofB1wrVs5UI23vTG
	 fq3UuxlgDn2rpu2sQ8KylNvXZBQJu86fobQN0xRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 428/529] drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE
Date: Fri, 21 Nov 2025 14:12:07 +0100
Message-ID: <20251121130246.244025398@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b235e7cc41f3f..92b3e44d022fe 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3683,6 +3683,11 @@ static int vmw_cmd_check(struct vmw_private *dev_priv,
 
 
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



