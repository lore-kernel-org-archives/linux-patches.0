Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1514238C21;
	Tue, 29 Apr 2025 17:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948096; cv=none; b=NkMZdNKNh66B+8keItuS0b9PGtZ6jlurLyBOPEzVmHWQGqMP+FrrzUt/fpbObQMUGcmn7guhjuudBKa5as3Jp28SZFOoNOrgXk16BB7qQc6+AjYFnOXXjRV7tEXEj83+vUPAC4cHNywDpFuyqjqBGihSzF2iBHrpdYypn471Q8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948096; c=relaxed/simple;
	bh=LqxktPv9FZNjiftSCJ0tnwbqhPcQWdEs5IBJ2DeMIsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxqXqBni8CGH8S/il5/mHOMMk+1vjAP0R7PgaA1rxO2XL7t2cXwg3EqrktJLDiF4qMnr+KHhvAgPKioyb17zcGnstpC+CEkGMY67Surib+EE+IAM+NMCBihFT7i6cqvcku0M1/se02WYWdxa6OsE1Q+DV0+eGuODf0ZZqmQl0ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qw0JP40/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qw0JP40/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA2AC4CEE3;
	Tue, 29 Apr 2025 17:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948096;
	bh=LqxktPv9FZNjiftSCJ0tnwbqhPcQWdEs5IBJ2DeMIsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qw0JP40/oZwGObhQT32M8HzZyYhWK7BeOO5U21xse5e3GbQs2ogS4pe93RGkTSM71
	 wQomkVPphk+W7+wY5ezPlZk1RQXl6MB7UGOmdUB18zo/n0zAhkWRlqxxoH/mXbOuX+
	 Bd03z5PvcckcHpMwig3AzOzqh5k35lr+rL2yo/wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/280] objtool, ASoC: codecs: wcd934x: Remove potential undefined behavior in wcd934x_slim_irq_handler()
Date: Tue, 29 Apr 2025 18:42:10 +0200
Message-ID: <20250429161122.837372932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 060aed9c0093b341480770457093449771cf1496 ]

If 'port_id' is negative, the shift counts in wcd934x_slim_irq_handler()
also become negative, resulting in undefined behavior due to shift out
of bounds.

If I'm reading the code correctly, that appears to be not possible, but
with KCOV enabled, Clang's range analysis isn't always able to determine
that and generates undefined behavior.

As a result the code generation isn't optimal, and undefined behavior
should be avoided regardless.  Improve code generation and remove the
undefined behavior by converting the signed variables to unsigned.

Fixes the following warning with UBSAN:

  sound/soc/codecs/snd-soc-wcd934x.o: warning: objtool: .text.wcd934x_slim_irq_handler: unexpected end of section

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Mark Brown <broonie@kernel.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/7e863839ec7301bf9c0f429a03873d44e484c31c.1742852847.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/oe-kbuild-all/202503180044.oH9gyPeg-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd934x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wcd934x.c b/sound/soc/codecs/wcd934x.c
index 910852eb9698c..c7f1b28f3b230 100644
--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -2273,7 +2273,7 @@ static irqreturn_t wcd934x_slim_irq_handler(int irq, void *data)
 {
 	struct wcd934x_codec *wcd = data;
 	unsigned long status = 0;
-	int i, j, port_id;
+	unsigned int i, j, port_id;
 	unsigned int val, int_val = 0;
 	irqreturn_t ret = IRQ_NONE;
 	bool tx;
-- 
2.39.5



