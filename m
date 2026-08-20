Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517FD47D470;
	Thu, 20 Aug 2026 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243648; cv=none; b=O5kmDKmhO0aq2VXU9e4hFX27IFJn1m6+5CBdg8Iqzxb/rG+GsmnLUe3Gd7PBfT5CjXE+jwyqferU453v6CVCxyU5IFhIpM9D3CvExLclqPWNKShiEkRj8KDNuxBws5QQeCs6gKKwr0vvxdSQU82igIWImOSPm9lxjTMgFAkogao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243648; c=relaxed/simple;
	bh=xOxiDiO00Xwsaq80plz4boY9SWLRkH3lHYrzrravn/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awJ2AkENgCmBE1gTB3m6GCOepJpYVvp4PWsqPudqe6xnePZ1w2qG5p151My/64akbJDJ1zdo1nFcI3mIlxhdYbt8z98cE8m6q4vY1zeOM5rqAaPMSs1LMyC3J6fWnSf2tLHaTAnHN9a52orXdkGhiDGIkcJqWyd3/R+S1cgzfEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHs1n/Fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHs1n/Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2FE1F000E9;
	Thu, 20 Aug 2026 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243647;
	bh=7E6bakeE9zAIyJSZwxxQc13aSKDUzz88IrpuHVI0ufA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHs1n/FnUbObCeCY1KLcpNVF4VE3f0kXx0+uLxwEBwROd0d+hPBCB/7uFsSlcQplH
	 s59zAiCxMviVHGBaEOtnMd52Q/jeWkR0GIYzIpqC+G0RcDgY45i6r2nwYgveb4QRGJ
	 fJfajzU64eZmWlwIztkil52if9j4BE/cKAh3KHoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 168/272] drm/dp/mst: fix buffer overflows in sideband chunk accumulation
Date: Thu, 20 Aug 2026 16:55:52 +0200
Message-ID: <20260820145236.397152552@linuxfoundation.org>
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

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

[ Upstream commit 55bd5e685bda455b9b50c835f8c8442d52a344a3 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -779,6 +779,12 @@ static bool drm_dp_sideband_append_paylo
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
 
@@ -789,6 +795,9 @@ static bool drm_dp_sideband_append_paylo
 			print_hex_dump(KERN_DEBUG, "wrong crc",
 				       DUMP_PREFIX_NONE, 16, 1,
 				       msg->chunk,  msg->curchunk_len, false);
+		/* Guard against accumulated msg[] overflow */
+		if (msg->curlen + msg->curchunk_len - 1 > ARRAY_SIZE(msg->msg))
+			return false;
 		/* copy chunk into bigger msg */
 		memcpy(&msg->msg[msg->curlen], msg->chunk, msg->curchunk_len - 1);
 		msg->curlen += msg->curchunk_len - 1;


