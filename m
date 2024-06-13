Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD741465A9;
	Thu, 13 Jun 2024 11:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279611; cv=none; b=LfxC2bd52rdxwc0Gl/JvhnZ3dz18fzjAYg05+kN99cJzdGJ9xCXf7JtOu2cDe2wzr22EMnpuhMIwB294PE0tffFo8/et2JoS01WUlcJ/9Ja42sU589+KRNSbhgOtsE9Tjb/aubxabvNgrfChwHaDPJ7w+qSoS55oMTVFDbbR8SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279611; c=relaxed/simple;
	bh=TKSMe9ggioPa+Oi0sjXU8kEjed92KDzRC4rA07SXeCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gObTV/lz/PBUg6fd41DL67pp7lEqqCjU4YMGWRQjKnTyj3rTSzs5mqWMBflxvHJQbuKnCKZuDNu4EOiFF1bOnk1RHTMIHjvHk49g4I9CU4BiI2X3uuAW7c6+mXF7k/PAJ/syF1RMxKl+Y81sISY760HLleue1n7Ju6gCa7T/VR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1+DfDeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1+DfDeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FD2C2BBFC;
	Thu, 13 Jun 2024 11:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279610;
	bh=TKSMe9ggioPa+Oi0sjXU8kEjed92KDzRC4rA07SXeCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1+DfDebtw2tSFJ6EjEygbzghCdqouYKA6E3bBUhHFAfutwdpegS+mj76Tcr0LtbW
	 BWo7lnD6vw5HmVV8oOZSys+Cdau8btLOLE60pKTUgj9TaJ2fJE4M+fW/McTPU4JlRZ
	 u6ttr3A+NxKrbj1ZqCdyIPbmoN9/6mDlOk++287c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 135/157] ALSA: ump: Dont clear bank selection after sending a program change
Date: Thu, 13 Jun 2024 13:34:20 +0200
Message-ID: <20240613113232.628084597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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
 sound/core/ump_convert.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -404,7 +404,6 @@ static int cvt_legacy_cmd_to_ump(struct
 			midi2->pg.bank_msb = cc->cc_bank_msb;
 			midi2->pg.bank_lsb = cc->cc_bank_lsb;
 			cc->bank_set = 0;
-			cc->cc_bank_msb = cc->cc_bank_lsb = 0;
 		}
 		break;
 	case UMP_MSG_STATUS_CHANNEL_PRESSURE:


