Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467F41F2B88;
	Tue, 25 Aug 2026 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666332; cv=none; b=WCIWcBlszJSKJ2+zN+K5TUL6ho3t7XF+wHUkoq23d+M2pC6b+6hgF5J8cLM8S/T8ir80q1lmQfSOfaxZTJUBLwbv335+X+apk5tUtV5Zy9aWQJAhE1/zXYgGdAsaktEVaIyHtY932qXkJbMehqmrUMrtwtal2iiTwoupCWyBBQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666332; c=relaxed/simple;
	bh=SrWD5DPj0q/cpf0sXutT0vx64/8+E29KuG8d9RYnuQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qodNuSBUn/b3CYnVenYfJ0mKDveu/0sQcYmLv5KYExmZ4xQEShkhraR0WvhraNCPO3fxz5TOt26ppw9v/AAJRhhokAwB/TOjDurhJErxatbi8TplAMRDmB58QJG//xPr3aJvI1PZt31QJuYix21tPTZVI+wKRffkzDceqI/UXnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t48+hpZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t48+hpZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9990D1F00A3A;
	Tue, 25 Aug 2026 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666331;
	bh=UHU9uPhjNASxb+OLi8odgjFEgDa7D22O2DDHYp/ZD8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t48+hpZ/9+b+BaesOYBffL43ChZSlPgmZ+eLGXHoVzG0YlQrpRN2YPKQsLa9q2E0X
	 J8llMutnPwzITZbu9in1NtTSVZPRroIVVd1HA2OYuOnB6cSnDbEY2MUPzPz1adRBeI
	 17RF06mLdgQ41nyBJk+aYdpvUFcIWYXjH5yHuB2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/76] ASoC: codecs: lpass-tx-macro: Fix enum kcontrol accesses
Date: Tue, 25 Aug 2026 15:26:43 +0200
Message-ID: <20260825132543.536274028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Wróbel <me@dawidwrobel.com>

[ Upstream commit 1ba381759e45d5d0442452cfa5c42e836191a568 ]

The "DEC0 MODE" to "DEC7 MODE" controls are enumerated, but
tx_macro_dec_mode_get() and tx_macro_dec_mode_put() access their
value through ucontrol->value.integer.value[0] (a long) instead of
ucontrol->value.enumerated.item[0] (an unsigned int).

This same pattern was fixed in the sibling drivers by
commit bcfe5f76cc40 ("ASoC: codecs: rx-macro: fix accessing array
out of bounds for enum type") and
commit 0ea5eff7c606 ("ASoC: codecs: va-macro: fix accessing array
out of bounds for enum type"), but tx-macro was missed.

On 64-bit kernels built with CONFIG_SND_CTL_DEBUG, the elem value
sanity check catches the 4 bytes written past the enumerated item
and every read of these controls fails with -EINVAL:

  snd-sm8250 sound: control 2:0:0:DEC0 MODE:0: access overflow

Fixes: c39667ddcfc5 ("ASoC: codecs: lpass-tx-macro: add support for lpass tx macro")
Assisted-by: Claude:claude-fable-5
Cc: stable@vger.kernel.org
Signed-off-by: Dawid Wróbel <me@dawidwrobel.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260730-worktree-lpass-tx-macro-enum-fix-v2-1-6d091c736116@dawidwrobel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kept `snd_soc_kcontrol_component()` context line instead of upstream's renamed `snd_kcontrol_chip()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-tx-macro.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1013,7 +1013,7 @@ static int tx_macro_dec_mode_get(struct
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 
-	ucontrol->value.integer.value[0] = tx->dec_mode[path];
+	ucontrol->value.enumerated.item[0] = tx->dec_mode[path];
 
 	return 0;
 }
@@ -1022,7 +1022,7 @@ static int tx_macro_dec_mode_put(struct
 				 struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
-	int value = ucontrol->value.integer.value[0];
+	int value = ucontrol->value.enumerated.item[0];
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);


