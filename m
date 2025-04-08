Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3CA270EBD;
	Tue,  8 Apr 2025 12:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116673; cv=none; b=qftBhK+2ei4bW0oDzmeh3tFq9Vw163cNfXgRPdciyc+yVpBp5gk5USguTgamWPKenZNXGiBLOBA3xEnl3OgGJ70mr1Be3sEb4jbT675isEmK4Rgkw8M2bdgfJwoar44FI0PrES3gJ83P/suiA9v0t0N0L8Zc6+r6ZkJy0EtVGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116673; c=relaxed/simple;
	bh=O3xOzEPkXutP9o+Sb/4+wIfCsJIkW90eMUtOronfqEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAfjwAoEYeJXuhZ9BxXtKIiBi6xmTK8yxvppacY9nhTCmAn1y/zEIdrOidQKPloX1kEXWX23PhLMa0I/P0sXoid939X7NUjHlIV4//ARUoukqWT7ART3a/iOh7H3hX83Ioko1ZBCtsljka7rjXxKkRxgNOHr/ufqmoeFiEgBL7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qsyw0NcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qsyw0NcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96073C4CEE5;
	Tue,  8 Apr 2025 12:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116672;
	bh=O3xOzEPkXutP9o+Sb/4+wIfCsJIkW90eMUtOronfqEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qsyw0NcPXuCN3zDF9o2+vO0X1Wcyy8Lc2fkrA8m3mGN3SiiKSRUktu0mnXnTTBpnQ
	 FT937A8mOpMNS5dSQoZ2wD5JbQzq5iBatYyUbzHHodHMgrDBE3BV8JJIoyYhx7xv9p
	 xvT/CERz0xPAfUpthF3u8tMu4yws+YfMMx+uahxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 227/423] objtool, media: dib8000: Prevent divide-by-zero in dib8000_set_dds()
Date: Tue,  8 Apr 2025 12:49:13 +0200
Message-ID: <20250408104851.013898206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

[ Upstream commit e63d465f59011dede0a0f1d21718b59a64c3ff5c ]

If dib8000_set_dds()'s call to dib8000_read32() returns zero, the result
is a divide-by-zero.  Prevent that from happening.

Fixes the following warning with an UBSAN kernel:

  drivers/media/dvb-frontends/dib8000.o: warning: objtool: dib8000_tune() falls through to next function dib8096p_cfg_DibRx()

Fixes: 173a64cb3fcf ("[media] dib8000: enhancement")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/bd1d504d930ae3f073b1e071bcf62cae7708773c.1742852847.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/r/202503210602.fvH5DO1i-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib8000.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 2f5165918163d..cfe59c3255f70 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -2701,8 +2701,11 @@ static void dib8000_set_dds(struct dib8000_state *state, s32 offset_khz)
 	u8 ratio;
 
 	if (state->revision == 0x8090) {
+		u32 internal = dib8000_read32(state, 23) / 1000;
+
 		ratio = 4;
-		unit_khz_dds_val = (1<<26) / (dib8000_read32(state, 23) / 1000);
+
+		unit_khz_dds_val = (1<<26) / (internal ?: 1);
 		if (offset_khz < 0)
 			dds = (1 << 26) - (abs_offset_khz * unit_khz_dds_val);
 		else
-- 
2.39.5



