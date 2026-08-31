Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD9C4F9C73;
	Mon, 31 Aug 2026 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183685; cv=none; b=E+UIfXxl0cm57J1Gp3gwdvybV4AkFfqt0xzzr4l7RlQjr96MqLfnFIzS1PQuH+ajmQ5dqKfsZz0J6clUeVzDrLRRz/JQ2z1Xlbs0HreMevDcAvnyfTtVB7ihiMw03esZUuyaY9UlGexAOfdXPL/22Lp8YTUsoxngNoWDabPVNh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183685; c=relaxed/simple;
	bh=+/vregn1nPndwTT8Oc/UHeluCRpcJwUuzbPmelwqBjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1XJ2bB+eUlAMXFhXJMv4e9k9ndPSUjomfDk/RCSotrXqhyoFQj4L2UFov21CUZTBG6Pw8f6g8Ydlo3PgIkcdMYNxkLv8SvduVGyUyDKhUmX5yPl8VfUi+UkU8bMfKk1VpXlzWXHgBmQCdsU9CH9VpSsu8YI7l7coVYQluX87Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4lxYmsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4lxYmsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4273F1F00A3D;
	Mon, 31 Aug 2026 13:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183682;
	bh=/IiQvqgtlm80SL0mbtvvRruA8W84YA36TLILMPj6c6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4lxYmsb4I9SfwWaUL8oRMcNpqvNR/l9GXJYzRVKZS673ykj2VG8bRPkA+Lh3Auzi
	 KYcseFdIzdxVL1LYI4A3EAGQzmTYkX4qzYpj2+HKKcTHwH7SJK50p0iL9+jUsFmVD2
	 d59ip5gR0IF6M7qFcWUizl286PlM5iFYRFBG/p1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 7.2 37/71] xfrm: fix xfrm_state_construct() auth-trunc leak
Date: Mon, 31 Aug 2026 15:34:02 +0200
Message-ID: <20260831133401.048761807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -940,7 +940,7 @@ static struct xfrm_state *xfrm_state_con
 	if ((err = attach_auth_trunc(&x->aalg, &x->props.aalgo,
 				     attrs[XFRMA_ALG_AUTH_TRUNC], extack)))
 		goto error;
-	if (!x->props.aalgo) {
+	if (!x->aalg) {
 		if ((err = attach_auth(&x->aalg, &x->props.aalgo,
 				       attrs[XFRMA_ALG_AUTH], extack)))
 			goto error;


