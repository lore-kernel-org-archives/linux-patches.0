Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8AD2589;
	Tue, 23 Aug 2022 15:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352D5C433D6;
	Tue, 23 Aug 2022 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1661268083;
	bh=d9e8tVoifQ7GaeXefRpR3cOVTXLtya7HeNbAsuHXZEM=;
	h=From:To:Cc:Subject:Date:From;
	b=Ufjf5RMzDjXQxSoiSj0waZ14yrHv3F1SyHQq5i6E3xBrhcUfCg2Nk8ZoA1P7evjbn
	 8AA3yhgGjGrhhLyiwV1qMESJA/SjAkg3GAn2lmh0FY+8xfYwEpYrBnhy+WvsImQowr
	 cP2+wzU0UK0V0wChQtCtLlWwhxXcQ9IybZ+LP5NFdRqKCew/Cb2X0Mf/s1bNsaNOeA
	 qmDyDxSqXbrU6O/h25ErMzoLpSfGQJ12gqh3QvZaGVwRHLteJLyrIpqIEP90WJpJ6X
	 kEl8aQZfWCKpBnudiznNQ/h+s+uOyN38giitazXl1t7LLZDrqKKo98mrnpv/6M6yud
	 8P0M8EOU56/5g==
From: Nathan Chancellor <nathan@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Matt Flax <flatmax@flatmax.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>,
	"Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Subject: [PATCH v2] ASoC: codes: src4xxx: Avoid clang -Wsometimes-uninitialized in src4xxx_hw_params()
Date: Tue, 23 Aug 2022 08:19:40 -0700
Message-Id: <20220823151939.2493697-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns:

  sound/soc/codecs/src4xxx.c:280:3: error: variable 'd' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
                  default:
                  ^~~~~~~
  sound/soc/codecs/src4xxx.c:298:59: note: uninitialized use occurs here
                  ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_11, d);
                                                                          ^
  sound/soc/codecs/src4xxx.c:223:20: note: initialize the variable 'd' to silence this warning
          int val, pj, jd, d;
                            ^
                            = 0
  sound/soc/codecs/src4xxx.c:280:3: error: variable 'jd' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
                  default:
                  ^~~~~~~
  sound/soc/codecs/src4xxx.c:293:59: note: uninitialized use occurs here
                  ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_10, jd);
                                                                          ^~
  sound/soc/codecs/src4xxx.c:223:17: note: initialize the variable 'jd' to silence this warning
          int val, pj, jd, d;
                        ^
                          = 0
  sound/soc/codecs/src4xxx.c:280:3: error: variable 'pj' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
                  default:
                  ^~~~~~~
  sound/soc/codecs/src4xxx.c:288:59: note: uninitialized use occurs here
                  ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_0F, pj);
                                                                          ^~
  sound/soc/codecs/src4xxx.c:223:13: note: initialize the variable 'pj' to silence this warning
          int val, pj, jd, d;
                    ^
                      = 0
  3 errors generated.

The datasheet does not have any default values for these regmap values
so pick some arbitrary values and print to the user that this is the
case to silence the warnings.

Link: https://github.com/ClangBuiltLinux/linux/issues/1691
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Suggested-by: Matt Flax <flatmax@flatmax.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

v1 -> v2: https://lore.kernel.org/20220822183101.1115095-1-nathan@kernel.org/

* Don't return early, just initialize the values to some arbitrary
  numbers and try to hobble along, as other parts of the chip may be
  functional.

* Add message and comment to describe this situation.

 sound/soc/codecs/src4xxx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/src4xxx.c b/sound/soc/codecs/src4xxx.c
index a8f143057b41..db4e280dd055 100644
--- a/sound/soc/codecs/src4xxx.c
+++ b/sound/soc/codecs/src4xxx.c
@@ -280,9 +280,14 @@ static int src4xxx_hw_params(struct snd_pcm_substream *substream,
 		default:
 			/* don't error out here,
 			 * other parts of the chip are still functional
+			 * Dummy initialize variables to avoid
+			 * -Wsometimes-uninitialized from clang.
 			 */
 			dev_info(component->dev,
-				"Couldn't set the RCV PLL as this master clock rate is unknown\n");
+				"Couldn't set the RCV PLL as this master clock rate is unknown. Chosen regmap values may not match real world values.\n");
+			pj = 0x0;
+			jd = 0xff;
+			d = 0xff;
 			break;
 		}
 		ret = regmap_write(src4xxx->regmap, SRC4XXX_RCV_PLL_0F, pj);

base-commit: 94f072748337424c9cf92cd018532a34db3a5516
-- 
2.37.2

