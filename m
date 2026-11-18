Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019391;
	b=Th54CV2Q2HrjQecuu/njZvvGbOl9jbs7jbOxIv8wzL0mKNXiA4aZto/CWLUpQH2S58dA
	 3Xc3VL1NqyZhtl2nk/wuKTZShjUEw4EaaRFLy/v8fFwYuVUP6WcPTVtn85Jllrv9kX9lp
	 s2ALCckF0zxdQIRgjZwKQmm1YJ1eR7YZJgOH9zVCF2yTarvGYsSCXhAFHo9Ap7HvBmEDG
	 y5NlANrEFMvhwjzuTuMvXFo6Vxdd4B78aqbUAOhzSePvunFWfFwP91aBszWmFgpeyepOo
	 XDIjIJbeuD0X+/s7HDcyZdba0es/sSCBNLb2igm1jK26+l83fmhAgbCF+OLvsgI7tlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbEV8mU13+pU1hYD2XsvTOzlGv2t2jk3DK5D9aehh6c=;
	b=RI9nPvw7PN27yNawRyQQMCH+5V4dZd4Yy/zojEA9mvbe/t5EXCUWatkIpEeyUA8/4UFY
	 z2VDSByXVNTHnHQ2/V5G6B+HfnTu2qvXAHFJjoFhy2EiwerFLTrE0voPsBZ49L6dJfBaq
	 tPGeOEuIw24G8Six5OmH77jhmyr+T+zGbT/7ErpdHrqa4CwQV+kn1j0Et0ES3AeIaLkFY
	 K7/bfzhZZXYeXfP0udwIL5qakRncHJZjkolcgGWUrk0rOH+nWAIIciQ/UEo2qVJ/zemb8
	 zqjQnuDCHNaD9Bpj5HsWL27eFFp7eoIB6FUfyYH/btIi5Psi4J74vxuLfJihRh9vg1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHpzbATc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7818606A32F;
	Wed, 18 Nov 2026 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pHpzbATc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48211F000C5;
	Wed, 18 Nov 2026 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019391;
	bh=hbEV8mU13+pU1hYD2XsvTOzlGv2t2jk3DK5D9aehh6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHpzbATcF4sqlxFKXR/pIj/FnT2tVrl/G7/tfYZM+1IoUjHSO5OLae+u3rUFQUk1i
	 V8EtkuThj2ShRpyzxKyeto1P83BoTmKo9mr+pKyvGSzIzHeIsvR+8Kh7cYpixChgQe
	 XLJSD8l22OKSchq0pw06IFy5l1oFWEhNlR8+L2i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leizhen Zhang <lzsx618@gmail.com>,
	Julian Braha <julianbraha@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1580/2651] kconfig: fix infinite loop in conf_choice() when no choice value is visible
Date: Wed, 18 Nov 2026 15:47:00 +0100
Message-ID: <20261118150344.798847567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ca6d9d735922f..31c6fd25e6ecd 100644
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



