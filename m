Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0304E154BF
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73313C433CA;
	Wed, 20 Sep 2023 12:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212160;
	bh=f+3LCWhbFSwLAxaVjGWfzdm/UjLfGK3nEMYEwAU2dhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntZ8NiOvVB6jw9BTFupKtjQbHfSvxMOZu6U4OLCfeHTygPcnYDsmwnQ6QTLVyYwsx
	 VIUvfCEyZvtXleRx0yi6xyM1FQnIMR56N85h3ikw6cxHl64KhH6sh1vIatEMbOEWtW
	 28AnIl2mwGU6qFWggHE1sVcZblid1+IX0utf5SkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 174/273] ARM: OMAP2+: Fix -Warray-bounds warning in _pwrdm_state_switch()
Date: Wed, 20 Sep 2023 13:30:14 +0200
Message-ID: <20230920112851.894197817@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 847fb80cc01a54bc827b02547bb8743bdb59ddab upstream.

If function pwrdm_read_prev_pwrst() returns -EINVAL, we will end
up accessing array pwrdm->state_counter through negative index
-22. This is wrong and the compiler is legitimately warning us
about this potential problem.

Fix this by sanity checking the value stored in variable _prev_
before accessing array pwrdm->state_counter.

Address the following -Warray-bounds warning:
arch/arm/mach-omap2/powerdomain.c:178:45: warning: array subscript -22 is below array bounds of 'unsigned int[4]' [-Warray-bounds]

Link: https://github.com/KSPP/linux/issues/307
Fixes: ba20bb126940 ("OMAP: PM counter infrastructure.")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/20230607050639.LzbPn%25lkp@intel.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Message-ID: <ZIFVGwImU3kpaGeH@work>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-omap2/powerdomain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -177,7 +177,7 @@ static int _pwrdm_state_switch(struct po
 		break;
 	case PWRDM_STATE_PREV:
 		prev = pwrdm_read_prev_pwrst(pwrdm);
-		if (pwrdm->state != prev)
+		if (prev >= 0 && pwrdm->state != prev)
 			pwrdm->state_counter[prev]++;
 		if (prev == PWRDM_POWER_RET)
 			_update_logic_membank_counters(pwrdm);


