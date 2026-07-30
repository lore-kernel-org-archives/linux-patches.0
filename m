Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F823B5DEE;
	Thu, 30 Jul 2026 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424343; cv=none; b=ZdLEMfLisVXPBXGtFCdteSKoWADrhbTOKeYlgjieTNB6F/9hp60wnXcEAobE2/4qSP0AHM/SUQY6eqi8ZI9rQCYaHWmCUWpHh0+fd6Uw+3SoXr5dlQe38GgvQBOH9h16uHHJ8AxY2ltmeUmoHQ0nIH6+NHxMMJkFQ22InF7g548=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424343; c=relaxed/simple;
	bh=9TSZeMtk7M0YbelFSY0Jb603Vd2yP+IiMNcoTsFTIj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDPWpjcH6BhtsuaORUZ8KKrNrhjf+NCa4K54raQrB3t+NFDY5cIKMCeZcrLQpBFKuZY5FBjqG8aCp/alVtQj/s800+mxQhe+aHXBtU78EPYKYhLkMgZqQsn8QvfYyX30G4PPr72TPMGbXnX7lWGLfCWp4ygj+k9fGvU/VQOJmkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Toks9fpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Toks9fpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE121F000E9;
	Thu, 30 Jul 2026 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424341;
	bh=23x3ncY/TkBCsZM3EgZx1LxQRgrx6WotztftctlY5UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Toks9fpFfNBsqd46RtiyHsgTK8adFj1WencJfAAWdbG2ENwmsrT6f/mndqb68M/hn
	 Q0RNvuu6P7QZ0hk2N33mOFe1yjp87LsziedyCgHT6hLbM5bGnnPizia7iuzcBeFg1N
	 JTxP2Yiq31ev5QmnXBig4MH9qxhy1vH7uIevFomA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.18 358/675] drm/virtio: bound EDID block reads to the response buffer
Date: Thu, 30 Jul 2026 16:11:28 +0200
Message-ID: <20260730141452.741790398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -893,7 +893,8 @@ static int virtio_get_edid_block(void *d
 	struct virtio_gpu_resp_edid *resp = data;
 	size_t start = block * EDID_LENGTH;
 
-	if (start + len > le32_to_cpu(resp->size))
+	if (start + len > le32_to_cpu(resp->size) ||
+	    start + len > sizeof(resp->edid))
 		return -EINVAL;
 	memcpy(buf, resp->edid + start, len);
 	return 0;


