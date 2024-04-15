Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1053F8BF8;
	Mon, 15 Apr 2024 14:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191840; cv=none; b=jpQygfR0mMmrFxfzgrzUM8o+b2zwL6Q97P1nc+89ZyMz9LXdn+byq5Cx2M3UgMuCY5DHK8iws3g0jg7Cv0A/l8cMRhr/7GtehOMR7mUJrtVljh7y3BCNYnqidzld9MiviE6jc1SR1dDyHNSNgGHf0IG/wvFfWcE1pbsmWUzr9vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191840; c=relaxed/simple;
	bh=Guzk44SbpmVWNhIE33TH/VFEcoOE6vktIHuSp5Nk3pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSfPnunELRzxzh61QG3D3nwj1fDZHAfOcll0sjr0ck7LRQ7tq53qWiZnOJBP6eMIFB4Lg2ouOsglJ9TOLCZ/v+Bb6gqfm+tvdPPEH99ITBt49FIlrg+ndTHQFyMnga80KZJ0+Yy7yHDFRk/GH9sjPbxYNaIBXkEeIWAIQW3Ybss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kllv8Q03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kllv8Q03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A311C113CC;
	Mon, 15 Apr 2024 14:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191839;
	bh=Guzk44SbpmVWNhIE33TH/VFEcoOE6vktIHuSp5Nk3pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kllv8Q03sji5nUVuMeXD9udxL4/Jmzj9UTnHXtYhvTFBtuwtUEn9gw9+jSE59Wabp
	 n8XK1lN7cIfHQG21MMzgipnbfwfwKE8SzRQdJhf4dpE97rj8Hx1B3HUkwrCuWA7vqd
	 cb+qEFLcIhy1FWXdaxRF1GHRM8Klr55P5vOE2wKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 103/122] x86/cpu: Actually turn off mitigations by default for SPECULATION_MITIGATIONS=n
Date: Mon, 15 Apr 2024 16:21:08 +0200
Message-ID: <20240415141956.465253424@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit f337a6a21e2fd67eadea471e93d05dd37baaa9be upstream.

Initialize cpu_mitigations to CPU_MITIGATIONS_OFF if the kernel is built
with CONFIG_SPECULATION_MITIGATIONS=n, as the help text quite clearly
states that disabling SPECULATION_MITIGATIONS is supposed to turn off all
mitigations by default.

  │ If you say N, all mitigations will be disabled. You really
  │ should know what you are doing to say so.

As is, the kernel still defaults to CPU_MITIGATIONS_AUTO, which results in
some mitigations being enabled in spite of SPECULATION_MITIGATIONS=n.

Fixes: f43b9876e857 ("x86/retbleed: Add fine grained Kconfig knobs")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Cc: stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240409175108.1512861-2-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cpu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -3208,7 +3208,8 @@ enum cpu_mitigations {
 };
 
 static enum cpu_mitigations cpu_mitigations __ro_after_init =
-	CPU_MITIGATIONS_AUTO;
+	IS_ENABLED(CONFIG_SPECULATION_MITIGATIONS) ? CPU_MITIGATIONS_AUTO :
+						     CPU_MITIGATIONS_OFF;
 
 static int __init mitigations_parse_cmdline(char *arg)
 {


