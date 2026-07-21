Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A650413D69;
	Tue, 21 Jul 2026 22:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672879; cv=none; b=Fglr21bXAlYvGIdGM4Rc7XnlhkvFKid6UFl/Q2rqUKUTC0TgCdDeQ5EsGWAdscQi+moK27o4ighrZXw0rHOM//j7KONVxkg++ukQXfP71z86uE7IK0Hv8AO7dpW+j6aCJg5FLo8+faeldsSLQYbMmz04dvJTpvcQvi8J0YVyP28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672879; c=relaxed/simple;
	bh=lc47eLAJRXjDBeAEvq6rB5W5kbeeUM784bn7/CvAUoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiOVZrz8cEnydFpR7KBjxRAW3gLiNxyhR1gOrqHSq2gfyazelU8P3xT8fpcT6k2285/UJRxoQs+muuyR+hifqcsncqwU0HDwdNBY6HMKzrVjg2pdLN05e2Mgde99RKMv7mqw4Isz7VDXN1Na2sCko0HgG5oXki9JlWcmYHZK7No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWvPc8uJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWvPc8uJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B411F000E9;
	Tue, 21 Jul 2026 22:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672878;
	bh=fLiMO4zvieuynJExcPaaEn6hiwxF2f/T/GwVR8wuIAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWvPc8uJAMltn/FqXv2b7BrdodJj+AhDO3dLyaFq7bZprvLSNntOAVzINVF3KOBg7
	 tP/tUFa8FN/pU0KSvPMnsMFBJsGIwp3pI60ooSn+VIzlGnGHn1H5obUowK63jF43y/
	 foltoWHU1rhn04AfQnkINzBs41fUpFBDvNpGJ1fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Alistair Francis <alistair.francis@wdc.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 791/843] X.509: Fix validation of ASN.1 certificate header
Date: Tue, 21 Jul 2026 17:27:06 +0200
Message-ID: <20260721152423.855229937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 3b626ba431c4501512ad07549310685e07fe4706 ]

x509_load_certificate_list() seeks to enforce that a certificate starts
with 0x30 0x82 (ASN.1 SEQUENCE tag followed by a length of more than 256
and less than 65535 bytes).

But it only enforces that *either* of those two byte values are present,
instead of checking for the *conjunction* of the two values.  Fix it.

Fixes: 631cc66eb9ea ("MODSIGN: Provide module signing public keys to the kernel")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260508033917.B5873C2BCB0@smtp.kernel.org/
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.7+
Reviewed-by: Ignat Korchagin <ignat@linux.win>
Reviewed-by: Alistair Francis <alistair.francis@wdc.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 certs/common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/certs/common.c
+++ b/certs/common.c
@@ -20,7 +20,7 @@ int load_certificate_list(const u8 cert_
 		 */
 		if (end - p < 4)
 			goto dodgy_cert;
-		if (p[0] != 0x30 &&
+		if (p[0] != 0x30 ||
 		    p[1] != 0x82)
 			goto dodgy_cert;
 		plen = (p[2] << 8) | p[3];


