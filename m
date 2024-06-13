Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7843B126F32;
	Thu, 13 Jun 2024 12:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280638; cv=none; b=NCekSxnCUdPpcSjUbHb0lGDB06uu3NYlEIYZBjz/brR04hUl0BszWi+bL43XuD1WP7fPLIkezmAytLW7sCcLk1VsJ5j80VH1UcGR1maIOlded1oVWi7XrdN/M8Ao6Bxcfw6tXwCDG4BDI+jBoiFjnr7HyjqBk9avZHTnbgm9NYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280638; c=relaxed/simple;
	bh=hhEwjoRtOPjh47sipeLEeAhoE2oaf3YXNYZT+RUBz+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+ECbQEffMUf3wJiBLxLGhS6iEJfVfEtlHm92jZVWefNzuOmS7Juh84XeiruHTKB9M435SihJPa+P264CeW7oya0C0I/xL/Gs9smhKq0Gdw/G7ZdjwvERIPJ0p9MUGhhwQmztmAflr4XNLN++R12Q21V5bvMXI6FZJ+gjb7iNMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qw8+MyoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qw8+MyoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30CDC2BBFC;
	Thu, 13 Jun 2024 12:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280638;
	bh=hhEwjoRtOPjh47sipeLEeAhoE2oaf3YXNYZT+RUBz+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qw8+MyoSMKWHdoGeb+2lfiy6juRrKaxEvRo/uOmCbLLyRgjvd494gCL1k5l88lNrL
	 ImoD9xMhk+BJxDpFcSCx6n/x+hvRUPvyGZtfwkdehGdC6JrxlvoLDuFFVgU29qOCAv
	 Q/zVMgt6gPMHinObFGjxaKzSQAOMgKNgNBe0MKa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 122/137] ALSA: ump: Dont clear bank selection after sending a program change
Date: Thu, 13 Jun 2024 13:35:02 +0200
Message-ID: <20240613113228.032657278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

commit fe85f6e607d75b856e7229924c71f55e005f8284 upstream.

The current code clears the bank selection MSB/LSB after sending a
program change, but this can be wrong, as many apps may not send the
full bank selection with both MSB and LSB but sending only one.
Better to keep the previous bank set.

Fixes: 0b5288f5fe63 ("ALSA: ump: Add legacy raw MIDI support")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240529083823.5778-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/ump_convert.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index de04799fdb69..f67c44c83fde 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -404,7 +404,6 @@ static int cvt_legacy_cmd_to_ump(struct ump_cvt_to_ump *cvt,
 			midi2->pg.bank_msb = cc->cc_bank_msb;
 			midi2->pg.bank_lsb = cc->cc_bank_lsb;
 			cc->bank_set = 0;
-			cc->cc_bank_msb = cc->cc_bank_lsb = 0;
 		}
 		break;
 	case UMP_MSG_STATUS_CHANNEL_PRESSURE:
-- 
2.45.2



