Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CAD47CC89;
	Thu, 20 Aug 2026 16:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243680; cv=none; b=YwX+tJOJeWAZUXjZfZJ0UrPlr+UkTVx2ynWePDJpyAlsUJRa5xP/498VyUDgt1TEZGl9rK6ZHj+3OKLzT/+qsMNShdz7BJhG9IDPAXhdjBvaOtI8N94u4VtsMPFVHikNF0x/cvTxsQNPFDxfjY72spas6wqFlZyTPXrcxtEOXSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243680; c=relaxed/simple;
	bh=HbVSyisQvvVKhXGyVbDgYAnB4gWkekS+6Nu3E2EIWlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBDxMol+oFPwTru3Rm8tQTLYSTmm9m/8H4ZgPEWcXhp9xOUdgCaX49aKqdZ1DFnws7vk52ojAM8DQ+h3s30NujN1q2Rp9RqhQVXA5CAGi9y6DBhShDby/lown4Tu7kNzESJM0UXF20TcvF537oixNxuztvrjBHv59OzzUx3wOsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yctvkNGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yctvkNGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D531F000E9;
	Thu, 20 Aug 2026 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243678;
	bh=Qkxs950g22sZB27+6buB42AJJOeIVACrAAeuxKPljig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yctvkNGSLaFONGK7rss0gpgKOOWphCB8u3UdHITGDzSnvoefp1z8kv09UTySNll0Q
	 BK9iIbj08/lAeee2D/MbEsEaTE2eqv1WK3UU3aq7wNCkwW7jNZEZ3jOcMIMjZtZnY3
	 Ox8EoyrqvDbX7OrW38y5Lqy3fnPpOJNGE1f5jJmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/272] drm/virtio: bound EDID block reads to the response buffer
Date: Thu, 20 Aug 2026 16:56:02 +0200
Message-ID: <20260820145236.799892684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 4e1a53892ba7f8a3e1da6bfc53c83ae7c812dccd ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/virtio/virtgpu_vq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/virtio/virtgpu_vq.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vq.c
@@ -727,7 +727,8 @@ static int virtio_get_edid_block(void *d
 	struct virtio_gpu_resp_edid *resp = data;
 	size_t start = block * EDID_LENGTH;
 
-	if (start + len > le32_to_cpu(resp->size))
+	if (start + len > le32_to_cpu(resp->size) ||
+	    start + len > sizeof(resp->edid))
 		return -EINVAL;
 	memcpy(buf, resp->edid + start, len);
 	return 0;


