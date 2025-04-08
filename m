Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6EF269880;
	Tue,  8 Apr 2025 11:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111781; cv=none; b=Au4SCmvF+H5bVil/GnxNBkiZeSs5nm0d7ygXgV82PrbKdXR0vk4Mh3F0R1skUy4OtWzr3nKrAP9cbg7gUM/CISD6u5Dpsbk31CllbCVkBECAzLrT6xuvtD1MQZFMSgypNlO1bKU9fP6IaqdD9nSxTNVHEYgiRsI2vXMTPzS0m+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111781; c=relaxed/simple;
	bh=hSocZ+IofSJmHI7EARmDe8QTiAB8TtMt4AjtIadAn+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtt+5wInYelKBv/kYxAqpGSO5jxQKrrD1UlfgbU2HaSaU9ZJMqlOh003Q86vXwEc9f4VAd6l3DuHMpg5vRdR5sSLna63Xfne4tGyK8pZCboF15sul40GnwvrTcTy2efHWMam0hWxbGZ+Ya3Zat5+TiSv58Znb/UrKZ3frRFXVak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzuR7+Fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzuR7+Fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6578CC4CEE5;
	Tue,  8 Apr 2025 11:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111780;
	bh=hSocZ+IofSJmHI7EARmDe8QTiAB8TtMt4AjtIadAn+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzuR7+FiHhvUXpgLBTnTChTakU70m3PATVUeZ3fgoM2OZs/1vIy2M2/SzY22pyZEF
	 HbitJqiSxjVQxOj5lloTZrWOm445Xc0JX1yG0/HVlgmCib+D0BN9+icMOx76nBlgi1
	 NULlEnTw4HVz+s18jjxD8kIg/xd2D1Eohym1Ytbo=
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
Subject: [PATCH 6.14 550/731] objtool, media: dib8000: Prevent divide-by-zero in dib8000_set_dds()
Date: Tue,  8 Apr 2025 12:47:27 +0200
Message-ID: <20250408104927.070279610@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



