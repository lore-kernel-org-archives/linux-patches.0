Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17471AAC4;
	Mon, 14 Oct 2024 14:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916060; cv=none; b=lO9HkjaxHmOUOn46ZxbO5imb/IqBwTQrLjrn/4V95+79K1km4OmIvoS5HE5JZai6Y7pg5EsvZoXKOCHkoExVOqrVxc3oS208gahCZ3idQaDSzr17S8OKK+GifjqfcbfJDGxyo1Kdhe4bIECMgPmQp+b1edOCEpAjKFtIYIK9Wgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916060; c=relaxed/simple;
	bh=fZZrT4RG4pALLKzsv4gM3SflNpEQYUL7Ef0RzU0MDW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LzxlU6YkRPnDDWWrsu6YEWQ7NGsi1h/B181IvkhkrdekWaDnLETaGNxLbirNI5TF2rr0cwo4EHCg479cX9CO0lr3FmdgmIQPDhGHCQ9YOmv5SszrXTP7tqkjG9ZxtifQF8hrYyNOT+ncuw6P2jHTIlrWVdtampF2TwRMsZETAoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XufvMeVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XufvMeVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B243C4CECF;
	Mon, 14 Oct 2024 14:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916060;
	bh=fZZrT4RG4pALLKzsv4gM3SflNpEQYUL7Ef0RzU0MDW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XufvMeVDbpYdtGjDDE2x7XA4kDlOWvF6U5sLI6kvcveufXfOeGzoav/m0iVuqHl9u
	 GUhrhUlB4fIRm71OhGcpo96hFXnOEkG1dm4G5L9MjQYXLVA7Jc97nHVO4gzn4zUT3V
	 V+jytwSekRjD+7wIsgROqeXlAyHM/bAFob87HADY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	=?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 075/214] drm/xe/oa: Fix overflow in oa batch buffer
Date: Mon, 14 Oct 2024 16:18:58 +0200
Message-ID: <20241014141047.914500829@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Roberto de Souza <jose.souza@intel.com>

[ Upstream commit 6c10ba06bb1b48acce6d4d9c1e33beb9954f1788 ]

By default xe_bb_create_job() appends a MI_BATCH_BUFFER_END to batch
buffer, this is not a problem if batch buffer is only used once but
oa reuses the batch buffer for the same metric and at each call
it appends a MI_BATCH_BUFFER_END, printing the warning below and then
overflowing.

[  381.072016] ------------[ cut here ]------------
[  381.072019] xe 0000:00:02.0: [drm] Assertion `bb->len * 4 + bb_prefetch(q->gt) <= size` failed!
               platform: LUNARLAKE subplatform: 1
               graphics: Xe2_LPG / Xe2_HPG 20.04 step B0
               media: Xe2_LPM / Xe2_HPM 20.00 step B0
               tile: 0 VRAM 0 B
               GT: 0 type 1

So here checking if batch buffer already have MI_BATCH_BUFFER_END if
not append it.

v2:
- simply fix, suggestion from Ashutosh

Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240912153842.35813-1-jose.souza@intel.com
(cherry picked from commit 9ba0e0f30ca42a98af3689460063edfb6315718a)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_bb.c b/drivers/gpu/drm/xe/xe_bb.c
index a13e0b3a169ed..ef777dbdf4ecc 100644
--- a/drivers/gpu/drm/xe/xe_bb.c
+++ b/drivers/gpu/drm/xe/xe_bb.c
@@ -65,7 +65,8 @@ __xe_bb_create_job(struct xe_exec_queue *q, struct xe_bb *bb, u64 *addr)
 {
 	u32 size = drm_suballoc_size(bb->bo);
 
-	bb->cs[bb->len++] = MI_BATCH_BUFFER_END;
+	if (bb->len == 0 || bb->cs[bb->len - 1] != MI_BATCH_BUFFER_END)
+		bb->cs[bb->len++] = MI_BATCH_BUFFER_END;
 
 	xe_gt_assert(q->gt, bb->len * 4 + bb_prefetch(q->gt) <= size);
 
-- 
2.43.0



