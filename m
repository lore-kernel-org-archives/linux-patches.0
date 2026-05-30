Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F583CC7F8;
	Sat, 30 May 2026 18:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165729; cv=none; b=ISsoOv1tqZyHQm3VztBIodkE2MkjqB+E5wF6OR9z+S4UuA3rT8kfr0UThmUs2MqxzCFVHnxHWhmmPi1A1iyH08duLhzgcZmYwgYbc5sqRdwkjdwLHxyEkq1pursWcBhbHHdZBcUtf3B07nS2b2KwKJ2zSo8lN3TXPCe8Awbpky0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165729; c=relaxed/simple;
	bh=sWQvJAKHF9pnSpPP1Lc+ISsy4jSEIUfASzs1QDCg7K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fEYVCGJqIgTwHE/+s0YKbBl8GT4MIaCSWu+mCQJY0CXYn/18wz68cp9y7nsDMTnBxIIynibQ1ge5c+MlPW3kGoj7nbyonyUbTSSn8FfIMCE3i/tqAt/8gg9Kx5CnVMe4XRgAGvdEuc6A3zF0hHnq4QJ/5oKr/Z9qwhDPTAkN3pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3PJho9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3PJho9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEE51F00893;
	Sat, 30 May 2026 18:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165728;
	bh=pI5NQ3EEZSGNvtGdxJhc4QyLbwCk7MOvg0lpztrlSls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3PJho9Rp1YPdtnDJdQAAxlqObUtwcmkNLf17r44qh+KrSbZEtCAr+fa+FYbgZJ5L
	 JtjVJeNoC6uLPJXjJcNUJQ/u+wVSGSV4ZGaHtKWpyvv+JuA8324KPdWnj0GeSSwf21
	 DUpVs/GKjzFyhnY9RFmop4/b0QjL/o95KVAj4tzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d56178c27a4710960820@syzkaller.appspotmail.com,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 137/589] ALSA: usb-audio: stop parsing UAC2 rates at MAX_NR_RATES
Date: Sat, 30 May 2026 18:00:18 +0200
Message-ID: <20260530160228.380051072@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -395,7 +395,7 @@ static int parse_uac2_sample_rate_range(
 			nr_rates++;
 			if (nr_rates >= MAX_NR_RATES) {
 				usb_audio_err(chip, "invalid uac2 rates\n");
-				break;
+				return nr_rates;
 			}
 
 skip_rate:


