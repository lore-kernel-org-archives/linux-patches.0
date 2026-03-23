Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB94B3AB295;
	Mon, 23 Mar 2026 13:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774273824; cv=none; b=GQiKDIwI0OgYi+2IImhfbwE2MKYxbrmI2O3p9WKEvLeZ68FPkUvpLs1Eg87vKIKM2zMprmpliRNvsXORG+BTURWd/VBTI8DNdegaQKj+S0BQhqak8iD4AtNVzDJrd/z8ekCVYiqrPVFyPMdr+ZV2Qw0tQpMUUSh4Z4KDp4IJKwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774273824; c=relaxed/simple;
	bh=J+MvKV9XnyfK9+SoBvG005iXbjfl4FPb2pRTZs7V+BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShWlyv6/7+Ht4l8YiVhtO0tpvqtr9Fssj+h9Edq2gNF72pELN4thVatXOyvNutgzfjD/QYLWA9Pj534gKOAN3t+/9tOsc6thei9nRDGSOjSBMQpHOFAC1tliMY6TOtoDPF78klNjQiYUGtiiGE4yf3ueo24yMFhqnMceCNxrNlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vBYmIkto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vBYmIkto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29796C4CEF7;
	Mon, 23 Mar 2026 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774273824;
	bh=J+MvKV9XnyfK9+SoBvG005iXbjfl4FPb2pRTZs7V+BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vBYmIktoKi3wPWxFYFR7hQq29FnbmnMb7pJgwcQ8Q356xG68QaGN8mIhIPLWls5/B
	 wgVMR5tFUL1UFWszHGFUhJ2XWW8KsPBlvSd+DlR5A4/AuGZLJZspv/ancEIbU42Cn+
	 ZFBrA+1h8rRJC/PZH6R6XYqLRwAGWN5aXA+gucwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AlanSong-oc <AlanSong-oc@zhaoxin.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.19 020/220] crypto: padlock-sha - Disable for Zhaoxin processor
Date: Mon, 23 Mar 2026 14:43:17 +0100
Message-ID: <20260323134505.217018421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AlanSong-oc <AlanSong-oc@zhaoxin.com>

commit ebba09f198078b7a2565004104ef762d1148e7f0 upstream.

For Zhaoxin processors, the XSHA1 instruction requires the total memory
allocated at %rdi register must be 32 bytes, while the XSHA1 and
XSHA256 instruction doesn't perform any operation when %ecx is zero.

Due to these requirements, the current padlock-sha driver does not work
correctly with Zhaoxin processors. It cannot pass the self-tests and
therefore does not activate the driver on Zhaoxin processors. This issue
has been reported in Debian [1]. The self-tests fail with the
following messages [2]:

alg: shash: sha1-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
alg: self-tests for sha1 using sha1-padlock-nano failed (rc=-22)

alg: shash: sha256-padlock-nano test failed (wrong result) on test vector 0, cfg="init+update+final aligned buffer"
alg: self-tests for sha256 using sha256-padlock-nano failed (rc=-22)

Disable the padlock-sha driver on Zhaoxin processors with the CPU family
0x07 and newer. Following the suggestion in [3], support for PHE will be
added to lib/crypto/ instead.

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1113996
[2] https://linux-hardware.org/?probe=271fabb7a4&log=dmesg
[3] https://lore.kernel.org/linux-crypto/aUI4CGp6kK7mxgEr@gondor.apana.org.au/

Fixes: 63dc06cd12f9 ("crypto: padlock-sha - Use API partial block handling")
Cc: stable@vger.kernel.org
Signed-off-by: AlanSong-oc <AlanSong-oc@zhaoxin.com>
Link: https://lore.kernel.org/r/20260313080150.9393-2-AlanSong-oc@zhaoxin.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/padlock-sha.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -332,6 +332,13 @@ static int __init padlock_init(void)
 	if (!x86_match_cpu(padlock_sha_ids) || !boot_cpu_has(X86_FEATURE_PHE_EN))
 		return -ENODEV;
 
+	/*
+	 * Skip family 0x07 and newer used by Zhaoxin processors,
+	 * as the driver's self-tests fail on these CPUs.
+	 */
+	if (c->x86 >= 0x07)
+		return -ENODEV;
+
 	/* Register the newly added algorithm module if on *
 	* VIA Nano processor, or else just do as before */
 	if (c->x86_model < 0x0f) {


