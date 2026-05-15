Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E062E305663;
	Fri, 15 May 2026 15:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860710; cv=none; b=Znqza0AIMPYxMXO6Z2J+wzqa6LoLVe+Wuoau1ca3hHMc5G4dWy5VMbzASgx6uwOjcpm0xxtgyHoEYzTAUOWOd2NdrxAhjiofHlH1GYYm5FgoXY7DQx0NuhAng1U1+gYhuQGkOB4sX8GN5tn3VArG2FSkFgklEHZM+S9W6J1RrdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860710; c=relaxed/simple;
	bh=PnD4Ylu+LD/aPAMg8CbrAm2BLawm/9sXNJ7hO6ZJ09Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0xKJktLbkDKqPjohx+TuPwpVtoy37FW1RLjrqQY+i3eh8n6ZGnGGcGFCBEtaEx0ud3mrzl76wCFSLE3i4DfyHVCInKD5WOSKv3VMZhkW0v63dVkRpR09mHXxXtUFFOq2CsVbfsU9TOZ5qfY3BVbxABQHclEG0W9P/A+oMmInSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDkb2U3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDkb2U3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7637BC2BCB0;
	Fri, 15 May 2026 15:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860709;
	bh=PnD4Ylu+LD/aPAMg8CbrAm2BLawm/9sXNJ7hO6ZJ09Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDkb2U3GYD/JayIFK8GXFpgiLbBg4Nrn2CCisykioPKnnJbX/+XcQKFzlNo67dUq8
	 5wg5bQXpXLmzxAyU1e7fiCgvrdSvBsJOzgKoM+OIfFAYApnzXXjz/l4Og2Q3stJNUx
	 qXPUPwtGe+BQpz7+tq6AMsrp6t+wjuV1TachoudU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Beckett <bob.beckett@collabora.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 049/474] nvme: respect NVME_QUIRK_DISABLE_WRITE_ZEROES when wzsl is set
Date: Fri, 15 May 2026 17:42:38 +0200
Message-ID: <20260515154716.107881326@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -2943,7 +2943,7 @@ static int nvme_init_non_mdts_limits(str
 	if (id->dmrl)
 		ctrl->max_discard_segments = id->dmrl;
 	ctrl->dmrsl = le32_to_cpu(id->dmrsl);
-	if (id->wzsl)
+	if (id->wzsl && !(ctrl->quirks & NVME_QUIRK_DISABLE_WRITE_ZEROES))
 		ctrl->max_zeroes_sectors = nvme_mps_to_sectors(ctrl, id->wzsl);
 
 free_data:


