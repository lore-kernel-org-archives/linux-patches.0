Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F786282F1A;
	Fri, 15 May 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860603; cv=none; b=bZjXMAQLApt0CTbLCzxnNUz1IyJYVsDUPLuf+0Zez/7Xj+J2kjcfKiOVkjmLAXd4lGbL/es2aPtOZMIExlppNCm3OA3aLMdbn68qzy8dBNrjw3b0crRbo/MXq94Jr7I3w3gJ8lhUBPxSTfL3w7gGoxNm3vIoNgdF8KUijII2X74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860603; c=relaxed/simple;
	bh=Ei2f41D+rzkA/Zf1noMsHsee4z955UN1y0dJoF4bMDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZPHdebMp+1jLi/NhF6GWepwGZUAaxZv55fTzSbj0OLp5C0+VR4Hz+cVelLmjJ9QOgUzDrvFblh4n5iFTrtRgPjRZGtr9yX6+MiUu7YNbpIdzITd4vNaG8fn7iHogcD6I1jmBai7I4KeSG3FIVVJC8zULG7+e68sTrxlgZMJZTB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNV713eT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNV713eT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E22C2BCB0;
	Fri, 15 May 2026 15:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860603;
	bh=Ei2f41D+rzkA/Zf1noMsHsee4z955UN1y0dJoF4bMDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNV713eTBPZuBVHKjL2p8OJ+Ign3gAYKDJ+ZKfW7OMe3xR9OFuGdhp7+ZPymwmOWj
	 DdMlGm2qasMb6ZCnYLWXyyVBecxHoAwrVyi5ahgvK8IvusygeSK301ug0N68DreTIT
	 J+g1t/9oSlB1WHaUhJ1OPC1qNVX83tg0+vxA4Bjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d56178c27a4710960820@syzkaller.appspotmail.com,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 001/474] ALSA: usb-audio: stop parsing UAC2 rates at MAX_NR_RATES
Date: Fri, 15 May 2026 17:41:50 +0200
Message-ID: <20260515154715.087937838@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


