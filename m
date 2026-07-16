Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95E73D8127;
	Thu, 16 Jul 2026 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211034; cv=none; b=HLsMjFmdV2C+PgEAmCczBcT93GUWsU03GUxGHJegsOKejU5wF0mAD6GJ9h+04vTXoRCgkIf1M4D9QIkjCsJvq7uBfuh/KBzT9fqVsld/oVkmeicT53iv9NwuCLyVlgdL1zyIsUH+1dCaXQWbYaqElYs3F3DQgF11TWgfh1KclvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211034; c=relaxed/simple;
	bh=bi3iId1u+ZvQ3SxcSZrsni90X2+GjU4gu7G+apLHIVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP8Rzp3f4egdusk1/vhEcuhwein3KcY9aMDsS02AcGlXqGgqMVP7AFmD/jf07/sdg4MlPCp6+bZZve47UlyntnK+x6kyPIaOeE/sdeaeUvcrFrH613u/fSclJ5fqcrfA7sWJatSzGYiai3w2Qm3UxwL7Afc7YSCoTWoRWxROH5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I63GFMGZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I63GFMGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4451F000E9;
	Thu, 16 Jul 2026 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211033;
	bh=dXScIzTszRuZxUbdYBI45PkIJtUAEazcrmDxbs+hxWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I63GFMGZEADXspIUcQiarvrtYpWxHe3hRx8CNY0xqlNSwGwwewjwsKvogczL2h2Co
	 bEEJefJXhplsX2yIZ2umpIl7g07tkhUo9b5DryIq/VY+73WJrgUWOV94CqjMRb1YMn
	 u+3pzeRBl2srEmI0SIc80s0T8iA5fn2Fd81OnYto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 272/480] media: mtk-jpeg: cancel workqueue on release for supported platforms only
Date: Thu, 16 Jul 2026 15:30:19 +0200
Message-ID: <20260716133050.709323648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

commit b1845a227fda37b2fe5327df3ca0015d7e290235 upstream.

Since a recent fix the mtk_jpeg_release function cancels any pending
or running work present in the driver workqueue using
cancel_work_sync function.
Currently, only the multicore based variants use this workqueue and they
have the jpeg_worker platform data field initialized with a workqueue
callback function. For the others, this field value remain NULL by
default.
The cancel_work_sync function is unconditionally called in
mtk_jpeg_release function, even for the variants that do not use the
workqueue. This call generates a WARN_ON print in __flush_work because
the workqueue callback function presence check fails in __flush_work
function (used by cancel_work_sync).

So, to avoid these warnings, call cancel_work_sync only if a workqueue
callback is defined in platform data.

Fixes: 34c519feef3e ("media: mtk-jpeg: fix use-after-free in release path due to uncancelled work")
Cc: stable@vger.kernel.org
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c
@@ -1209,7 +1209,8 @@ static int mtk_jpeg_release(struct file
 	struct mtk_jpeg_dev *jpeg = video_drvdata(file);
 	struct mtk_jpeg_ctx *ctx = mtk_jpeg_file_to_ctx(file);
 
-	cancel_work_sync(&ctx->jpeg_work);
+	if (jpeg->variant->jpeg_worker)
+		cancel_work_sync(&ctx->jpeg_work);
 	mutex_lock(&jpeg->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);


