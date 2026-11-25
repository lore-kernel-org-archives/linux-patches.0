Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622801;
	b=GJgwcK+VaMpJTFLTRp+5P5fRkjzZBQ5VufuB6U15zOGixA4cqQ2IKTEpsKZe9Z4uQ1Pm
	 R/SI40aYPcZs9IEMQrcX/Jj9OrInGI+UhZLeYFmg+WwlZBlJsl4gjfNs53rXMMl3upPsp
	 xJuHdBPWMF2ZuPKYYhhjzgI0iQ237d4so7yv+bV+7t2GzC9ytz4Y2P+zH/72TaBL+mWYO
	 jdb90zSZfhia2p3Tjr6OmbpJBaUz6jEHA9YekJyaBcQbSgArw6joMReN/bBGtRy0daJQ7
	 d/DDB9cdVQH+Y0vui8tBetril1pFRAhpeJELogFQLarUCdV8PfWRQ17XQLMRSTKf5xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etpxM6YvWRhPTcAYGA8VT0R3aH/FVfdNI+PPK/SZL5E=;
	b=WusGKvJjhUyF2KOKsXQW84qXgSv6eTBMTmu6q9R3WhBAvWO5RV+1bf/2JxlScLhAUaMH
	 ElIcOsGvQJWgDwCjT6ltM0xqAgZXzwwkxbhn9E0tYw8QPbcR9qq52guIVGG2ZNqV/dn/2
	 yet2uXKB+ee044jLulGoCaCaXQc37YU1AGuEWbXPTD7JwO/XQ5VhhfVp+MdGv7iGPX/eB
	 2Rs+W56O9usETjGzbQYLFfwzSF38aRE3TdBISZVIConI3CCMSxlhE62ayUack4enw1Tor
	 yScKAZdHNCnst9BbRA79TW4dqR4nidNpr8xzQCTX5TFScHEW/xl5L2edKeYD7mwX/zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3chrtcj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B83D606A339;
	Wed, 25 Nov 2026 16:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h3chrtcj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29821F000C4;
	Wed, 25 Nov 2026 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622800;
	bh=etpxM6YvWRhPTcAYGA8VT0R3aH/FVfdNI+PPK/SZL5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h3chrtcjEKjYQu+d112zItJEu37MzybEfZoPCoeVKxiy4saYdSAqzomw9F8ri+Fqe
	 lvi3r+TsrpR4yH2XH4FQHa1zmTF1/+7bZQSCiJUSc4zzJVOgk/t5/cpYN+J0VFxBNj
	 pOolUwNca0q38t+hCH1ocma48/IoXxzv0kCU/Bqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davison <andy@dvsn.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 654/990] ALSA: hda: Fix [codec] ID matching in patch files for IDs with bit 31 set
Date: Wed, 25 Nov 2026 15:33:41 +0100
Message-ID: <20261125143837.411452896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davison <andy@dvsn.net>

commit fda103c1432f344e1cd548f346d157b1e67ee7c5 upstream.

parse_codec_mode() reads the vendor and subsystem IDs of a patch file's
[codec] line into an int, and skips the check when the value is zero or
negative, as documented. An ID with bit 31 set, such as SigmaTel's
0x8384xxxx or Intel's 0x8086xxxx, comes out negative, so it is taken as
a wildcard and the section is applied to every codec instead of the one
it names.

This was seen on an OpenPeak OpenFrame 2 with an IDT 92HD75B2X5
(0x111d7608). A patch file written for the STAC9202 (0x83847632) in the
related OpenFrame 1 was applied to it, swapping the headphone and
speaker pin configurations, so auto-mute never muted the speaker.

Read the IDs as long long, so real IDs are compared exactly. Values
written as negative numbers (e.g. -1) still act as wildcards, as
documented; a hex value such as 0xffffffff is now compared as written.

Tested on 6.18.60 on an OpenFrame 2, with a rebuilt snd-hda-codec and
the STAC9202 patch file: user_pin_configs stays empty for the IDT codec,
and the headphone and line-out pins are assigned as the BIOS sets them.
Not tested on a STAC9202 itself.

The bug was tracked down and this fix written with an AI coding
assistant (Claude Code, Claude Opus 5.5), which also ran the tests
above. I have reviewed the change and the tests.

Fixes: ef940b0403d4 ("ALSA: hda - Allow patching with any vendor/subsystem ids")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Davison <andy@dvsn.net>
Link: https://patch.msgid.link/20261106175518.18629-1-andy@dvsn.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/common/sysfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/sound/hda/common/sysfs.c
+++ b/sound/hda/common/sysfs.c
@@ -511,11 +511,12 @@ static inline int strmatch(const char *a
 static void parse_codec_mode(char *buf, struct hda_bus *bus,
 			     struct hda_codec **codecp)
 {
-	int vendorid, subid, caddr;
+	long long vendorid, subid;
+	int caddr;
 	struct hda_codec *codec;
 
 	*codecp = NULL;
-	if (sscanf(buf, "%i %i %i", &vendorid, &subid, &caddr) == 3) {
+	if (sscanf(buf, "%lli %lli %i", &vendorid, &subid, &caddr) == 3) {
 		list_for_each_codec(codec, bus) {
 			if ((vendorid <= 0 || codec->core.vendor_id == vendorid) &&
 			    (subid <= 0 || codec->core.subsystem_id == subid) &&


