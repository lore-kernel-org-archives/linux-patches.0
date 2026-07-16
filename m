Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF76400982;
	Thu, 16 Jul 2026 14:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211796; cv=none; b=HMYEyKahImcFIYns+U3MFFn6CO1du34oGWPGIKGYNAtd4o18r0VytIpsos4ozK4BPPB2KvAMy0Efm4wqIiSCIE/za9PICB1tcD1pK5F2ZAyAA04dVBlc83XUEDblvDQd+FFh007oCjyqrSzsWIkDMOxesMWTfj6rlkrMhWwN8cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211796; c=relaxed/simple;
	bh=JF57TYeM7S4uf/sYo6CDl1v26zOcPuIU9cPUZaGRtbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/E4Z4a0cnamXDPyPjugslFjqslQShDEcnc2wUcDe7xujFzQ8FKfyM68AsIHlHEzO1vArbLbtu3QJVDdzLp0vsDAClrVPfRbd7sSln++G26dysrJOuFmRzXDEP3gfWadxFP7GC5FXyB2jriOA4di8FYHyTBcNs7RO3NRZ5iYLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFDtEqau; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFDtEqau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FBE1F000E9;
	Thu, 16 Jul 2026 14:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211795;
	bh=qsQQtjKvaJWl/+uIWfQ5S3ttoya8HLoRBFHI9+gxTFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFDtEqauj3NYCfJ3P2UVUXQaqlrD0xQwLDMxhFPeKm+4cOdLDTeFqOe5xEoEg8/QB
	 JyecFPY5FFB2ES4GZwXn9YFJB1Lx9riqxaRu6P3WlYw31BeQV7Gk3Z2BqcwwCcg2GZ
	 4oj9J9FHsl5fy6X92RZ3Dccjen+tvRN+fUz5ZkJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 082/349] ALSA: usb-audio: Propagate errors in scarlett_ctl_enum_put()
Date: Thu, 16 Jul 2026 15:30:16 +0200
Message-ID: <20260716133035.151145217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


