Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623362;
	b=tnGABhAO7rsNtfwuKAPzQc0Vfx0N3IHmBesT2xmJHlXS/kyQye3NfvWVnd+sSbq7V9yg
	 hkmqzfTJbJ0CKc1ckOWWwGYvDR6ARVtcTwycJjdgSGiCo11n0+rLoEa7hCFdkjZZIN0r1
	 0O4zALNszjf4U6HbncOEgmaVnGN/p9gde6n8oRh3vRmOBXm4sBB+pNlIAEq4nqEjTuNW9
	 Nlu1fielRXM+QTHSCni2ST2ChEZZA/vtjmUqPFQvY+N1nu90jCUpymkDEAEMj3bWxqyI5
	 lN+rvyEQGSOFQxHCpIZ9JW/JlhDslwNxw639UrGOU8lSU80p38ZdzDsRtQHKDrN/k6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E1bzttuUgLVUXUSBpWq2LJ3y5JaxjMm31rKX6TIl17k=;
	b=1Orz5+5YVZ9SmBjQClu+XfScA0EL1UQm6cMmw4Wx0CoJjmnwgNvSGymbqFX2KP8eur56
	 UfW30D4UUUgcrVVqYx+X2wCDwSMUYjzWgHrKRpn9d6+ZJgC4JgtE9weWOG1jD7OgAeqPc
	 8SbQ7YtYPviXis+8PiNKVDRqr2RaA0c37nooXnyegUtQugSixXYug6nO1g08u49ertk5o
	 +yWe/Mez+2eCRN2AZyF/mAJeFhEvChKYP1jJGwF4l05pp7i0pbetFbptXdKoKFb3EDHNV
	 F5F0/UBUJRfywf4vYNnsy9xmSulN6hlZ9LdGZJNe79nVYoahMcUn7LUGoRPePVhld+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3RPLr2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49E3606A321;
	Wed, 25 Nov 2026 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3RPLr2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3BA1F000C0;
	Wed, 25 Nov 2026 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623361;
	bh=E1bzttuUgLVUXUSBpWq2LJ3y5JaxjMm31rKX6TIl17k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3RPLr2NTnzH90v59QlLWLk8n0N2/5HrgJnmGLlcOvEIJbuemH+F/weq7xyrmBUET
	 zOgawAwp4XPXvsYeYGcSAAgTO88zPWyjMuK9YEe/Ey9I4uIYZJn2wwNfF7PxCKw/D0
	 WOJWvhfnuSDJwpNYwAAQ3yBHwEzm1pCT0sG8gTYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Budding <tim.budding@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 789/990] sctp: abort unordered partial delivery when its message is skipped
Date: Wed, 25 Nov 2026 15:35:56 +0100
Message-ID: <20261125143840.527387569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Budding <tim.budding@gmail.com>

commit 05852c8b70f2291a50bb3f740a66ce9caf9cb98d upstream.

When an I-FORWARD-TSN skips unordered messages on a stream,
sctp_intl_skip() only aborts the stream's unordered partial delivery if
the MID being delivered is lower than the skipped MID. If the skipped
message is the one being partially delivered, partial delivery stays in
progress: no PARTIAL_DELIVERY_ABORTED is sent, and the next unordered
message on the stream is delivered as the rest of the abandoned one.

Abort the partial delivery when the MID being delivered is at or below
the skipped MID, as the ordered case already does.

Reproduced on an unmodified kernel with the uo_pd test of the
sctp_ifwdtsn.sh selftest added later in this series; its partial
delivery checks pass with this fix. Reproduction and fix done with AI
assistance.

Fixes: de60fe910543 ("sctp: implement handle_ftsn for sctp_stream_interleave")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Budding <tim.budding@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20261105050225.49292-2-tim.budding@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream_interleave.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1255,7 +1255,7 @@ static void sctp_intl_skip(struct sctp_u
 	struct sctp_stream *stream  = &ulpq->asoc->stream;
 
 	if (flags & SCTP_FTSN_U_BIT) {
-		if (sin->pd_mode_uo && MID_lt(sin->mid_uo, mid)) {
+		if (sin->pd_mode_uo && !MID_lt(mid, sin->mid_uo)) {
 			sin->pd_mode_uo = 0;
 			sctp_intl_stream_abort_pd(ulpq, sid, mid, 0x1,
 						  GFP_ATOMIC);


