Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041109;
	b=uhlAUu4lmE16cwfxvODIBsnpwaOBGovZFw70wLlCvKfsz5mYTf+z6jgc86G+HnJfeBXp
	 wvvpHQQS3KcswbLDWGHa4y9yTJtjkr8AHVaiBkEeH6Vdwh4uh5zydq2xwbrtxfyNHK9FX
	 kFyRbTU9hfGYm65bEWGP0lz9kaV71sOdRDg+RIR1QxdhBAEs2A+cL21lDelpCiPinA/Rz
	 wARK83DVY9Sk8xvmjeYdeU88skckkL5cfzK1m6fHXNt+DNTe311r4XNSuOoyvOlP0NjB+
	 mtYU4++vtQIZMKlw1t2xYRbRivjJ7XTvMR1Z/69pTt1mCbFY7piQx079u2PpMEAFLQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rtyRNuWDr4FGGHeP3I5June7THD+fA+ROAuxPI3AbGc=;
	b=mWMqP7bATOX9FTY79IIvPE2g+19bAaf351mOc0c8PM0MMaivN6vfG2cWG5Q/lwZCg6Ee
	 bybjnrEOhdzUre8ziEa9M1PyZJBkl3TBFS4z7dHtm24UBvEGSigexzh8kFMlkjnVmhwjS
	 658Ue8cbLvIIoK3q9/HONFUXoFRiRWnAqYTbR0227IpUu2lXWcxtXQpT36ce7R9FVEZAh
	 MsA/ZMuPYcmFq+e8+TLweAfopnrUkAEgYG0gzlKrQvoTRdPKMsCOxF8l04rmSZXBLhMz8
	 pwYXZgCzda2sM6BazRYBezDPxrLxXDQChNmw/42US4gk8wZ46TyCc0rUKj6BCbw+PvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zm5F/iZl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302BC606A320;
	Wed, 18 Nov 2026 22:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zm5F/iZl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE491F000C4;
	Wed, 18 Nov 2026 22:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041109;
	bh=rtyRNuWDr4FGGHeP3I5June7THD+fA+ROAuxPI3AbGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zm5F/iZlgtobb0CHwPYwiTC+jHI830THJRt7yifw2L3z+zha8hJCtV8idKkPshyLz
	 7ccQJ95F/ndnMdGb2A7cB/vohpIeKKPgrYrHp3kXIKcbLeaum7MUvOQknuZ05vJi6w
	 psSNqCyouxJp3RVnbZrhLmdvr0YhuotO3SAcznOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2696/3318] ALSA: hda: Avoid non-operational GPU warning at regular device removal
Date: Wed, 18 Nov 2026 15:55:18 +0100
Message-ID: <20261118150441.812174333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 3af4ed9f927c469f23d03a76e3b438ed09715bd3 ]

When a hda-intel driver is removed manually and it has a GPU with
switcheroo, it always gives a warning like "GPU sound probed, but not
operational:..." no matter whether GPU has been actually operational
or not.  This warning was originally put for machines that really
suffer from the non-operational GPU HDMI audio, but it's seen at the
common path a normal device removal also goes over.

For avoiding a confusing warning, move the check and the warning at
the error path of azx_probe_continue() that is the point where the
non-functional GPU gets detected and given up.

Fixes: 2b360ba9a493 ("ALSA: hda: intel: Fix Optimus when GPU has no sound")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007171231.8147-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index c96253e591f21..553f23133e145 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1374,7 +1374,6 @@ static void azx_free(struct azx *chip)
 			 * actually stop the chip) to allow GPU to suspend via
 			 * vga_switcheroo, and print a warning.
 			 */
-			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 			pm_runtime_disable(&pci->dev);
 			pm_runtime_set_suspended(&pci->dev);
 			pm_runtime_enable(&pci->dev);
@@ -2418,6 +2417,8 @@ static int azx_probe_continue(struct azx *chip)
 out_free:
 	if (err < 0) {
 		pci_set_drvdata(pci, NULL);
+		if (hda->vga_switcheroo_registered)
+			dev_warn(&pci->dev, "GPU sound probed, but not operational: please add a quirk to driver_denylist\n");
 		snd_card_free(chip->card);
 		return err;
 	}
-- 
2.53.0



