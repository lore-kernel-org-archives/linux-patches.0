Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C51141A8F;
	Sat, 30 May 2026 18:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166087; cv=none; b=Z84BjWgcgbnGYDZJO8VVF9mlAb3ydxRnbBtLszTply9uaJbrn6CuGUj0l8lAvxsBgturCkZabKC7cVwVKrvsM16oGPYz0QQYd9aURjvfpqPkxQmy5j/aJtCE8ohuF4mo/kAA7vYb9RT2H3rHzs6LYRYLu5enASEcWaYg5LvhEh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166087; c=relaxed/simple;
	bh=/XC4FOLilSJyvWy2wafLsBv68zUFSr91fBEaABJprgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwOUvuSzMYho+NIVotU1zOxgStJnZPvpi6e+LvwnoiMJXfOewanF+828N34ahMe9igBu1wQpo05WJiN4tBua+JfBpEhbZA+FPOIG2IkiRYUpkTIb6trFPDMWvOxPJ10IFfsJDBMncAoUcP9LdCaDCtt0OPbHYyBUrXUPfgPcLiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUYk8T8q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUYk8T8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD25F1F00893;
	Sat, 30 May 2026 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166085;
	bh=PQCU8bIkAmTA0/R1ZZ74NqqKkARJQgTjbPKf9ztwgYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUYk8T8q33Jjq4g3f+Rs3+xbYBW5jMxoigzuKZuR9oMi2g7CSqK+DTlWv7pp77Fxs
	 q/zYpn+okxzoErQxPWR4ZZCKjRf9WdgiQd92rqBRrSlpTfFAl3J+LCYrO4fGAExhcg
	 cJFTowtX/0lH248gRDuDOAyuRAux6MayolYcq4ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 269/589] media: dib8000: avoid division by 0 in dib8000_set_dds()
Date: Sat, 30 May 2026 18:02:30 +0200
Message-ID: <20260530160232.056544331@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

commit dde3c37af95cd6fa301c4906f33d627bc9dd874c upstream.

In dib8000_set_dds(), 1 << 26 (67108864) divided by e.g. 1 apparently can't
fit into 16-bit variable unit_khz_dds_val, being truncated to 0; this will
cause division by 0 while calling dprintk() with debugging enabled (via the
module parameter).  Use s32 instead of s16 to declare the variable, getting
rid of the cast to u16 in the *else* branch as well...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: 173a64cb3fcf ("[media] dib8000: enhancement")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/dib8000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2694,7 +2694,7 @@ static void dib8000_viterbi_state(struct
 
 static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 {
-	s16 unit_khz_dds_val;
+	s32 unit_khz_dds_val;
 	u32 abs_offset_khz = abs(offset_khz);
 	u32 dds = state->cfg.pll->ifreq & 0x1ffffff;
 	u8 invert = !!(state->cfg.pll->ifreq & (1 << 25));
@@ -2715,7 +2715,7 @@ static void dib8000_set_dds(struct dib80
 			dds = (1<<26) - dds;
 	} else {
 		ratio = 2;
-		unit_khz_dds_val = (u16) (67108864 / state->cfg.pll->internal);
+		unit_khz_dds_val = 67108864 / state->cfg.pll->internal;
 
 		if (offset_khz < 0)
 			unit_khz_dds_val *= -1;


