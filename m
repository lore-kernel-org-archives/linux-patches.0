Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A31E35BDAA;
	Thu, 30 Jul 2026 14:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422361; cv=none; b=OgdVwvxtQNXv/wFTaOJR/7GFzVPacHeMHFp/xSdpV3Ulfxkhig6O1TRiSmBXYrTrIhaU/MUZ0hvsJeNMSqwQUFpzmuxQxkhqg8RBrd+fTFjjVZU/B69mlcVwjgQL3WqNN0x61Jhj6qxgZ3yUF27S6jcLb7ByK+voD7SCSWKHvns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422361; c=relaxed/simple;
	bh=F/pH+8akQV8zAyKxiXCpbE/87M8BvMFUWNRjfWzusXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFHssyEEekbpZPwMBQzW5d87P9Cc0l22Eg6IlZDudBl+UFs2HpTgK2h7xUmKf8UHuMKW3SEhdoiatiC54wMVIy3l55qJP9+WAbSUToJRtxyN3PbhmSswwfcMcVIGkiCjVF1g8aNjhehAWXrAgXegDbwecbe6eKUI0VFgDN2fVo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRxWWQqB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRxWWQqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60641F000E9;
	Thu, 30 Jul 2026 14:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422360;
	bh=bFtuoySl6ymD/Np+o1PW+WCDi/TYW/PTUh9X02YWU94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eRxWWQqBIhFvAzYx+ORHE0a1SK0Pv6iQ5ZIfDNnZIN0UsZJqkblzUbK+v40jgliKi
	 u6Cy2++ErPBdV8D22HS0DT6Tqb9ayBcFrFXzf6udXUSdAjlwQqqiaGmP7OAM+m2FUj
	 EyR9aVJXNNyNFyQYYVXnVAWYOxGLsk2+G0B1TboU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 7.1 367/744] drm/dp/mst: fix OOB reads in remote DPCD/I2C sideband reply parsers
Date: Thu, 30 Jul 2026 16:10:40 +0200
Message-ID: <20260730141452.085958167@linuxfoundation.org>
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

commit 1a8f537f5a1eeac941f262fe73078d6b08ba83c0 upstream.

drm_dp_sideband_parse_remote_dpcd_read() reads num_bytes from the raw
message and then unconditionally does:

  memcpy(bytes, &raw->msg[idx], num_bytes);

without checking that idx + num_bytes <= raw->curlen. raw->msg[] is
256 bytes; if a malicious or misbehaving MST hub sets num_bytes larger
than the remaining payload, the memcpy reads past the received data
into whatever follows in raw->msg[].

drm_dp_sideband_parse_remote_i2c_read_ack() has the same flaw (noted
with a /* TODO check */ comment since the code was introduced).

Fix both functions by using a single combined check
(idx + num_bytes > curlen) before each memcpy. Since num_bytes is u8,
it is always >= 0, so this strictly subsumes the simpler idx > curlen
form and no separate step is needed.

Fixes: ad7f8a1f9ced ("drm/helper: add Displayport multi-stream helper (v0.6)")
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Ashutosh Desai <ashutoshdesai993@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
[added missing fixes tag]
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260510201733.2882224-1-ashutoshdesai993@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -871,7 +871,7 @@ static bool drm_dp_sideband_parse_remote
 		goto fail_len;
 	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
 	idx++;
-	if (idx > raw->curlen)
+	if (idx + repmsg->u.remote_dpcd_read_ack.num_bytes > raw->curlen)
 		goto fail_len;
 
 	memcpy(repmsg->u.remote_dpcd_read_ack.bytes, &raw->msg[idx], repmsg->u.remote_dpcd_read_ack.num_bytes);
@@ -907,7 +907,9 @@ static bool drm_dp_sideband_parse_remote
 		goto fail_len;
 	repmsg->u.remote_i2c_read_ack.num_bytes = raw->msg[idx];
 	idx++;
-	/* TODO check */
+	if (idx + repmsg->u.remote_i2c_read_ack.num_bytes > raw->curlen)
+		goto fail_len;
+
 	memcpy(repmsg->u.remote_i2c_read_ack.bytes, &raw->msg[idx], repmsg->u.remote_i2c_read_ack.num_bytes);
 	return true;
 fail_len:


