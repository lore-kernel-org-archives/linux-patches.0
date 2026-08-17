Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC8A3911DC;
	Mon, 17 Aug 2026 14:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977233; cv=none; b=J4zMtPflFOFeJIMQp/ZNVwGgHNTYu65msfguw5WeFJFhV2o/zhLitemeNTPzKAGvjuvhiPX5CLitCrSF3lsKCMfv3HQORKsYcytVCnMkmwa9pE+6kAQAx4u5W0Twch8W1hTFiCDNEZFLEC/fbYiNv382iV7t2CbRLVmQZkC8R34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977233; c=relaxed/simple;
	bh=mOi1FsUzh3qjfzyoBxSufgAP7K6QCsLmgMuSCcQJFac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIg/vBekyQBAVM8XjcZ2o4inYrmnSK1Ao6kc4S0EMON0BggFuuP3mIVtmmiMXPqQVtN1doU7XKpedqjRJeSXO5NzZ8oPCaLt29A6bgz9zgleNYonAU2MaCsUIAMbTB3daVskI6tCmvARiRUBiMqSn57YLMouLzLN3f71DGwD/AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eettmLZt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eettmLZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238611F000E9;
	Mon, 17 Aug 2026 14:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977231;
	bh=vLqiGaUrW55433DkP08QCnKTMBK1gfKGaAtks2vBLXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eettmLZtM462E7hAg+mCCM88ZlOEeEbawprSYo3oWmGGqo0i1jEtAKmrC1G0LMuAD
	 C/seD4cRrUnbqUjjb6zd/UnKK/QUtkYCLqI6VhPis0PitkOAyZluvejVzunaj1GknB
	 9BDUlPOVEZ0jJVLfwE8QFn/XRBNdWNpAvtge7dls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/456] assoc_array: trim the final shortcut word using the current chunk end
Date: Mon, 17 Aug 2026 15:30:47 +0200
Message-ID: <20260817132550.087913402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit a82c8a05e86f3f84e09698f65b4515b5d04633f6 ]

assoc_array_walk() masks off the bits past shortcut->skip_to_level in the
word that contains skip_to_level, gated on
round_up(sc_level, ASSOC_ARRAY_KEY_CHUNK_SIZE) > skip_to_level.

That guard is wrong in two opposite ways:

 - When sc_level is word-aligned (every word after the first) round_up()
   is a no-op, so the guard is sc_level > skip_to_level and never fires for
   the word that holds skip_to_level.  A shortcut that spans more than one
   word and ends in the middle of its last word leaves that word untrimmed,
   and its stale high bits leak into the dissimilarity word and can steer
   the walk down the wrong descendant.

 - When sc_level is unaligned (the first word) and skip_to_level sits on
   the next chunk boundary, sc_level + CHUNK would exceed skip_to_level and
   fire the trim with shift = skip_to_level & CHUNK_MASK == 0, which clears
   the whole dissimilarity word and makes a differing shortcut compare
   equal.

Use the end of the chunk that contains sc_level instead:

	skip_to_level < round_down(sc_level, CHUNK) + CHUNK

For an aligned sc_level whose word holds skip_to_level this now fires (the
first bug); for an unaligned sc_level with skip_to_level on the following
boundary it does not, so shift is never 0 when the branch runs and the trim
never clears the whole word.

Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/20260719161505.2423935-4-michael.bommarito@gmail.com
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/assoc_array.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 70304b8f15ace..861965af48b9c 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -255,7 +255,8 @@ assoc_array_walk(const struct assoc_array *array,
 		sc_segments = shortcut->index_key[sc_level >> ASSOC_ARRAY_KEY_CHUNK_SHIFT];
 		dissimilarity = segments ^ sc_segments;
 
-		if (round_up(sc_level, ASSOC_ARRAY_KEY_CHUNK_SIZE) > shortcut->skip_to_level) {
+		if (shortcut->skip_to_level < round_down(sc_level,
+				ASSOC_ARRAY_KEY_CHUNK_SIZE) + ASSOC_ARRAY_KEY_CHUNK_SIZE) {
 			/* Trim segments that are beyond the shortcut */
 			int shift = shortcut->skip_to_level & ASSOC_ARRAY_KEY_CHUNK_MASK;
 			dissimilarity &= ~(ULONG_MAX << shift);
-- 
2.53.0



