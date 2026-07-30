Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4BE33438F;
	Thu, 30 Jul 2026 15:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426190; cv=none; b=q5UezKZT5y4zKnQi89fNARkGuIyJwf8oHFldB8xnNZbp0uISZbwtLp2z9pFifdwmtw+F9W7jNCL4o1B10Bddo4ETyViphUwwYnmWv1a2sHcSa4nB2TjiPGvZExugUXxsSZ2CHtTQulSPB1gYAxUMjWcX3VJ/xAZXIAdzD2XAI0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426190; c=relaxed/simple;
	bh=GuoHoHdePvfDF0nBI3omGGkUDwuycPPF7s+c8Mvgx5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=na6vOXp4bvyRLiop9NNqPV5Q4MFVINKoYRChCe5Spf4zmrassMNgyyXytAFn9ze3tAFz9uW2RECBBkG89NpCvkHeLNaVsI5uUK9w7OdWIjpfSueoL0RCgZd/bFg9iQDnCAYnzjpcKyfausgSsY0cgUQBWGxrxDwNab5ibZclxjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifPnYDh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifPnYDh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B2F1F000E9;
	Thu, 30 Jul 2026 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426189;
	bh=/U91BKg8FnOsdd7cuBjCTMpwx7yT8uKEcS2wEph3Eck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifPnYDh8w2TPJVMqNpwus9OAoHdDnkLDQMJAS2hS71Kj43m+nXeObv4y4XkI+FQA9
	 l08xGziYdidnemgVtNEgyUxkoJzBYAYzSlZW7z22NKMJt/SrQmmEIMDL5RcvVIgyvC
	 FaSGSYrNlvKluFt1eQCSiXh4zBZgAs1LrlXSFKbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.12 278/602] drm/virtio: bound EDID block reads to the response buffer
Date: Thu, 30 Jul 2026 16:11:10 +0200
Message-ID: <20260730141441.814511238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 4e1a53892ba7f8a3e1da6bfc53c83ae7c812dccd upstream.

virtio_get_edid_block() validates the read offset only against the
device-supplied resp->size field, never against the fixed-size resp->edid
array. The EDID block index is driven by the device-supplied extension
count, so a malicious virtio-gpu backend can advertise a large size
together with a high block count and read far past the array into adjacent
kernel memory, which is then surfaced in the parsed EDID (an out-of-bounds
read / info leak).

Also reject any read whose end exceeds the size of the edid array.
Conforming EDID responses stay within the array and are unaffected.

Fixes: b4b01b4995fb ("drm/virtio: add edid support")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Link: https://patch.msgid.link/20260620-b4-disp-22bba7bf-v1-1-b95924cee742@proton.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -723,7 +723,8 @@ static int virtio_get_edid_block(void *d
 	struct virtio_gpu_resp_edid *resp = data;
 	size_t start = block * EDID_LENGTH;
 
-	if (start + len > le32_to_cpu(resp->size))
+	if (start + len > le32_to_cpu(resp->size) ||
+	    start + len > sizeof(resp->edid))
 		return -EINVAL;
 	memcpy(buf, resp->edid + start, len);
 	return 0;


