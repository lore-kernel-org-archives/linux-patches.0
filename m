Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DD6569F04;
	Wed,  9 Sep 2026 14:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962710; cv=none; b=SVdgRPMjB1I8Coq4lE0SxVDtem39++hA4Wye5hACfXuz0Crj+RvV9Rfi+uGhiuDWATnbAMKNoRspejo7XpXVYzV8/dwQ+XXn8iX+UjYO3DnGp3vrXS+RAYb8+gARj0q0Xnfu8p6JeRgUw4ElW6sh8GDBFUAbmqqb799joahLeIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962710; c=relaxed/simple;
	bh=NoqVJqQtV3MDu3JBiyX/6iWb2Az8EVnFP5eA6YaCSQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kr5csh0kMDDaOOZODC7Z8CwPSsfBkWiEEX7pQqejcghWKvXf/AjRzVxG09viyJg/17nHYZOyKYKP7qAJblg6swrHg7GqqkGHu5hRjSeL3ilQiAlMpkJo8/emvBPX8gjQ8Oc8XASm6fRO/CE/r9l+mSMnAaXwwAOP9502+63a+5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TImDX5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TImDX5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165441F00A3A;
	Wed,  9 Sep 2026 14:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962708;
	bh=R4leM6+mO21T6yPStyqocwEy43Jupi1UGoSG8Nv10Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TImDX5KTYZXi++0Ll+xXWQJS6zu36HUZcBbt45bhnEGnAFV9eVBsEm9VCa6LwBA1
	 VOa7qnigFOBV2XjiZIfGrsawA19eQg4YNvxmtsXlo8HM0XvPLEP4NYoawKY6mkR3Il
	 W0lE0fSDhArqkkQTib597DMrNY+DYSemi4TlJit0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 347/556] media: amphion: Remove obsolete frame_count check in venc_start_session
Date: Wed,  9 Sep 2026 15:40:27 +0200
Message-ID: <20260909134242.861415931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit 2be6ee86385badab95b1bace984735bde6e0fec0 upstream.

The dev_err() log warning about no input when starting was originally
meaningful when min_queued_buffers was set, as it indicated an abnormal
condition. However, since commit 5633ec763a2a ("media: amphion: Drop
min_queued_buffers assignment") removed the min_queued_buffers
assignment, having frame_count == 0 at start is a normal condition.

Remove this misleading log that no longer serves any purpose.

Fixes: 5633ec763a2a ("media: amphion: Drop min_queued_buffers assignment")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/amphion/venc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -973,8 +973,6 @@ static int venc_start_session(struct vpu
 	venc->ready_count = 0;
 	venc->stopped = false;
 	vpu_process_output_buffer(inst);
-	if (venc->frame_count == 0)
-		dev_err(inst->dev, "[%d] there is no input when starting\n", inst->id);
 
 	return 0;
 error:


