Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ABD178381;
	Tue,  2 Jul 2024 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940114; cv=none; b=cYuf/YvtY1Xd0KZ+FYzwsNfDRgwGkEGys+V1LzgJYoKGX5hHET43eiUyJFndBKfiv3+MfHyv53fnaD7+nHb/Yebqqm8gVx53LwiEbo8d6jSczUzwGqptGcGhCWSk/WofvU2JDGFojccjQQQ64Xa57/IxnYuTnYclCKk857vEHHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940114; c=relaxed/simple;
	bh=tTcjNdyH/+upbLgYU398RbD+PRoLZ+fYH4X/qDJacP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAyMnpacAtXdIE5D34xxetTpHVkzZW4fqsrHxc8LmV9Ao4MP8BJg46k6isWu3/rsOZgM+93jxcZmCvYY19dVT6P8Of4eOyVtbF4Gb6UBzVhbgZ2q4/kwoRtVmTGrRZOt/6YiSQjyWgwdtk3bOiqM+eV3wAZhJo3CwSjZ8hANQ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sp9PY61F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sp9PY61F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18A7C116B1;
	Tue,  2 Jul 2024 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940114;
	bh=tTcjNdyH/+upbLgYU398RbD+PRoLZ+fYH4X/qDJacP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sp9PY61FsKJJFR6y5cRNWSFl3mnZVAhO0bzRH8CnyX01qDG6vdb6n9hvrCQ138Xcs
	 i+B52cL2KawNTxnaLtdgkuwy0JV3S/0MOUSjVTLU0bUgBMZkDgllPZQks87jb7vwp4
	 zEc5f9kNbYEVou2XOarQMc2xn55hYcBQ034Ot79E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 057/222] ALSA: seq: Fix missing MSB in MIDI2 SPP conversion
Date: Tue,  2 Jul 2024 19:01:35 +0200
Message-ID: <20240702170246.164459575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



