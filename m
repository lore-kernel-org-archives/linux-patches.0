Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241D62F3632;
	Fri, 21 Nov 2025 13:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731130; cv=none; b=CsQLkAZE+mDkEFRD3cGKp9la9g0QYKx2gY7p50Il+s0Zd1xmkN4VxOproKaoMjuBDuLiqqOIHqx3L38R8G9tZt8ZEGyWOwPyu157stvEDuTQa+JqvpsUOQsVe+unHUPgwiu923kCLsYTO+C5Amd/JkfAmM103U9mueq9x91gpRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731130; c=relaxed/simple;
	bh=b7x29O0LJCLaIHTQgJ1AqtFMJm7a1z1rDhaFSHr+HYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cthlWmA+6DI7jrPADq9nj5Bze0YheskXYMZPylPJKcCPBCVh4cdtLjCeS0JfLJ9VW8872z+sSPATVIZtcZk7hNr+pYkrmsUzkWR2bD9ZiC4/um/M0Uq2VtKv3UqKT8wUJg+TbePTSxfwr98FBoFKW0kLusm092EnW58S+2PCpak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRiMUDCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRiMUDCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0BCC4CEF1;
	Fri, 21 Nov 2025 13:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731130;
	bh=b7x29O0LJCLaIHTQgJ1AqtFMJm7a1z1rDhaFSHr+HYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRiMUDCqRaxkG5Fd3A15mimhvk4X57VQ5elTqBtZZB6Z8EFNcHOqjVbwVKOvWD7Ab
	 7vz1NnPq2T/MTgs1NQI/b88CjhUaJK3jW8ebazswD0fZ1OhfzGlwglUTqs2KB+Q5K4
	 XfyLsJ+K9O4+K4tyMyEUuJ97nr9gQU6TSC0g045s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohit Keshri <rkeshri@redhat.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 100/247] drm/vmwgfx: Validate command header size against SVGA_CMD_MAX_DATASIZE
Date: Fri, 21 Nov 2025 14:10:47 +0100
Message-ID: <20251121130158.179174253@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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
index d539f25b5fbe0..3057f8baa7d25 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -3668,6 +3668,11 @@ static int vmw_cmd_check(struct vmw_private *dev_priv,
 
 
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



