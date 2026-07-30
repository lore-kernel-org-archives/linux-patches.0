Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3233453A52;
	Thu, 30 Jul 2026 16:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427588; cv=none; b=bdy2eIiXe3obZNoiAFT2IG0UsmWH283qyEbbk5LU51K7hlUiaeDcUomdA0kYz4chnEBXBs6dW2mybedwlsTql/1fwUdadbRLfKBepbSbnJaJKNWg4YSbb3GrEOv+6RKEXXTouuSNrwA+Uj8PPQvw/Om4C13xz4w53rDshwIKpS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427588; c=relaxed/simple;
	bh=xFOPtF01ErikZOUaFHiiG7q5kdBdywwen7MAZtWswhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIOigG0yu3EeNVdyOsLEb1KLr8XjxCj5O7freSKvNd7sa8PlAd61rrZ706OUmGu3Q63Br86IrtUUXSimodNYz5G3vcpXhAeypG41Lvj0h7Zcy876tEYg5PkECGIBgh+lsK4CJQ642UT33XvLy9dJ0FIBx7z9bjn8MwjyIJC4lJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3Tl+IlO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3Tl+IlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A4C1F000E9;
	Thu, 30 Jul 2026 16:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427587;
	bh=dULoxkZkYgTiGvUH2Y5cJtvwMOSBN4v1LHN+FhXXJwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3Tl+IlOvSWVsJKzS2SvL2xy+B3EEYB7uuyrgOWB8vGkq47VihIdmqBaATqZJHZ18
	 G24NvlBSkSUxbVAEfhIxyCduRxzhQfTHo4UpQuxQiCibvokp6FQGY9nuCGEPvj9gBc
	 wrjT0SXXaJ0KgqRvRAtc9KZ5YPkfGZ1kJjdhKOB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>
Subject: [PATCH 6.6 221/484] drm/virtio: bound EDID block reads to the response buffer
Date: Thu, 30 Jul 2026 16:11:58 +0200
Message-ID: <20260730141428.274121469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


