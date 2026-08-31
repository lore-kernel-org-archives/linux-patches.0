Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C26515734;
	Mon, 31 Aug 2026 13:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183798; cv=none; b=PxmbwCQgo5FwwseUlKr6lzkmF2HtZblNNeY+RW69+fm9dUzkoOEGnPaxV/UmlNlNfmxqRStRBzX7l75tAo8BdUeScBhdDyyvlTs8OHNc0Uye+t9FfHUQ0iZWM9CHnIt4qnIJlpSSNMn44JXi48NFFVrhkufxkmzAbMPF1PqkQA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183798; c=relaxed/simple;
	bh=wfnVvjE0ZR0o7vervsdzVV4/vzZjwDdaNztWZrSG/50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kw5Mwv71OGjDP7rH+lKd3K6WhuU2+MVbMCjy9qjSuqJ0MFJ/OYcKa7t9rMhe6HIg8+LXMbmYXYatuGfUv3JJri4SFazpS5i34OExoFPDe1YdCD9QXSLgmt56N7zjI8rTdRJGec+2w6LwY9ZgP1QqQ4HaU1M9gU/nagR3v1Hqez4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZsmOcPK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZsmOcPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAF51F00A3D;
	Mon, 31 Aug 2026 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183796;
	bh=8BYWXHTPPzhJCbmrTjCLkxgsBBZ4WGxOgPrn0nBp5gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZsmOcPKRfCEcSejed9tInRujCDMhyjX4GRnc8aAQ7fhoUpoPLvhiQdHoqhPdqzUz
	 sRfNdFrdBmWUtvseIl9GU+bumL0eX3Zg4IggTJC28qSYDkhJV5xwVg2EmWXjRgyMLI
	 4IzS3Jm3JVBo7oBuVPGuPtDPdjC3CtLO9+byLtm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.1 45/76] xfrm: fix xfrm_state_construct() auth-trunc leak
Date: Mon, 31 Aug 2026 15:34:17 +0200
Message-ID: <20260831133401.750828830@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

commit c12cbf56320fb633484ee0ca1fb7d68d6b64b213 upstream.

attach_auth_trunc() can allocate x->aalg while leaving
x->props.aalgo at zero when the selected auth algorithm has no
sadb_alg_id. One real case is cmac(aes).

xfrm_state_construct() then treats !x->props.aalgo as "no auth
algorithm attached yet" and calls attach_auth(). That overwrites
x->aalg and loses the first allocation. Any later failure or teardown
only frees the replacement pointer.

Check whether x->aalg is already attached instead of inferring that
state from x->props.aalgo.

Fixes: 4447bb33f094 ("xfrm: Store aalg in xfrm_state with a user specified truncation length")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -925,7 +925,7 @@ static struct xfrm_state *xfrm_state_con
 	if ((err = attach_auth_trunc(&x->aalg, &x->props.aalgo,
 				     attrs[XFRMA_ALG_AUTH_TRUNC], extack)))
 		goto error;
-	if (!x->props.aalgo) {
+	if (!x->aalg) {
 		if ((err = attach_auth(&x->aalg, &x->props.aalgo,
 				       attrs[XFRMA_ALG_AUTH], extack)))
 			goto error;


