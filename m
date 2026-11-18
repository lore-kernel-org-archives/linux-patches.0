Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056324;
	b=k1dXPsCl26z0ZlNrFZ3YHJLv+7+nt1FeGim/G8E6rsgOsDOb7UEqWbVu1zTGV6wCEzPL
	 lN8kbhT1suKo2aEWREsDRn96u0iZhYCTTYZ2WyILFpIRB0gOYUbnOQL4N9QKS7LklU4lW
	 TRYPBlgtMWDkVBY6DGJFwFNTol439w9Fhfdczb6p+9QLyQH2q2iHD0aY+rQ8ugSeEtHOU
	 0/uzshVdY14aVSEwGjkmj/1FgIyfjNkWZQX2pQtUdtD/3OowCqCLoEq0M8Ax0g4ziAd/7
	 hNuQsHuMwgPycCsymaBP6mL4busEir9uiFM2813UiDCgtfCdFqK54TxVong54Ae47sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2wNkosDq9KdkzDrA3AKL61bRH2ACsgwX+v5vq97OReQ=;
	b=YP4dNb2Lu3CQPZ1bfeKMYjKAlES6luF4g7j/pKbEBmAfDAqZF3Q2QR4sW+VhxeZazdzU
	 svbG5v4+ty2ZCAwHvyuOA5UbEeY/KnpCQtu36iTX67t/exuEsm5qI107jTBlBDrSMc7Vb
	 lNj1mFoVfa/T7tULmY2O4JOrcfm7oP05MX49C1l01Bwxuo0vlvpv3k5WFSM3TvS5u9qjv
	 JZkWwP40H2d4GDgW2grPcUw8cq304C+KQEMLtj2MzTCWgb43+D78dflV2W8Is5Jlw5DPE
	 sN5mLI/QDTZAUnoPQSZ+bIH+KQSb2qS4gECQrfudZ/+rSHVkgRzrtxCaFSLjBFhFxeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mn1isMQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB378606A320;
	Thu, 19 Nov 2026 02:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mn1isMQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F36F1F000C4;
	Thu, 19 Nov 2026 02:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056324;
	bh=2wNkosDq9KdkzDrA3AKL61bRH2ACsgwX+v5vq97OReQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mn1isMQ6crO8VI5sQ01E879/DS777nxlC9uHIvXOB2FUzIqSxtKQ4MdLwID5Hchl8
	 Nzb6XLiSJy05UV2X9Bm9iKs3DIDa8iug1OSdEKwYhxhsOkXZJjzGNrlB86lyZYx3zN
	 GLnvuhi2/a/QJUt/EEaCFjMtFB0ca1GgV5jh9GU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1904/2214] ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118150127.300133836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f421be924fec67f74bb0b6988ea8f0a3480df2a7 ]

When an error happens in snd_jack_kctl_new(), it tries to free the new
kcontrol element via snd_ctl_free_one().  But snd_ctl_free_one()
releases only the memories, and the internal linked list and hash
entries still remain, which may lead to bogus accesses to user.

Replace with the correct destructor, snd_ctl_remove(), for clearing
the whole resources of the given kcontrol, instead.

Fixes: 9058cbe1eed2 ("ALSA: jack: implement kctl creating for jack devices")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261013120528.52586-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/jack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/jack.c b/sound/core/jack.c
index 03d155ed362b4..304082c44c8be 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -452,7 +452,7 @@ static struct snd_jack_kctl * snd_jack_kctl_new(struct snd_card *card, const cha
 
 	return jack_kctl;
 error:
-	snd_ctl_free_one(kctl);
+	snd_ctl_remove(card, kctl);
 	return NULL;
 }
 
-- 
2.53.0



