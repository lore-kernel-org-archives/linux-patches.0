Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363A3A7F4C;
	Mon,  4 May 2026 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903650; cv=none; b=WdolD8f0Co5lGNIbVsLP7noE/+SxdWMClMq+5aZVBQ4NDCj5UClXlA42J0j/KOF7nlO7IIo7PnsssLV3TSIH73aOH8JKOjedtdINQjIvHauJDCDVFsCWeqt2ZOQqiPqY4A5XvgREW9Wsfggg9lcAybuV9MNsKHaZoFAA6r6oA9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903650; c=relaxed/simple;
	bh=oMi3JsNaO+E/WwYY4c3L8yGbs7Sd2S0NqUo9pvjW/fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1AkHodJB4i5U3cXzXHO/3yZraezgiB8oIB+V5/FYDlcmUDRY4+Hj6CLVdP30PLmiZMOnE+Ek6vaGOInKhEU/l5F1vxDtA0kEO3NgkFjbernecWrCOImZrTZ/99sNS3+EwdZc3o/rZAHQI1HD1JNGkyP4NCXZag6Eb7LbI4u8aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hHPs4NDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hHPs4NDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7880AC2BCB8;
	Mon,  4 May 2026 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903649;
	bh=oMi3JsNaO+E/WwYY4c3L8yGbs7Sd2S0NqUo9pvjW/fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHPs4NDoyDT+jJA/vWY8H2npXROPnidP2juj8PW+io7dxZvN26Q9/7l3toC8Zv5nc
	 Pba7iNvpNu1L8zWVSASsjoUHifq5tkhv/CNFGo+n3fAMQSkW+6WTwyj8lpkosdrGWb
	 VuVNsb+Tb+QcTX3W1uEOkHSboERBNH7BgJwdFUkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d56178c27a4710960820@syzkaller.appspotmail.com,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 001/275] ALSA: usb-audio: stop parsing UAC2 rates at MAX_NR_RATES
Date: Mon,  4 May 2026 15:49:01 +0200
Message-ID: <20260504135142.989741281@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 3c318f97dcc50b2e0556a1813bd6958678e881fd upstream.

parse_uac2_sample_rate_range() caps the number of enumerated
rates at MAX_NR_RATES, but it only breaks out of the current
rate loop. A malformed UAC2 RANGE response with additional
triplets continues parsing the remaining triplets and repeatedly
prints "invalid uac2 rates" while probe still holds
register_mutex.

Stop the whole parse once the cap is reached and return the
number of rates collected so far.

Fixes: 4fa0e81b8350 ("ALSA: usb-audio: fix possible hang and overflow in parse_uac2_sample_rate_range()")
Cc: stable@vger.kernel.org
Reported-by: syzbot+d56178c27a4710960820@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d56178c27a4710960820
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260415-usb-audio-uac2-rate-cap-v1-1-5ecbafc120d8@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/format.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -463,7 +463,7 @@ static int parse_uac2_sample_rate_range(
 			nr_rates++;
 			if (nr_rates >= MAX_NR_RATES) {
 				usb_audio_err(chip, "invalid uac2 rates\n");
-				break;
+				return nr_rates;
 			}
 
 skip_rate:


