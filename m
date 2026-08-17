Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2023F88B9;
	Mon, 17 Aug 2026 14:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976229; cv=none; b=V7UMbhj69O6fHZfCGRbegewNpJK7J2ogi7sNZdtP47kXGkKtX6/ktldChFW55FNRZZLDKw85CSQxBGs+papASQW2nilw7k0zKy0AxB5SF9a+ifTv0WSC2+Hs0IG4mKxFxxxIdC6BQGLZATMBNDguJCAcpMEHQFkgYWLpqoXngsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976229; c=relaxed/simple;
	bh=vRwS251jJvWDU880Qq9Ceu6V2A1xsZO5yjYO0cbeOKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZUjcXOM98O7v/9+mlWhnu5c8x+IbIgegtS2G1SlgvgUk9gmYFZQvyGknw1B3lErCKu428+81Cc4hF6JhkBdauGvpTlcR2WGPSlgnDL8Vc2Yka3CDupet8PelDmw1UGP3Gs/epd/k8RkzhmXYXP2qevWfFLBwIJzxN4u3Lpf9oX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPBpn/+7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPBpn/+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FA41F000E9;
	Mon, 17 Aug 2026 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976227;
	bh=ggEM1+wluaZ0I/NZEXsXRuW/WtZr7MFAKpjC4Kn4omQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPBpn/+7RkhkuZHNWMILHYvnfqE9ugw/ML0p9vmHUzVRqex9Yb2u4YGVdWNDrfOZO
	 mn0b2nAXo51xJZp4MuZh9VO6rdGvsHpQa+PvMtebV23/+8IfuciTVQa6gozU3fgvKL
	 9IbHQ/6XUciu5n/2yJEfYdzHb+to9OsTuaCNPiFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 5.10 301/389] drm/vmwgfx: bound DMA command body size against suffix pointer
Date: Mon, 17 Aug 2026 15:32:20 +0200
Message-ID: <20260817132550.793337459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit f4f1db96bfd68b81053693ba53405b6f510ac16c upstream.

vmw_cmd_dma() locates the DMA suffix at

	(unsigned long) &cmd->body + header->size - sizeof(*suffix)

without checking that header->size is large enough to contain both
cmd->body and the suffix.  An undersized header makes the suffix
pointer underflow back into the previous command in the bounce
buffer.  The verifier later writes suffix->maximumOffset, clobbering
verified fields of an already-relocated earlier command -- a TOCTOU
on the device-visible command stream that lets one command rewrite
another's GMR id, surface id, or other authenticated fields.

Reject the command if the body is too small for the suffix to fit.

Fixes: 4e4ddd477743 ("drm/vmwgfx: Fix queries if no dma buffer thrashing is occuring.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-8-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1529,6 +1529,12 @@ static int vmw_cmd_dma(struct vmw_privat
 	bool dirty;
 
 	cmd = container_of(header, typeof(*cmd), header);
+
+	if (unlikely(header->size < sizeof(cmd->body) + sizeof(*suffix))) {
+		VMW_DEBUG_USER("Illegal SVGA_3D_CMD_SURFACE_DMA size.\n");
+		return -EINVAL;
+	}
+
 	suffix = (SVGA3dCmdSurfaceDMASuffix *)((unsigned long) &cmd->body +
 					       header->size - sizeof(*suffix));
 


