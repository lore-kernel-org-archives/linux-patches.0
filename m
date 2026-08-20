Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3158B47DFBC;
	Thu, 20 Aug 2026 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244397; cv=none; b=OutS5ERuBCIk1S5m1goQmx19cI92IGWqbIf+ZBcxFIJt8rhop7l92aCTiLsCy4WO29kBEvq4uPnHZpfVXCcKDajEmskX7Vy7a2M3aJBgX3KyYfCWckhGwpziepFZc1P/eLNpZghv/Kzyu6KM5G0Spf8cvXzw5YCaiYY8VgvL9w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244397; c=relaxed/simple;
	bh=EQLFSktammrUWFYPfMud2WniJx6QuplNWiM+PJW+Hr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WINE0jZcrPZn26KoySOpOfwrJhyULrgerILYHjYrhbnlSkvFeS9rVsmlOJvqGPe4WI3myl69nAACiN6aZjE+zkvCIssydjoIu5u8wQfH+24r3MoQymqnwlMEUJ8uGlDCt0BTttRlpK/cFIYNz04+oF0rd/pXugzWggRpHxQ4Tow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U51TH3Tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U51TH3Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1681F000E9;
	Thu, 20 Aug 2026 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244396;
	bh=UyBlgEbUn3SByMLBtEL/UBBeW6KNcSDcEL4ej2B7H7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U51TH3Tx+TaK/hKCqKjc+HplEg+SgDtepaHi9R54jGekZy2m1KCrtgqr+aKiBp3/p
	 pjjUTomZ+eRGZM36kb3csmsX5N/qGEaosDPmeAhup+GbfvrguDLGgtN/oxXqC7NQVU
	 XxZ+0YnR1E3EQmIc/iK7+sBIqO+ic7WDPi69kiqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/235] drm/virtio: bound EDID block reads to the response buffer
Date: Thu, 20 Aug 2026 16:56:31 +0200
Message-ID: <20260820145221.167382525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -724,7 +724,8 @@ static int virtio_get_edid_block(void *d
 	struct virtio_gpu_resp_edid *resp = data;
 	size_t start = block * EDID_LENGTH;
 
-	if (start + len > le32_to_cpu(resp->size))
+	if (start + len > le32_to_cpu(resp->size) ||
+	    start + len > sizeof(resp->edid))
 		return -EINVAL;
 	memcpy(buf, resp->edid + start, len);
 	return 0;


