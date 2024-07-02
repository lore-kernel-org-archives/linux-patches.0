Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6783D978;
	Tue,  2 Jul 2024 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940823; cv=none; b=rWCMg0uY/LsakmdkEqp9Xt95ZHLsOj7/J1bT0q5jiTAYSi4Ug0BNaEuGAKEzg1O+hbNmBydzK+KMXETa1lbG8s/s2wsk1zuZHChpLmpgEh0ts/o5NJPxHRK8996bQKzp1OwycLDWifgStPi6H1TeuVnW0p2zpZMDRKdPQcIGvgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940823; c=relaxed/simple;
	bh=F9aFTsJPv5enkBVOk7E4u9rJ/bNlbVs4o8wOSz1NZ5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4wCK/qajPifyIYce/CdjI9GU5HvwxrAUpnoXZsV2TbJSfPuZf4veyO2GFlfq2PyX0qrk8yOu+R9GPyvpVocXXgAE66SohLx5O/mzvMH1ycJn7ODm6nTqCrgFEiBHQRbSQjz/D/gOFNpDpv1U0KE1GFNuQYNGOgs93Wfr4W6IWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7u6FEVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7u6FEVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD62C116B1;
	Tue,  2 Jul 2024 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940823;
	bh=F9aFTsJPv5enkBVOk7E4u9rJ/bNlbVs4o8wOSz1NZ5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7u6FEVilnO7z6af0PEpAYiqeQD6pC3NX2QCRdD1r9cuVnrI0lh72fXFQPJpw3TQV
	 NmqZHRAMOvkbeQhxZGUEBQ8/KqiGIVuolTgK70pN+A8jNaqo7ByoJozqkY6N2GzgDS
	 VwQX7gf2wARmpW0yWjQFHA0FXdKRfAr9+8979dl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/163] ALSA: seq: Fix missing MSB in MIDI2 SPP conversion
Date: Tue,  2 Jul 2024 19:02:41 +0200
Message-ID: <20240702170234.845227731@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9d65ab6050d25f17c13f4195aa8e160c6ac638f6 ]

The conversion of SPP to MIDI2 UMP called a wrong function, and the
secondary argument wasn't taken.  As a result, MSB of SPP was always
zero.  Fix to call the right function.

Fixes: e9e02819a98a ("ALSA: seq: Automatic conversion of UMP events")
Link: https://patch.msgid.link/20240626145141.16648-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ump_convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/seq/seq_ump_convert.c b/sound/core/seq/seq_ump_convert.c
index 6687efdceea13..e90b27a135e6f 100644
--- a/sound/core/seq/seq_ump_convert.c
+++ b/sound/core/seq/seq_ump_convert.c
@@ -1020,7 +1020,7 @@ static int system_2p_ev_to_ump_midi2(const struct snd_seq_event *event,
 				     union snd_ump_midi2_msg *data,
 				     unsigned char status)
 {
-	return system_1p_ev_to_ump_midi1(event, dest_port,
+	return system_2p_ev_to_ump_midi1(event, dest_port,
 					 (union snd_ump_midi1_msg *)data,
 					 status);
 }
-- 
2.43.0



