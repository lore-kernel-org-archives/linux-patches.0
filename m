Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9821B2DC321;
	Sat, 12 Sep 2026 15:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226502; cv=none; b=mnv0SNysrVkRYOWYmpCYMKtICUtTEYP88b9nZXcpot3k0OIk2TNCgqnmql1wlVnNXeLjHpWnTu0CWUL1TlWZgAms1CRiiowKdPVNkvH8+FKZGiv2kAZhT924KK/rjVvyRK5K5GnH5/fuV/cM0glriz7hEIta1P6/dF0qISU2eUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226502; c=relaxed/simple;
	bh=DBaKR8Teh+FjFfzVL9tUjSBim7gqfEFNbJMvuNq8cTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/3paprruCbcnJufQqqYtwl3wEN2dP0fGw26na6LHnycET7IhWjpbcycI+c1pe1ltK1gvm54Q8IsliMNTHjxXBCIKOpBuacy4ulFlNllIMVgerHSrJyrSGLK6YQ511V0Kud+e0V4s2xwRgKTYSRz21Lv5uz5t9dNbfY5GqIWsFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slUq2VeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slUq2VeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4BC1F000FF;
	Sat, 12 Sep 2026 15:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226501;
	bh=sLEhuB4S+SzgOhN+ZC36GeEe5CbZzpc3PQu2Wo/1czY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=slUq2VeUNpZJJ222NZHIiF3fVKXFHdV7npbKbay0nyoJaGJGT80NVbO1gMQJG32YO
	 GHwCpCM3kRvwCZc3rVGycnsYASY4d0jRPMVSk4Qu2iSJ2/fXW+l27LqkX5oSZIstQo
	 9w/BTt/s/FEzLM4iHH2pxVvoPIPVEsu7GjA7rwlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1372/1424] ASoC: dapm: Fix off-by-one check on the second enum channel
Date: Sat, 12 Sep 2026 09:03:24 +0200
Message-ID: <20260912065637.986178356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 14511c9b54ceeeef487409d73947c89ee8563590 ]

The snd_soc_dapm_put_enum_double() rejects item[0] once it reaches
e->items, but it lets item[1] be equal to it.  Both go on to
snd_soc_enum_item_to_val(), which indexes e->values with no bound of
its own, so an enum with a value table reads one element past the end.

The indexing arrived with the MUX consolidation, which relaxed the
item[1] check in the same hunk.  The value MUX handler it deleted used
>= there, and the snd_soc_put_enum_double() in soc-ops.c still does.

Only adav80x pairs a value table with two shifts, and its second
channel looks accidental, but the control does report two values.
Writing three into it reads off the end of adav80x_mux_values.  The
core catches that only under CONFIG_SND_CTL_INPUT_VALIDATION, which
defaults off.

Fixes: 3727b4968453 ("ASoC: dapm: Consolidate MUXs and value MUXs")
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260825125745.932832-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index 7facb7b2dba19..e28cb3c0e14f0 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3525,7 +3525,7 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 	val = snd_soc_enum_item_to_val(e, item[0]) << e->shift_l;
 	mask = e->mask << e->shift_l;
 	if (e->shift_l != e->shift_r) {
-		if (item[1] > e->items)
+		if (item[1] >= e->items)
 			return -EINVAL;
 		val |= snd_soc_enum_item_to_val(e, item[1]) << e->shift_r;
 		mask |= e->mask << e->shift_r;
-- 
2.53.0



