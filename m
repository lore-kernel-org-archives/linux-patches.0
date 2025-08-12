Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AB6305E08;
	Tue, 12 Aug 2025 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022168; cv=none; b=sPOLrWb7lAHTW/rRs1ayXE1K7i2Z4nmS2EfU7x0VKJ7ozNXoygI7GMWwypNRl/5m8FpOBz4vDu+vXU4uNhD/sMG4eW1Df+OodIWdF0I+5OxG0xI0WmmLeU3L7EU1uxe9uaUkQxvNn4vFu/V/S4OPkpCq55HpwwvEVsr64w/Vzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022168; c=relaxed/simple;
	bh=lUdhMejhLIlVurUYQ8SOtv/tDBBPjDrmcdJhKHz0FmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/H2zHmszNvzzJVaGjSHdfNKXhCiDpBeK3jbgoc8zoYPswI0Lv/30Dh9jWoG5QZG5NtSJRerBtoLIPi3553dQMMma6I30EUie8kQ97BjRgE4UHL8IKprURTqBgnfI8lVnor0MswGU3gyHvGYVRElw07UmhyaPSz9hrgExxbaQv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXkeGb+/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXkeGb+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E19C4CEF0;
	Tue, 12 Aug 2025 18:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022168;
	bh=lUdhMejhLIlVurUYQ8SOtv/tDBBPjDrmcdJhKHz0FmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXkeGb+/4owvhaFSTiic4RJlZILLWmTgEokvYJgrrOO9Xpe84SX4J+1+ehv2lBfOE
	 8A2lpPX97263JlNRCHJ3fz3gYE9yWHmHwb1330hSQplm3FFjKhMmkGVl6hn95Qkrkw
	 QQzmBDp+bHMIdfB6XI/14fpnXEX241aKHWDcWr1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/369] drm/vmwgfx: Fix Host-Backed userspace on Guest-Backed kernel
Date: Tue, 12 Aug 2025 19:26:13 +0200
Message-ID: <20250812173017.643812770@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 7872997c048e989c7689c2995d230fdca7798000 ]

Running 3D applications with SVGA_FORCE_HOST_BACKED=1 or using an
ancient version of mesa was broken because the buffer was pinned in
VMW_BO_DOMAIN_SYS and could not be moved to VMW_BO_DOMAIN_MOB during
validation.

The compat_shader buffer should not pinned.

Fixes: 668b206601c5 ("drm/vmwgfx: Stop using raw ttm_buffer_object's")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Maaz Mombasawala <maaz.mombasawala@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://lore.kernel.org/r/20250429203427.1742331-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_shader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
index 7fb1c88bcc47..69dfe69ce0f8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -896,7 +896,7 @@ int vmw_compat_shader_add(struct vmw_private *dev_priv,
 		.busy_domain = VMW_BO_DOMAIN_SYS,
 		.bo_type = ttm_bo_type_device,
 		.size = size,
-		.pin = true,
+		.pin = false,
 		.keep_resv = true,
 	};
 
-- 
2.39.5



