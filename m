Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F6F282F29;
	Mon, 17 Aug 2026 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979298; cv=none; b=ENgPoX5GNTC2gXNeLdx7K3gpMVftlEc99GTxkr/W6okG6THb0tyexBnegK3gTQbk0L0rZdpVzLhi+zVRwBD1gy3NpRyxF3YKqTMLBb3a9iAfofuT3r+1Xl6rHKVr/cQA/ZH/8vhiaM2HN7oOU/UW9slSYiZujPPCtuhjgQmJ0KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979298; c=relaxed/simple;
	bh=FFOBw9UhQySL7fFWi6baLQBGCdLq3Br5kvVFvxgOUtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4wzgzFjSnW0TMAORVeNkTvC6JsjxcZMLMKcq2NpzUQTmbluGk0iWeeXug/q2VGeCjoRGAWt5ocrGJB/G431Rc5a3wLYfrGeD6eCgNYmiE335gmRqhtgxXLmDc/J198yX5QHU30e9C3fWtac6ox7tkxpicr7o3ZE1Fgd5rgQZQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLgN5gVA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLgN5gVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329AC1F00A3A;
	Mon, 17 Aug 2026 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979297;
	bh=py5tJ4QDJdU1jtEfxi5VYgi3GT/9/BIJqOb/Oftvv+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLgN5gVAlajV4+7W9lAVss7vwsPMh58BH1dSbJTKnixPuMdA01hV/Ww2SHkCykvI7
	 +0p9+mPewiVMKr2oVa9kC8kTwmeZgM5MJlksPvBDP9tHRIpqVOKQB6CRrmSefMoHzi
	 UK1rvRPIMwTBa56ReyQyflo/eqO8r8BlJh0g1EO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.1 177/609] drm/virtio: bound EDID block reads to the response buffer
Date: Mon, 17 Aug 2026 15:27:53 +0200
Message-ID: <20260817132549.992624357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -719,7 +719,8 @@ static int virtio_get_edid_block(void *d
 	struct virtio_gpu_resp_edid *resp = data;
 	size_t start = block * EDID_LENGTH;
 
-	if (start + len > le32_to_cpu(resp->size))
+	if (start + len > le32_to_cpu(resp->size) ||
+	    start + len > sizeof(resp->edid))
 		return -EINVAL;
 	memcpy(buf, resp->edid + start, len);
 	return 0;


