Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031383;
	b=ptrcnUIPWKg0t4hNzFNPGlwW5UDZCCpFD+ca1TE7Uv7lKgIBurE+pVQQnQ7gGxO1fljh
	 rS2xe8tE6yhnJKlya3feZJ9+MjMkH83jeOa/OkABktlK6xqqRmuj+Fp3oH/0cnMRBm4UJ
	 SC+V1/bFzTXfbFHYReN8gtNW8j80liUSDwJyaSxR0ZuJCIDhVsGJophdi4WroBK7v0OH3
	 jEGyvgdr5xhZPv/sWyZswim+vXGhpLJ5LOggGvmpi9aDq9MDDni+mFaS+qvI26eagKGiS
	 bRhueL+NG/zwjW7Sp9CgcRIEjVr9XxLN0KAowszFZ7WCKx2qHUtBlowQfolaPT4dDBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7eC3bHCpewrKlDIVaBqvdrXqkgVizmEB7WuA7KqDF4A=;
	b=yT8cwpZz+2KMZ0V3PlIa14K8NfbWd+2IIufdnKzmXsE/XBvmQvhJJTA/I18WeAF6Q17I
	 sWA+qJoF6XbDhrCbLJ30nJI6m+DYhJLzQh4t1bb0iBMlyRCnmsM2JFX092YriSW/Y1Ym7
	 dP/znTSrbSrzwk2t3l4MbLGcp3nM9q767oLpBIBBdbr03v3B9Syexbi39XMAM5BUxontv
	 UdsW+WJEgN9NrSwWIO4lMpaPgFcA5wvNzgwtEXEmShuPeUb7sFORmFl0bezk+xtuNPvwF
	 HzgIb2UZzeO61Cmuq0FmkfHNn+ZCuIzDYEZabr4nxyFm3YVGqWsZx5vn4z1ALjyjY6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUhsJLDc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE6F606A325;
	Wed, 18 Nov 2026 19:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BUhsJLDc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720541F000C5;
	Wed, 18 Nov 2026 19:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031383;
	bh=7eC3bHCpewrKlDIVaBqvdrXqkgVizmEB7WuA7KqDF4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUhsJLDcoaXnsVW7EDzRUeztWQbVP/1FL8uaRI/qSO2jYVMLoTSXbbqEpfkLtCYVO
	 pPvBHZaxxq3g0Tdnb5iuA/714AJuwdsDDw2mtoW5ORhzLmcI+uILFJimYC4TFAxNpz
	 XIcQX9KA55eHCWu7ctlEbNHUv+2WXz1dmsM6fgZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Julian Braha <julianbraha@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1039/1756] kconfig: fix infinite loop in conf_choice() when no choice value is visible
Date: Wed, 18 Nov 2026 15:52:46 +0100
Message-ID: <20261118150051.422814528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Leizhen Zhang <lzsx618@gmail.com>

[ Upstream commit 52f26261e27dbdb7c6dea75d8f1a92ea805b2c58 ]

If a choice is visible but none of its choice values is, conf_choice()
counts cnt == 0 visible values and finds no default. When the choice has
to be asked, e.g. because a new symbol was added to the same menu
(oldconfig, syncconfig) or because stdin is at EOF (oldaskconfig), the
loop that maps the answer to a menu entry never finds one and the
while (1) loop repeats forever, printing "choice[1-0?]: 0" each time.

This happens in the tree for s390 when the compiler supports none of the
-march=z* options (e.g. a non-s390 host compiler), so that all values of
the "Processor type" choice are invisible:

  $ make ARCH=s390 defconfig
  $ sed -i '/^CONFIG_NR_CPUS=/d' .config
  $ make ARCH=s390 oldconfig     # hangs

Before the removal of tristate choice support, conf_choice() returned
early in this case. Do the same when there is no visible choice value.

Found by fuzzing Kconfig input with ASan/UBSan.

Fixes: fde192511bdb ("kconfig: remove tristate choice support")
Assisted-by: Claude:claude-opus-5-5 libFuzzer
Signed-off-by: Leizhen Zhang <lzsx618@gmail.com>
Reviewed-by: Julian Braha <julianbraha@gmail.com>
Tested-by: Julian Braha <julianbraha@gmail.com>
Link: https://patch.msgid.link/20261008164521.3684735-1-lzsx618@gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 22c95c689faa5..b0efb52c695a5 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -483,6 +483,9 @@ static void conf_choice(struct menu *menu)
 			}
 			printf("\n");
 		}
+		/* Nothing to ask if none of the choice values is visible. */
+		if (!cnt)
+			return;
 		printf("%*schoice", indent - 1, "");
 		if (cnt == 1) {
 			printf("[1]: 1\n");
-- 
2.53.0



