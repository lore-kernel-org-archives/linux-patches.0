Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9535F46DFED;
	Tue, 21 Jul 2026 19:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661133; cv=none; b=taKg2GhYWMPQEK7tZYU8oIuONo4RBaDiLYnGZCEXkdZeUAlCwxC6MaiJ7J4zcBzhL8GS2NW6hgiie/N+T+xj/FekQ87csgWyXixLwGeWNqbEoqjuw0yL6rcQan8hb0ysFsToYfJY0xmcQzoRNXrq1marUIf4W3mbHvvNPZ1V7sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661133; c=relaxed/simple;
	bh=Anl8GSzp8K3J8fMu4uwm2xNudrt629a+nubZaNfu/jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1JSB5iRoq5rP/czzn5Dy3efrBm3NB3oAbY3cQQtuFhHjBxMb91vd1k5TVmCJo/qxjt6792NW+2l9QIkrjmq9jglMLVZhB22C/mA/1SFIZNYfTe8f25vkcBlnymH7s1DbkOW3auNI259rFO9Nttcl6w92mmeJb0q5cXa/UA6SMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKLNNvbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKLNNvbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082F71F000E9;
	Tue, 21 Jul 2026 19:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661132;
	bh=YgujZmPZ2tlKcqA2fpAeZyJHKWrT7ZSDDNbx0H1KWM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKLNNvbr+k9Mtdxyr/Udf/pPCTnvUBIOgjwZ0mHENWPLx1bCQkenCLe9vgDk0eh4U
	 1rhTDLcvmaT1zoRVjPwLt9wHEsqN/BhsQJqODHzyppEMWQtHHsYq6xYvu6TA3awMY8
	 /oEVoSW5X2gKOsns1LzAjTxB8ZPrFDBRPzCqkTa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1241/2077] ASoC: SDCA: Validate written enum value in ge_put_enum_double()
Date: Tue, 21 Jul 2026 17:15:14 +0200
Message-ID: <20260721152622.083742759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 1ce42a11bed134903e352010a01fa53073a6b395 ]

ge_put_enum_double() passes the user-supplied enumeration index
item[0] to snd_soc_enum_item_to_val() without checking it against the
number of items in the enum:

	ret = snd_soc_enum_item_to_val(e, item[0]);

snd_soc_enum_item_to_val() indexes the heap-allocated e->values[] array
with that index (e->values is set from a devm_kcalloc() of e->items
entries), so a control write with an out-of-range item[0] reads past the
end of the values buffer.  The bounds check in
snd_soc_dapm_put_enum_double() only runs afterwards, so it does not
prevent the read here.

Reject an out-of-range item before using it, matching the other enum put
handlers.

This issue was pointed out by the Sashiko AI review bot while reviewing a
related enum-validation series:
https://lore.kernel.org/all/20260609125735.CEB651F00893@smtp.kernel.org/

Fixes: 812ff1baa764 ("ASoC: SDCA: Limit values user can write to Selected Mode")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260623110526.813217-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_asoc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sdca/sdca_asoc.c b/sound/soc/sdca/sdca_asoc.c
index 2bfc8e5aee31d9..243b83bb2bcf32 100644
--- a/sound/soc/sdca/sdca_asoc.c
+++ b/sound/soc/sdca/sdca_asoc.c
@@ -160,6 +160,9 @@ static int ge_put_enum_double(struct snd_kcontrol *kcontrol,
 	unsigned int reg = e->reg;
 	int ret;
 
+	if (item[0] >= e->items)
+		return -EINVAL;
+
 	reg &= ~SDW_SDCA_CTL_CSEL(0x3F);
 	reg |= SDW_SDCA_CTL_CSEL(SDCA_CTL_GE_DETECTED_MODE);
 
-- 
2.53.0



