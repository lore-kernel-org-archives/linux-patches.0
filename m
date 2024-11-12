Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9F720B20B;
	Tue, 12 Nov 2024 10:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407141; cv=none; b=BpghYp/4XmSyMgxTAh2L5e7T9HNezsLyFmXK3dGhxjDv7oWZn79JlVTnbODsr3Bejf7rETLJfEa7mZ5Omanv3cBKb1l0BYaPBjR7ps42JwOA33ECQcRA43QYwg6raOYy2UfgDg8XwZ5GabnSUgIZxxhVV48gnXu8biMDviAYtxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407141; c=relaxed/simple;
	bh=KW1rnn5kgWO+pD47FHk67BZhvBM3rQ7PDIpIwESL+PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrRySYOPI+JFNQhuooDBtfBLo7U3x1wFyfI8BA2gNE/0ItTT/ps/575zAF0+lQqTIf5H6dRq8XfWY3WGv3eNLGT7LZ97DOwN44P9rYOc6L79q4cbrfLR+RFyqXNKrmL/2as4luKjaFZYaQbszaqJ8uMI9QLIl2ypmcJXnxhCxqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7ppBuXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7ppBuXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F630C4CED4;
	Tue, 12 Nov 2024 10:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407141;
	bh=KW1rnn5kgWO+pD47FHk67BZhvBM3rQ7PDIpIwESL+PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7ppBuXbT4sHOGV0S0K4GqXFgbqnvUE9ZaaUPp0NEfB+5zp2LGwKTsb4jIS7xO/rK
	 WmXSI1Fie/7vNXRpEz4tsedi8R0wxDt8p4ZVGqVP1gKQKV6CiGRgbn58+xwbVglRxs
	 xiL3cDIAiBucgsC/6aCMDG2hTd4guW0YSWuuf2uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/76] ALSA: firewire-lib: fix return value on fail in amdtp_tscm_init()
Date: Tue, 12 Nov 2024 11:20:56 +0100
Message-ID: <20241112101840.972948419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit 8abbf1f01d6a2ef9f911f793e30f7382154b5a3a ]

If amdtp_stream_init() fails in amdtp_tscm_init(), the latter returns zero,
though it's supposed to return error code, which is checked inside
init_stream() in file tascam-stream.c.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 47faeea25ef3 ("ALSA: firewire-tascam: add data block processing layer")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241101185517.1819-1-m.masimov@maxima.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/firewire/tascam/amdtp-tascam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/firewire/tascam/amdtp-tascam.c b/sound/firewire/tascam/amdtp-tascam.c
index 64d66a8025455..ad185ff3209db 100644
--- a/sound/firewire/tascam/amdtp-tascam.c
+++ b/sound/firewire/tascam/amdtp-tascam.c
@@ -244,7 +244,7 @@ int amdtp_tscm_init(struct amdtp_stream *s, struct fw_unit *unit,
 	err = amdtp_stream_init(s, unit, dir, flags, fmt,
 			process_ctx_payloads, sizeof(struct amdtp_tscm));
 	if (err < 0)
-		return 0;
+		return err;
 
 	if (dir == AMDTP_OUT_STREAM) {
 		// Use fixed value for FDF field.
-- 
2.43.0



