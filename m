Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6719826F47B;
	Tue, 25 Mar 2025 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906386; cv=none; b=qqVSjtok1CXu7My8GmKsGENggWQj6l1wTURvR50U+0rzgMZDO48+Ige/T/mEpZDCrlrOTclAYtpUivVLY1/U55LQgIjSkeYLjSruo9UCSeCQSJYv5UtMXaeFO11Bp3MrbYZ1PJviy0PLbNDguOCcEFNqCh/pJe0wELeM+VgkHCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906386; c=relaxed/simple;
	bh=hUJ9auzYKi1edkfNgOyqrIjUytJhKVU9NlIFrqRG+k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrFjNvsSl2AB7l3U4td7lrmfa4wZTIy0NN0dFRVTrANQ+PxDcnY3JjvbfqUIiy0gFFcZLUyc4oUn60YGxjaNusJGrqlB4+ZroNQAHLLObTDOJPR57QTwS6PgKD+uJ+JSoIpahOt9AjnyvVc4Pil02qe+pfjpXEPYLqsSj6bKBIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxoV6HTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxoV6HTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5058C4CEE4;
	Tue, 25 Mar 2025 12:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906385;
	bh=hUJ9auzYKi1edkfNgOyqrIjUytJhKVU9NlIFrqRG+k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxoV6HTf0rEAxb2galCl++uckcZ42jXF/+jmxy8+FNW/fqIFSO0rJp0Xde4WTw69p
	 T6Yht+sH27on4Dyr7dx2cWT6vrAOjNZ0wvMmwpXomZe8JLPzU9Pq/t425iwXigD4H7
	 uuR1f0F8YqydHg3KqLh6ChMANwXGxfY7zNW0swl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 089/116] drm/radeon: fix uninitialized size issue in radeon_vce_cs_parse()
Date: Tue, 25 Mar 2025 08:22:56 -0400
Message-ID: <20250325122151.485296006@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit dd8689b52a24807c2d5ce0a17cb26dc87f75235c upstream.

On the off chance that command stream passed from userspace via
ioctl() call to radeon_vce_cs_parse() is weirdly crafted and
first command to execute is to encode (case 0x03000001), the function
in question will attempt to call radeon_vce_cs_reloc() with size
argument that has not been properly initialized. Specifically, 'size'
will point to 'tmp' variable before the latter had a chance to be
assigned any value.

Play it safe and init 'tmp' with 0, thus ensuring that
radeon_vce_cs_reloc() will catch an early error in cases like these.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 2fc5703abda2 ("drm/radeon: check VCE relocation buffer range v3")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 2d52de55f9ee7aaee0e09ac443f77855989c6b68)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_vce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_vce.c
+++ b/drivers/gpu/drm/radeon/radeon_vce.c
@@ -557,7 +557,7 @@ int radeon_vce_cs_parse(struct radeon_cs
 {
 	int session_idx = -1;
 	bool destroyed = false, created = false, allocated = false;
-	uint32_t tmp, handle = 0;
+	uint32_t tmp = 0, handle = 0;
 	uint32_t *size = &tmp;
 	int i, r = 0;
 


