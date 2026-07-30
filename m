Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE0D3630BE;
	Thu, 30 Jul 2026 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422364; cv=none; b=ZJbZj8ozTZD7BRi0DsB1UHkL5YwJ68AYZgkhkIkof6GwRD0hoGfHZbH5+/tzg9xgrnYZoaZgdCkeAWJD92GyevaWggaf+KLBtGBgA9vQ7X6E2vS7Gp4ov2ToBQjdOI4f9BglPb5I3i9uUmIXu/yjh/ko7ZLQsNjlvCYolmirSYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422364; c=relaxed/simple;
	bh=sTO1X8kelHSBsKawriVj/p9hiew8+0ZOS9b/wkFo/xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OF6rTmUqC42dUVW5cM+kNauC6qoKGUw+cS0wlhmA5Ga897tuvrYhy9pwLNIvd8nioLprvZn8yK+7t40rEtnrTlQUckfQXkZQ6OIKBgcWnq98EWs127g8FkJ7CJgVPkVIpoNy5K2I0uUlJ5OzQVd+87XSjk2BaeSLeSayvNiiYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fz6o5NXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fz6o5NXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C196C1F000E9;
	Thu, 30 Jul 2026 14:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422363;
	bh=PfAO9zPd1ezhXpEi65A2hX4+GbM9CFR78Qi6A6SzHGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fz6o5NXkrKG685vSjbl5b/wdnXlEbhJY3jOZDzIBUWKbJwI6cQOFxus1KNCpY5LJo
	 wSIA+fe3Nhjj/tiybY/QkEk8spxbmBzDR97CEkDNdWBHYpNtVqIGQfjF6S7XjBhIjN
	 zDa9+oeXHBGsbEOv8UK2A08+XCUlQXJcZAA0BZB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.1 368/744] drm/dp/mst: fix buffer overflows in sideband chunk accumulation
Date: Thu, 30 Jul 2026 16:10:41 +0200
Message-ID: <20260730141452.106899799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

commit 55bd5e685bda455b9b50c835f8c8442d52a344a3 upstream.

drm_dp_sideband_append_payload() has three related bugs when processing
device-provided sideband reply data:

1. Zero-length curchunk_len underflow: msg_len is a 6-bit field taken
   directly from the DP sideband header. If a device sends msg_len=0,
   curchunk_len is set to zero. The condition (curchunk_idx >= curchunk_len)
   is immediately true, and curchunk_len-1 wraps to 255 (u8 underflow).
   drm_dp_msg_data_crc4() reads 255 bytes from chunk[48], then memcpy()
   writes 255 bytes into msg[], both far out of bounds.

2. chunk[48] overflow: curchunk_len can reach 63 (6-bit field). chunk[] is
   only 48 bytes. Multi-iteration payload assembly appends 16-byte blocks
   until curchunk_idx reaches curchunk_len, writing up to 15 bytes past
   the end of chunk[] into msg[].

3. msg[256] overflow: each chunk contributes (curchunk_len-1) bytes to
   msg[]. No check ensures curlen + (curchunk_len-1) stays within msg[256],
   so the memcpy can spill into adjacent struct fields.

All three are reachable from any DP MST device that can forge sideband
reply messages on a physical connection.

Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260410041901.2438960-1-ashutoshdesai993@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -789,6 +789,12 @@ static bool drm_dp_sideband_append_paylo
 {
 	u8 crc4;
 
+	/* curchunk_len must be >= 1 (min 1 CRC byte) and fit in chunk[] */
+	if (!msg->curchunk_len ||
+	    msg->curchunk_len > ARRAY_SIZE(msg->chunk) ||
+	    msg->curchunk_idx + replybuflen > ARRAY_SIZE(msg->chunk))
+		return false;
+
 	memcpy(&msg->chunk[msg->curchunk_idx], replybuf, replybuflen);
 	msg->curchunk_idx += replybuflen;
 
@@ -799,6 +805,9 @@ static bool drm_dp_sideband_append_paylo
 			print_hex_dump(KERN_DEBUG, "wrong crc",
 				       DUMP_PREFIX_NONE, 16, 1,
 				       msg->chunk,  msg->curchunk_len, false);
+		/* Guard against accumulated msg[] overflow */
+		if (msg->curlen + msg->curchunk_len - 1 > ARRAY_SIZE(msg->msg))
+			return false;
 		/* copy chunk into bigger msg */
 		memcpy(&msg->msg[msg->curlen], msg->chunk, msg->curchunk_len - 1);
 		msg->curlen += msg->curchunk_len - 1;


