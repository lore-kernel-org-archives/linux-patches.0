Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5D92FFDD3;
	Tue, 12 Aug 2025 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025680; cv=none; b=uZONmDhsS7122j/eKfDp6tjHGFaWYdiFgR+5RLc0WN7x8M4ARNX943fkYEEAQk4XsG9tVfNNem6Ls5PxPCSq45cOcoEjVyCSHFB+vnQVdvnD7SpdLWfECPhlwUDdijQT0HJqNpqGy5tPlUS/HmvG7QEnU2GJQlXzJpRqkY+fdX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025680; c=relaxed/simple;
	bh=LUrh22W0jwm0cStNtJXRTVgW7RzNxNB2VhCBGFzJ6ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ULR1B9MfVNlPJfCmjjIUv7JbonnaRaoo0zqZ/bBGOL1Ph8t9e/UbsHzmTTVumg6NhypH7a+dQNkrcHvsXbuA1WPkNx+eHSaJG/Zjk6zZcIBIOhRUjyJEh4bNFxsWxj4d+b/9n30Dul/KOGUYu/KXkCoJIdczMs3hFaG2I6D+Fg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emZjEHAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emZjEHAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF760C4CEF6;
	Tue, 12 Aug 2025 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025680;
	bh=LUrh22W0jwm0cStNtJXRTVgW7RzNxNB2VhCBGFzJ6ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emZjEHAf0uFbwBSe0gz4AkwGCrbah2ptKu4tWMi333/vcKn3oMVYzFy9DL97aiaPU
	 erE6txkOFb9hU608PyHkt4hHk1XIRbWR95LZYuOgx96gkM9mo4hbsFWfBuygcvEZUA
	 0Gjhtyrd9CY0BKHpbrHK/C6yQToUjMVY+C7mK2Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Forbes <ian.forbes@broadcom.com>,
	Maaz Mombasawala <maaz.mombasawala@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 111/480] drm/vmwgfx: Fix Host-Backed userspace on Guest-Backed kernel
Date: Tue, 12 Aug 2025 19:45:19 +0200
Message-ID: <20250812174402.067322900@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



