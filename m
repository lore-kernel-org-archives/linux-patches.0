Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062404;
	b=Sl5j52gWIX3D2An36nJPKheuHXuAy9nyvi+pXiOlbEnPLapcFSp7/WXauN/Mjs3/yJCp
	 K/Pquh654An8NCISoHDf5a0Ldtm1fdT5V76AM0g8bGpMpeQqYBmXOqEw31so5HNA1eic9
	 ESYyeF0iwfZR4CnRAJsXEQGJ1+jGB/rfaVV2cNp64pl862exj5o8Wiv1OpWRHHJKvEXuw
	 0fLEIcRQ2qxdJYNWX7vvVXrrI3fTBDrpr8PKjwOBaVxY7WH2ek9LzZjBLqpGa13cTeNKH
	 FhC/+Db+oqPtfQ2SeYICOgKGvQS+GRDTduluEve9JN+iU1mbAV2BhjumChu2pfuWomA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0FYXnAXbCX6sqNFIfmQWi7BP0paUEPD3V4EQCD5mWHs=;
	b=Wh0NKRZjo5TSDSK/1gxXmmqzfxxsBLSH2Ax1kbKCpZzekkR3PIdaGzBmCkG3gv2nwC2X
	 rduAJu9WJaig1XKf8M6oX52za7M52kpabUIoY8RcnOnJyZZCpD5xaQaFQdnVFJJVRn/gc
	 HgydyUQS/8Kr0lsbKbSB/KohoWo6ZIXBWj2gMbkPNTRsiKtM3QQfeeuxy4XojGr7+fciZ
	 vaCeFwBrNwvZ9vgDJpJ7Z4oTuEjzJ5W9tkeUvgi6G8hpROiiZK8gjQJjrtTw0eRncKS40
	 KlQQ6KtbUEmY+dSDWrcoVWaXYXR8iZdldenePhYhj20ePBsP5o7lZARZdh4aFY1fLQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bbo860T0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46E4606EE96;
	Sat,  7 Nov 2026 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bbo860T0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798C91F008A1;
	Sat,  7 Nov 2026 14:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062403;
	bh=0FYXnAXbCX6sqNFIfmQWi7BP0paUEPD3V4EQCD5mWHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bbo860T0+aQx1pK2g7jR7z9BE4EUwXcQhoYyZLnTX1ulVw4trL7CEwmaARpqXEzxM
	 IkG71WNiXeBLtKi1iWYoW5hCHhm8LXkxKKM9ahgbq9dONfKoITBSzAMUa3lAkAOX1d
	 Q256gUMH/edOvIMdkBopsiMBWuQG/Zn8ShYgtAHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1282/1536] lib: decompress_bunzip2: fix integer overflow in run-length decoding
Date: Sat,  7 Nov 2026 08:54:58 -0500
Message-ID: <20261107135033.788739796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aamir Ahmed <elb12345@hotmail.co.uk>

[ Upstream commit b822ad8d702df0be9fe3f24f71caeb0522d72319 ]

The RUNA/RUNB decoder in get_next_block() accumulates a run length into
the signed int t with no bound.  runPos doubles per symbol, so t grows as
at least 2^n-1 and reaches INT_MAX after 31 RUNA symbols.  The guard that
follows, dbufCount+t >= dbufSize, is itself a signed addition, and as the
kernel builds with -fno-strict-overflow it wraps negative once dbufCount
is nonzero, so the guard is skipped.  while (t--) dbuf[dbufCount++] = uc
then writes INT_MAX entries into a buffer holding at most 900000.  One
literal symbol ahead of the run is enough to make dbufCount nonzero.

Bound t to the block size as it is accumulated.  t only grows within a
run, so the value tested never exceeds the final run length; any stream
that decodes today satisfies dbufCount+t < dbufSize at the flush, hence t
< dbufSize throughout, and no such stream is rejected.  Because t grows as
at least 2^n-1 the bound trips by the 20th symbol, leaving runPos at most
2^19, so the following runPos <<= 1 cannot overflow either.

Link: https://lore.kernel.org/AS8P251MB00010FE5E38D253CF98A652AC8B92@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/decompress_bunzip2.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 4f98cdea7e0b3..b8fb40ed06d22 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -428,6 +428,10 @@ static int INIT get_next_block(struct bunzip_data *bd)
 			t += (runPos << nextSym);
 			/* +runPos if RUNA; +2*runPos if RUNB */
 
+			/* Bound the run so t and runPos cannot overflow. */
+			if (t >= dbufSize)
+				return RETVAL_DATA_ERROR;
+
 			runPos <<= 1;
 			continue;
 		}
-- 
2.53.0



