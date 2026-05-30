Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C4932D42B;
	Sat, 30 May 2026 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160058; cv=none; b=QpswiH1t9fZnHfXdrb7z2jy8ugITrb8ldpwuZtGQabQY/mM5JfBLZNxm/cG1UWFpH3426fauk3aCne8ckhf8gBS7enIpsRtr6fR0tK1w0jwZmAsZXhKFYLuLh2zkpxhoTSr2xC8cn0ndJDTJkUtz/3FOZSaGl1jv9UyR+sYKIvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160058; c=relaxed/simple;
	bh=9xVsm3eT0Xk9tlBw9sc2OVazhuLtfa7t39UY7pwJYSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzBniG4qWEIpSEkY9Y6Sxkq7hBCzOvGgxP6Ipe8ffES2ZK/UJLsZSsH1lvp2P0FyhVMrz2eolqOirdxvO9Kxbpn8MP7/FpVj5vvJt/yAzzu9tD00BZLGZWImsKm2SnanAEb/WKBp/WMbiS+bSiIYHvN8C7AkOq32UT2gc9CECMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP8Ih9vx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP8Ih9vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3E21F00893;
	Sat, 30 May 2026 16:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160057;
	bh=FN8tF3vptSxc7JnXoNCfwyME4+xaeGAhrU9lPtnb4pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VP8Ih9vxMD+6GgLK8VBly1FzWKYgnW7NdTQc5amDIxvCXtv5/xQ+XevMKKRLGLBcp
	 1A6QSxXlXK5fxUrlCN/RIMxDbPhgdxdmqzAhiPMvIbKwDj77KI6u6ZQVWqhv9RZA3k
	 4gE08Y1BEq15P6SbNvAMOTIcYpQNq3EJh2expXsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 200/969] nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set
Date: Sat, 30 May 2026 17:55:24 +0200
Message-ID: <20260530160306.000266058@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Robert Beckett <bob.beckett@collabora.com>

commit 40f0496b617b431f8d2dd94d7f785c1121f8a68a upstream.

The NVM Command Set Identify Controller data may report a non-zero
Write Zeroes Size Limit (wzsl). When present, nvme_init_non_mdts_limits()
unconditionally overrides max_zeroes_sectors from wzsl, even if
NVME_QUIRK_DISABLE_WRITE_ZEROES previously set it to zero.

This effectively re-enables write zeroes for devices that need it
disabled, defeating the quirk. Several Kingston OM* drives rely on
this quirk to avoid firmware issues with write zeroes commands.

Check for the quirk before applying the wzsl override.

Fixes: 5befc7c26e5a ("nvme: implement non-mdts command limits")
Cc: stable@vger.kernel.org
Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
Assisted-by: claude-opus-4-6-v1
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3188,7 +3188,7 @@ static int nvme_init_non_mdts_limits(str
 	if (id->dmrl)
 		ctrl->max_discard_segments = id->dmrl;
 	ctrl->dmrsl = le32_to_cpu(id->dmrsl);
-	if (id->wzsl)
+	if (id->wzsl && !(ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
 		ctrl->max_zeroes_sectors = nvme_mps_to_sectors(ctrl, id->wzsl);
 
 free_data:


