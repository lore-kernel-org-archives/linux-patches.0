Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D9F481ABE;
	Thu, 20 Aug 2026 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244379; cv=none; b=NOgyEN6uwdhXsWPzfa0PabtIFYYjWZFce/beIEXsAoGLq1SuWPUMK6/BnmWFFkuvA5sszop3ZJRoOEb8mfi6gY5i6FT0ozHsWzEZyexqgSCp3+h3CFc+jw/n/a2SYj4AmeDbymF74WmOyxcWoGZkbi68QnZQN4a04Fdi4wN35sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244379; c=relaxed/simple;
	bh=dw7Dlht31D1NYfKOi8ZnjOK1E3tBiH2Pic+mm/EXEko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuXUTNTGbOMyuWZw1lzux8sOXypNH4i1LTyHD5Wb4M9MQtEY7FGRnXPcQ0eu10TQGWRHSstvK+jGAePX4ffkzelYpvUNjUc6HAegOPs6Vg31Cse4vRHnZ4to8vCfh+LdFALptuBbWUL60nF4SCnjYlhBoh/qoHwuPEBYCVYcPLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=np7JOh4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="np7JOh4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D151F000E9;
	Thu, 20 Aug 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244377;
	bh=kMrEaGcy6qHYZopZKi0vMNwUkp5RNOZf362PesrSWwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=np7JOh4BPnOb6NrwSeel7IUWlKTp+OK+5bmmKZITWwOqNPz+36XD+8RTG8MxEKGYs
	 zoEPoW4KO2vsQuDpVQttwdIt82K5/6MQDjMtOMjJCA1g7AjNTMtH3i2R9pgzAIpFHO
	 VrLQnoONAlWg5l+pLeBnmZfBCFRUKI3JHHW+my9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashutosh Desai <ashutoshdesai993@gmail.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 149/235] drm/dp/mst: fix OOB reads in remote DPCD/I2C sideband reply parsers
Date: Thu, 20 Aug 2026 16:56:25 +0200
Message-ID: <20260820145220.963701113@linuxfoundation.org>
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

From: Ashutosh Desai <ashutoshdesai993@gmail.com>

[ Upstream commit 1a8f537f5a1eeac941f262fe73078d6b08ba83c0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -868,7 +868,7 @@ static bool drm_dp_sideband_parse_remote
 		goto fail_len;
 	repmsg->u.remote_dpcd_read_ack.num_bytes = raw->msg[idx];
 	idx++;
-	if (idx > raw->curlen)
+	if (idx + repmsg->u.remote_dpcd_read_ack.num_bytes > raw->curlen)
 		goto fail_len;
 
 	memcpy(repmsg->u.remote_dpcd_read_ack.bytes, &raw->msg[idx], repmsg->u.remote_dpcd_read_ack.num_bytes);
@@ -904,7 +904,9 @@ static bool drm_dp_sideband_parse_remote
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


