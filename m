Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD0918AE5;
	Tue, 22 Aug 2023 15:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB80C433C8;
	Tue, 22 Aug 2023 15:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1692718045;
	bh=aJtctRw2XMMUw+/KdyBDVt6YooHDM28RFX47L7McclU=;
	h=From:Date:Subject:To:Cc:From;
	b=YSgE2n9JFbYBSxzDaZa1ZfTFOxaO+JBXAiFvHPeb8cnKV0TIk9we2qfaK/df19yUX
	 2N20diQdiP7RvYVT1/6wnQTTgxeCTm2sZKRQNSv2Nz3or67095ATWPCoOQY6R+WuEc
	 U+Kexefe65eMzxZsOJKfjmpd9mIt5pu4DnmnzOKMPbUmB0hECx3Z/fGVhq0SMV/7+v
	 HPsW7GWS+PWdCGjqbzoEgQsDlcFHdwb3D6BV78VOOjXg2JLuliK4k3SF6gDAYh4SdV
	 HgrDai2M6lZ0ixQOprynFY1CXsN4xL1mII/EzHYibGvM5EDC1Io3V3aDkNYnuKSBiS
	 y9J2z6cGQXbsQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 22 Aug 2023 08:27:16 -0700
Subject: [PATCH] wifi: rtw89: Fix clang -Wimplicit-fallthrough in
 rtw89_query_sar()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-rtw89-tas-clang-implicit-fallthrough-v1-1-5cb73f0fa976@kernel.org>
X-B4-Tracking: v=1; b=H4sIANPT5GQC/x2NQQqDMBAAvyJ7diFNKUS/Ij0scWMWUpVN1ELw7
 w09DgMzFTKrcIaxq6B8SpZtbfDoO/CR1oVR5sZgjX0aZy1qudyAhTL61DzKZ0/ipWCglErU7Vg
 iEgWeHQ8vEzy01K4c5PvfTO/7/gFtbPeUdgAAAA==
To: pkshih@realtek.com, kvalo@kernel.org
Cc: ndesaulniers@google.com, trix@redhat.com, damon.chen@realtek.com, 
 linux-wireless@vger.kernel.org, patches@lists.linux.dev, 
 llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1846; i=nathan@kernel.org;
 h=from:subject:message-id; bh=aJtctRw2XMMUw+/KdyBDVt6YooHDM28RFX47L7McclU=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDClPLt9tsFnXJTY7N6JDVGy66NHy/O1ydZaX33+anD5J8
 7jC7ZYHHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAin4sYGY6m8fyYvOdUVqJV
 OMefmla1p/4m4jb9QoyTRAIe2t84Ec3wT+HrlzPcB5lWzOLzlJniKtyhE1fVWZDoXcyRcZifJy2
 MCQA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

clang warns (or errors with CONFIG_WERROR=y):

  drivers/net/wireless/realtek/rtw89/sar.c:216:3: error: unannotated fall-through between switch labels [-Werror,-Wimplicit-fallthrough]
    216 |                 case RTW89_TAS_STATE_DPR_FORBID:
        |                 ^
  drivers/net/wireless/realtek/rtw89/sar.c:216:3: note: insert 'break;' to avoid fall-through
    216 |                 case RTW89_TAS_STATE_DPR_FORBID:
        |                 ^
        |                 break;
  1 error generated.

Clang is a little more pedantic than GCC, which does not warn when
falling through to a case that is just break or return. Clang's version
is more in line with the kernel's own stance in deprecated.rst, which
states that all switch/case blocks must end in either break,
fallthrough, continue, goto, or return. Add the missing break to silence
the warning.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1921
Fixes: eb2624f55ad1 ("wifi: rtw89: Introduce Time Averaged SAR (TAS) feature")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/sar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtw89/sar.c b/drivers/net/wireless/realtek/rtw89/sar.c
index fafc7a0cfe97..715bf5c2f56a 100644
--- a/drivers/net/wireless/realtek/rtw89/sar.c
+++ b/drivers/net/wireless/realtek/rtw89/sar.c
@@ -213,6 +213,7 @@ s8 rtw89_query_sar(struct rtw89_dev *rtwdev)
 		case RTW89_TAS_STATE_DPR_ON:
 			delta = rtw89_txpwr_tas_to_sar(sar_hdl, tas->delta);
 			cfg -= delta;
+			break;
 		case RTW89_TAS_STATE_DPR_FORBID:
 		default:
 			break;

---
base-commit: f585f4ab0b998578b4ef3610ccfc08e207fc3499
change-id: 20230822-rtw89-tas-clang-implicit-fallthrough-aafed8e950fc

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

