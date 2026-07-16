Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6574030C361;
	Thu, 16 Jul 2026 14:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211767; cv=none; b=PLYKHzJzzvwDJh+r4RigJnyHXDfN8k3uwypNPck0LJmKY9MCJLQzWOZmg/U82xeO7o8Aery2yg3lWKxw5oy3DAt78pNepHiHffVsBov+hUq9HgR8QqNPS/W8DcIkNB5LT8+cM0xCOg/f2BMaj7LWpgzgmP+GfeU/vZSBD3Yht7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211767; c=relaxed/simple;
	bh=kCZGryuVYvx8R4fWjyiQ/DXPKT0tZGE1A2jQTuCJp3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g49SJreR2pUnUcsuV2WJv6VrUVh+zw5UKX/LfLjEa+Zdrtkw2NwDJXJMputs7YG8EWsPn2zyvw/XkYF5uji7pNv3LSdbnj2j4RjJbalDSPeJdCHafOL+iJYtoK5URMVTT9t7Uj/xZQlKCXvhyf2gl1dbMCVe1Awj7BvaZHh6Hu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3VIpXYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3VIpXYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACBC1F00A3A;
	Thu, 16 Jul 2026 14:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211766;
	bh=hyVy4GOpTEIN0AoDkf2esvIFnVh7HSd2AvqGDh/ShIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3VIpXYOg+nPBc4MaqFbvYd/PG+W2WCoqpiHGBWpp9sTM1r66hOeFKBuZ4BGP53sE
	 IBeAFrJNoPbIIzvESK+M18xIinx7nxTOoPqeS0eCK6uk+avCAMX2CgOgrvbzi1AT51
	 DPTsWeeIVK0i8LY3/w+pKKbRjRLYxrcxtLouyi5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 072/349] ALSA: virtio: Validate control metadata from the device
Date: Thu, 16 Jul 2026 15:30:06 +0200
Message-ID: <20260716133034.933588037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit c77a6cbb36ff8cbc1f084d94f8dcda5250935271 upstream.

virtio-snd control handling trusts the device-provided control type and
value count returned by the device.

That metadata is then used directly to index g_v2a_type_map[] in
virtsnd_kctl_info(), and to size loops and memcpy() operations in
virtsnd_kctl_get() and virtsnd_kctl_put() against fixed-size
virtio_snd_ctl_value and snd_ctl_elem_value arrays.

A buggy or malicious device can therefore trigger out-of-bounds access by
advertising an invalid control type or an oversized value count.

Validate control type and count once in virtsnd_kctl_parse_cfg(), before
querying enumerated items or exposing the control to ALSA.

Fixes: d6568e3de42d ("ALSA: virtio: add support for audio controls")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260507-alsa-virtio-validate-kctl-info-v1-1-7404fb12ec37@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/virtio/virtio_kctl.c |   50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

--- a/sound/virtio/virtio_kctl.c
+++ b/sound/virtio/virtio_kctl.c
@@ -18,6 +18,21 @@ static const snd_ctl_elem_type_t g_v2a_t
 	[VIRTIO_SND_CTL_TYPE_IEC958] = SNDRV_CTL_ELEM_TYPE_IEC958
 };
 
+/* Map for converting VirtIO types to maximum value counts. */
+static const unsigned int g_v2a_count_map[] = {
+	[VIRTIO_SND_CTL_TYPE_BOOLEAN] =
+		ARRAY_SIZE(((struct virtio_snd_ctl_value *)0)->value.integer),
+	[VIRTIO_SND_CTL_TYPE_INTEGER] =
+		ARRAY_SIZE(((struct virtio_snd_ctl_value *)0)->value.integer),
+	[VIRTIO_SND_CTL_TYPE_INTEGER64] =
+		ARRAY_SIZE(((struct virtio_snd_ctl_value *)0)->value.integer64),
+	[VIRTIO_SND_CTL_TYPE_ENUMERATED] =
+		ARRAY_SIZE(((struct virtio_snd_ctl_value *)0)->value.enumerated),
+	[VIRTIO_SND_CTL_TYPE_BYTES] =
+		ARRAY_SIZE(((struct virtio_snd_ctl_value *)0)->value.bytes),
+	[VIRTIO_SND_CTL_TYPE_IEC958] = 1
+};
+
 /* Map for converting VirtIO access rights to ALSA access rights. */
 static const unsigned int g_v2a_access_map[] = {
 	[VIRTIO_SND_CTL_ACCESS_READ] = SNDRV_CTL_ELEM_ACCESS_READ,
@@ -36,6 +51,37 @@ static const unsigned int g_v2a_mask_map
 	[VIRTIO_SND_CTL_EVT_MASK_TLV] = SNDRV_CTL_EVENT_MASK_TLV
 };
 
+static int virtsnd_kctl_validate_info(struct virtio_snd *snd, u32 cid,
+				      struct virtio_snd_ctl_info *kinfo)
+{
+	struct virtio_device *vdev = snd->vdev;
+	unsigned int type = le32_to_cpu(kinfo->type);
+	unsigned int count = le32_to_cpu(kinfo->count);
+
+	if (type >= ARRAY_SIZE(g_v2a_type_map)) {
+		dev_err(&vdev->dev, "control #%u: unknown type %u\n",
+			cid, type);
+		return -EINVAL;
+	}
+
+	if (count > g_v2a_count_map[type] ||
+	    (type == VIRTIO_SND_CTL_TYPE_IEC958 && count != 1)) {
+		dev_err(&vdev->dev, "control #%u: invalid count %u for type %u\n",
+			cid, count, type);
+		return -EINVAL;
+	}
+
+	if (type == VIRTIO_SND_CTL_TYPE_ENUMERATED &&
+	    !le32_to_cpu(kinfo->value.enumerated.items)) {
+		dev_err(&vdev->dev,
+			"control #%u: no items for enumerated control\n",
+			cid);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * virtsnd_kctl_info() - Returns information about the control.
  * @kcontrol: ALSA control element.
@@ -385,6 +431,10 @@ int virtsnd_kctl_parse_cfg(struct virtio
 		struct virtio_snd_ctl_info *kinfo = &snd->kctl_infos[i];
 		unsigned int type = le32_to_cpu(kinfo->type);
 
+		rc = virtsnd_kctl_validate_info(snd, i, kinfo);
+		if (rc)
+			return rc;
+
 		if (type == VIRTIO_SND_CTL_TYPE_ENUMERATED) {
 			rc = virtsnd_kctl_get_enum_items(snd, i);
 			if (rc)


