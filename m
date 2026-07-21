Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFF33CAE7F;
	Tue, 21 Jul 2026 22:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673154; cv=none; b=gNQqV9jKlEyrniFjdGcpp3AloCW7no6xatkaMmnP6kA/DnPmVDwg+3bH5NhfPsjkipw6v6LY6k3Ktj0/dzC0/rnwYBIb29XO3W0fADj8CHYMV/24ysauX5TbOwKZjnzG6zZYsyP4spXbH6HMg5VMn91OIlcGxbgAhtnvLk0Xsso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673154; c=relaxed/simple;
	bh=PzdNHpiYUjKvd5r/ju6ai+WDka8mZsWXRZsYEUb0wU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5E1Dypj2+XMREHUWJZWW/I4d/p0AmL0TkP8eXyMm5wn+0VUclCvtPnGjIsqp3LgdIFP9Dt/Fob7VdMUOPrPvfWVlImdgyvEk7Zk4FHa2NBMrqpue7Q+5LhoVbV09gREhrupb1OokFQt7kC9oeszhhDQ3EIn9TxJsMR1b1NpFhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQvtSRY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQvtSRY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A811F000E9;
	Tue, 21 Jul 2026 22:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673153;
	bh=EPRqpPAoD8BBymzBjPy+6ezduV/R5/CxPu7vHrGr27Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQvtSRY2+pcFONt3XPPU1xknqd+FDjRgygw9MIMUyKfk/fHtJacJ9MzmvEgs8fXDH
	 etrLVvbmwUNgEaX5z8YrRhzJvVZCejC8QgvJbDwpR0Pq58taHYAVqzlyeM0iPWWCsa
	 lS6FjZ4cu4suY6TdUjpSeEypyD2+M1UI2QyRzDk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 055/699] ALSA: usb-audio: Propagate errors in scarlett_ctl_enum_put()
Date: Tue, 21 Jul 2026 17:16:54 +0200
Message-ID: <20260721152356.950740289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

commit 0f25cf1f02e3dba626791d949c759a48c0a44996 upstream.

scarlett_ctl_enum_put() ignores the return value from
snd_usb_set_cur_mix_value() and reports success whenever the
requested enum value differs from the current one.

If the SET_CUR request fails, the callback still returns success even
though neither the hardware state nor the cached mixer value changed.

Fixes: 76b188c4b370 ("ALSA: usb-audio: Scarlett mixer interface for 6i6, 18i6, 18i8 and 18i20")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260419-usb-write-error-propagation-v1-2-5a3bd4a673ae@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_scarlett.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/usb/mixer_scarlett.c
+++ b/sound/usb/mixer_scarlett.c
@@ -438,7 +438,9 @@ static int scarlett_ctl_enum_put(struct
 	val = ucontrol->value.integer.value[0];
 	val = val + opt->start;
 	if (val != oval) {
-		snd_usb_set_cur_mix_value(elem, 0, 0, val);
+		err = snd_usb_set_cur_mix_value(elem, 0, 0, val);
+		if (err < 0)
+			return err;
 		return 1;
 	}
 	return 0;


