Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6391CAA6C;
	Sat, 30 May 2026 16:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159930; cv=none; b=grwR0aYgHmMF28RJtsMl4Us/YVRqq2WnlAytih5/mPBX3wJZOMvB6ftdtwuZghIadEjZRnbQPi3sWqVE71tmEMjOc9fYrKafqVgGByV83GjZo+r7XVXkug+4Ajd1KDgTtH9NZmd0rIUt5WpUNSqLRUpxp5Fdpsus1T/Kjd4Y4Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159930; c=relaxed/simple;
	bh=2LRlCed4DZegtsZ3J0k8byvbCsBmGIA8M6meGBXoYpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QyfT6kMOOcFANQ733Jw+NopOsnrA4qT7cdWB1ERZmqln+qstu6yX311zsHJk+HyPCTZyUFrAQQyacyfrt7cFjTJTHJUD9b1AASceaYuJUJ1Txos8MVnjh0czMbEqPPVJhAHYhrxh6gnaUAtJYKrgcyAiafdyQz6Y8P+81XyrO/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hs0RpH8g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hs0RpH8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AA81F00893;
	Sat, 30 May 2026 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159928;
	bh=W0i6uj+qWDd8c1pPJiwehCeTda+C+gkR4632DlIEq/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hs0RpH8gOnZourPFEuIQZy2dufPJECAZTLTJHNRXfIuxpZisxBFQPhBDpxAoHtvTS
	 URLH5MT5aJhrEov1h3CjwNxknGB889Meq/zuFUKnIR779AqumpklhbIIoJ3kQ4nkD5
	 5iRAVqSS+RJzq8+/Wd7tju08hbFo+yh6E7odmxR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d56178c27a4710960820@syzkaller.appspotmail.com,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 159/969] ALSA: usb-audio: stop parsing UAC2 rates at MAX_NR_RATES
Date: Sat, 30 May 2026 17:54:43 +0200
Message-ID: <20260530160304.922953470@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -461,7 +461,7 @@ static int parse_uac2_sample_rate_range(
 			nr_rates++;
 			if (nr_rates >= MAX_NR_RATES) {
 				usb_audio_err(chip, "invalid uac2 rates\n");
-				break;
+				return nr_rates;
 			}
 
 skip_rate:


