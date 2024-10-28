Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BECB18E357;
	Mon, 28 Oct 2024 06:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096911; cv=none; b=D8rEtxuV/vpq2j8ME9yXcSx50VEf49omtu7GEeJZt8IET0sELT5x+6MB/b4oc0VslfwBEQ8POH4dtKvAlkLYeh1ugLfjH1J15SHAUmRZ5+h9d8iTJojDtAR+tvnCJkJRvmc3NYznYptQ3TUu0Aei8DQp0iWfMr/GKcIxHGfz5cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096911; c=relaxed/simple;
	bh=KFPi8Zmpmjwp692CLvc5tcOIGDDLe1RoKKkd3mQEyUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8wZynlCFxVtEuePAvgAPOgRVnZuVCI9Nql39awJ/g2a0N6sKLJltrPookLAOb2I7rotSq2dW1JLDBFHAva9DaPHFFHrUJSGhCI8e2oh0oD0+jQSEXeA5gUBHxWYIgEooxE4yJqpqj1Q/8Tsyj1K3JRW3VTcgSCcTlmiXkN001g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExMTBdDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExMTBdDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145FAC4CEC7;
	Mon, 28 Oct 2024 06:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096911;
	bh=KFPi8Zmpmjwp692CLvc5tcOIGDDLe1RoKKkd3mQEyUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExMTBdDd9ZRv/Pgizy2487V2/X5Sw0VjVno41CDTBKdksl+E2HE/17plzBOqr8q5S
	 agSlZ75/EQAZiONNo6GvAxQ/nBhEu8zmYmApw8uyLW1D/45mq9kAGK8eq5SWB5DQRc
	 4loiDVv27R8vgKo6e+bWeB+E1qyWnCBxg3a8tOKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 41/80] drm/vboxvideo: Replace fake VLA at end of vbva_mouse_pointer_shape with real VLA
Date: Mon, 28 Oct 2024 07:25:21 +0100
Message-ID: <20241028062253.761877036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d92b90f9a54d9300a6e883258e79f36dab53bfae ]

Replace the fake VLA at end of the vbva_mouse_pointer_shape shape with
a real VLA to fix a "memcpy: detected field-spanning write error" warning:

[   13.319813] memcpy: detected field-spanning write (size 16896) of single field "p->data" at drivers/gpu/drm/vboxvideo/hgsmi_base.c:154 (size 4)
[   13.319841] WARNING: CPU: 0 PID: 1105 at drivers/gpu/drm/vboxvideo/hgsmi_base.c:154 hgsmi_update_pointer_shape+0x192/0x1c0 [vboxvideo]
[   13.320038] Call Trace:
[   13.320173]  hgsmi_update_pointer_shape [vboxvideo]
[   13.320184]  vbox_cursor_atomic_update [vboxvideo]

Note as mentioned in the added comment it seems the original length
calculation for the allocated and send hgsmi buffer is 4 bytes too large.
Changing this is not the goal of this patch, so this behavior is kept.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240827104523.17442-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vboxvideo/hgsmi_base.c | 10 +++++++++-
 drivers/gpu/drm/vboxvideo/vboxvideo.h  |  4 +---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vboxvideo/hgsmi_base.c b/drivers/gpu/drm/vboxvideo/hgsmi_base.c
index 8c041d7ce4f1b..87dccaecc3e57 100644
--- a/drivers/gpu/drm/vboxvideo/hgsmi_base.c
+++ b/drivers/gpu/drm/vboxvideo/hgsmi_base.c
@@ -139,7 +139,15 @@ int hgsmi_update_pointer_shape(struct gen_pool *ctx, u32 flags,
 		flags |= VBOX_MOUSE_POINTER_VISIBLE;
 	}
 
-	p = hgsmi_buffer_alloc(ctx, sizeof(*p) + pixel_len, HGSMI_CH_VBVA,
+	/*
+	 * The 4 extra bytes come from switching struct vbva_mouse_pointer_shape
+	 * from having a 4 bytes fixed array at the end to using a proper VLA
+	 * at the end. These 4 extra bytes were not subtracted from sizeof(*p)
+	 * before the switch to the VLA, so this way the behavior is unchanged.
+	 * Chances are these 4 extra bytes are not necessary but they are kept
+	 * to avoid regressions.
+	 */
+	p = hgsmi_buffer_alloc(ctx, sizeof(*p) + pixel_len + 4, HGSMI_CH_VBVA,
 			       VBVA_MOUSE_POINTER_SHAPE);
 	if (!p)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/vboxvideo/vboxvideo.h b/drivers/gpu/drm/vboxvideo/vboxvideo.h
index a5de40fe1a76a..bed285fe083c8 100644
--- a/drivers/gpu/drm/vboxvideo/vboxvideo.h
+++ b/drivers/gpu/drm/vboxvideo/vboxvideo.h
@@ -351,10 +351,8 @@ struct vbva_mouse_pointer_shape {
 	 * Bytes in the gap between the AND and the XOR mask are undefined.
 	 * XOR mask scanlines have no gap between them and size of XOR mask is:
 	 * xor_len = width * 4 * height.
-	 *
-	 * Preallocate 4 bytes for accessing actual data as p->data.
 	 */
-	u8 data[4];
+	u8 data[];
 } __packed;
 
 /* pointer is visible */
-- 
2.43.0



