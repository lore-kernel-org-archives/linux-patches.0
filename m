Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C7F4F5DF0;
	Thu, 17 Sep 2026 16:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664358; cv=none; b=Dx8uQ5DneW9Mklbe5RHaK3vBOcwHRYscD76eG5jcoXJe6pyT8osRE1R7ryjIK7LjUUCdmVArueIrLRifFC7N4/g+z/o9+E6Y6kNI3UScTlpWfqIPVYEoTiL1CUu1C2KzF0M3EnIblBlparP5w/BsU1A1yIOyp/3vcoexoz+JdIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664358; c=relaxed/simple;
	bh=GU7DGnwBWBpDqs2DhhQFaxisUmR3C3mVmq+9MlLr8Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJl/YRbQs42UxJI3Zv+/6mIN0yvoVhi+0v+Hun9EHizaVsY3Fbjq0OYYxiwKtx4I90owm7TvEvgHOGY0tw12YU5KcB3PyzEYrWQVKhnGYws6zCAOXU5/p6jlpcghA9iUs+6qV/wJtlS6uxVAn7llXcGYa3GNyF3cTCpG36wl87o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bSFXeWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bSFXeWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671931F000FF;
	Thu, 17 Sep 2026 16:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664357;
	bh=YUFW3g6DhZHaaovpfQeOOF1970vsCaobhgxqJL3X9u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bSFXeWJ7pBjd0BCZYhN8ZEmAmfWl/pMLNba0EsBACAwyFd4lliw4VK0m39UoBcyb
	 Ksr1vezsufnH6NQKHwSXu02cfZHF98zqRVtnxNsWtD+XxVLyrf9StVI6R3008YM3s1
	 /7d3WhnPTBx8FfYyh22XVWjwhhLBSe9il6wYbyKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0346/1250] ALSA: es18xx: check control allocation before private data setup
Date: Thu, 17 Sep 2026 16:02:21 +0100
Message-ID: <20260917151601.451101742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 422e42b7c2b882ba1d16d4afc8891bcea7c4de93 ]

snd_es18xx_mixer() creates controls with snd_ctl_new1() and then stores
bookkeeping pointers or sets private_free before calling snd_ctl_add().
snd_ctl_new1() can return NULL on allocation failure, so those writes
can dereference a NULL control pointer.

Check the returned control pointers before using them and return -ENOMEM
on allocation failure.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260607074219.3-1-ruoyuw560@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/es18xx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 1da7b400a17b6..2f454f7797ce2 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1762,6 +1762,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 	for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_base_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es18xx_base_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		if (chip->caps & ES18XX_HWV) {
 			switch (idx) {
 			case 0:
@@ -1823,6 +1825,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 		for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_hw_volume_controls); idx++) {
 			struct snd_kcontrol *kctl;
 			kctl = snd_ctl_new1(&snd_es18xx_hw_volume_controls[idx], chip);
+			if (!kctl)
+				return -ENOMEM;
 			if (idx == 0)
 				chip->hw_volume = kctl;
 			else
-- 
2.53.0



