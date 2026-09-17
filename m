Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC55E4C10E8;
	Thu, 17 Sep 2026 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660110; cv=none; b=WtsKAAKnbebB0tuJO0hJIlJp30/vqw2K82BRoYXzjCmxfpYM3mF5IjTOPK878q6GISs6lf/u29DEGdhHAPlKEUgMr9gv63HHXOwQPEegHdq9Qsbn6tP5ud+Oano64toRZmDFXYtLc6sbIF2oaaWcUyrjzfh38rNh2hYfXKKGjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660110; c=relaxed/simple;
	bh=c9UTo42lbiN8EkiTMY9psEx+htdATRjdFYnSdufVVns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzubwuZMDSvU1VzRy/rYowC6PvUKUHBU+Z9R7zQlw9v9yFNbsZ6z7l72+eWVcZZJAqPCFTLtXkbYQ6ItEpQ2fQsT2S5z3Sb4w+mdgxDXexbiiz69kqRluWOTW7AR9l7Yc+HiQdfCD5X5EoVv4OHzfYvcFDIzyGLpCMULkwS7j/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3QWJ8w8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3QWJ8w8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01361F0089A;
	Thu, 17 Sep 2026 15:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660103;
	bh=ppRi/MqXj3bB8FxgkZZSGNdttrATllyRqi4VVIOqveg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3QWJ8w8IYbmWO7TTFGmTw1DrMD9doSBsxmLmsbSeyU1QWDz9GYi2mVohuUzSrb94
	 dik7Xj+Z4O6BWXVmvTk8LAUnsbREpscxMNrGlpQcAQbb7Pms43NghXTT8vCRM3KWmY
	 z7y2SxfK8HG03f9BBDmrnTnEvIgzwwExl8WD4uYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Prucha <zorgan.roman@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 480/733] ALSA: ctxfi: Fix CA20K2 S/PDIF passthrough
Date: Thu, 17 Sep 2026 16:13:08 +0100
Message-ID: <20260917151403.977960043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Prucha <zorgan.roman@gmail.com>

commit b26a7a80e6bbf8dd17dacb127d12435d79375cf2 upstream.

dao_rsc_init() encodes the DAIO configuration as

    conf = (desc->msr & 0x7) | (desc->passthru << 3);

S/PDIF passthrough uses msr=1 and passthru=1, resulting in
conf=9.

daio_mgr_dao_init() masks conf with 0xf, but handles only values
1, 2, 4 and 8 when programming ATXCTL_NUC. As a result, conf=9
falls through to the default case and leaves NUC at its previous
setting.

On a Creative X-Fi Titanium HD SB1270 (CA20K2), this breaks AC3
IEC61937 passthrough when snd_ctxfi runs with
reference_rate=48000,multiple=2. The receiver detects a non-audio
stream but cannot decode the AC3 payload.

With the unmodified driver, multiple=1 makes the same stream work.
Handle conf=9 through the same NUC=0 path as conf=1.

The change was runtime tested on the SB1270 with multiple=2 using
IEC958 stereo PCM, pre-encoded AC3 IEC61937 passthrough and ALSA
A52 live 5.1 encoding.

Fixes: 26a9630c72eb ("ALSA: ctxfi: cthw20k2: fix mask on conf to allow 4 bits")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Roman Prucha <zorgan.roman@gmail.com>
Link: https://patch.msgid.link/20260903-ctxfi-spdif-conf9-fix-v1-1-5e4e3e1f801c@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/cthw20k2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -994,6 +994,7 @@ static int daio_mgr_dao_init(struct hw *
 		/* S/PDIF output */
 		switch ((conf & 0xf)) {
 		case 1:
+		case 9:
 			set_field(&ctl->txctl[idx], ATXCTL_NUC, 0);
 			break;
 		case 2:


