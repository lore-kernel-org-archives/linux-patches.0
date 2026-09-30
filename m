Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994A93CAA41;
	Wed, 30 Sep 2026 19:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795564; cv=none; b=HM3RvqVvU+Tvcbx2Xe3QWcXxjhcalQl1UcSP1cSzPBgullyXHJZxqOY+2j/sZUUVPpTyXVTd/HPaAnC2MEa0kRtDH4abMaIBcyp3FK3PH9aYNJmfmNzn3FZlJXg4qPy8DdPF2BQERqJT+FM1QsQOHaFxYzBmf7HEpokcY3hHmVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795564; c=relaxed/simple;
	bh=O9jxsJAGFmBYM6xiG4XdS9L0cChTZbIBquqyW+jEM1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJodHQ4dcjn5Q/Gj/1LoUvg/1taa9q9HmJwjh+j/mE1hqR01ml8nvd1YrNeICoBWtJhQ9H7dFpJ+yjkLHVhx6sdigbYLSi+Uzv03gTcTdgkdwUEmSzqyHLCqNFsWK9KSTn8KeOT7WAAz5dIgpSBV5z288PchvPd9QbZuVp9dA70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WC4VlPhq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WC4VlPhq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67721F000FF;
	Wed, 30 Sep 2026 19:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795563;
	bh=n4HauzlkWyVCRlEVm338eDxwq1jI9nKM6WfEAqO4GJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WC4VlPhqOrfm3d3g1/zE6JjOcV2ypp0EITuhacI/b4ZLf9iKeSKMWqP3ifJebqDgm
	 xqYJV1pFQ+3DoJM+ffqP3P9AINvDBaoeycFzV8VZxobEUdJvYg3/l2R5VGmfQevOBC
	 0UuUm64srhrlgUjJ9w0jl4sIshmMdKGlrDPdWgag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Prucha <zorgan.roman@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0603/1193] ALSA: ctxfi: Fix CA20K2 S/PDIF passthrough
Date: Wed, 30 Sep 2026 17:21:27 +0200
Message-ID: <20260930152447.642740134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -993,6 +993,7 @@ static int daio_mgr_dao_init(void *blk,
 		/* S/PDIF output */
 		switch ((conf & 0xf)) {
 		case 1:
+		case 9:
 			set_field(&ctl->txctl[idx], ATXCTL_NUC, 0);
 			break;
 		case 2:


