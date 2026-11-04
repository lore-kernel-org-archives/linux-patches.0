Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826974;
	b=dn+hiU4gwrxZZI/Umay/IW8pqdOpAa7STmZIkxCF6cMhdsDgQyZk+7y70zdPkJu9W0Bb
	 x5wt/xzJ3lsvBwYPRhJQ18GEXMeyouYi2Yd6lC7lPyHeKZbmvpmA5bLKJ9TMHG+5CbiZH
	 DHs3Tp0Pg9rJ7APi66nfCEjo9yVmiXQM6zEGsCDoiWSmH3AtGDuQW9SSTTTWibqy99q/P
	 ZAhSWxlNWynwBxOXXHpqvfrTo/NjIyv4plP1J5Q3XsuwRvgqvL2ty/qC6tlgGsBU0cTHl
	 HuOzV+RMRZjfB1WQqp90eiFdGMJd3U1JN6QBjPzeXqYubzWAUgDpjY6tbmLgqajsacQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jOORKYyTRJ69x0DsKmtN8GksqPGeGNmAh2sA/2UeKoc=;
	b=g4o3xkktHvKxucrdJEDc6Ej/8JAyRdUbj9k9kv/jJ6r+/jEwoCOZHfg0xxrKyTFLgy7z
	 7QaGR9YFpVCT/d4khaOwhPsgNL1wVoWt4dStN2HnNATLYIg7u3Eo5FtqDWo43Fqug3Gnl
	 3HpdBiWRUB3Jho61fZ6BEFDmJTGauRgrXtfxzSjPOkDCvXtLntNtbh0qqGLrBprncP9nN
	 pRlbQQF3q/Fx8k7ZRd4q2es2967W4zG2J1gYZbRlGBuCC1TNGYDhy+rlnGlMP5ypp97K+
	 wT+Yv5NQ1wWwGpnMVQFf4+4v7wDPeRmj3YgiUZrzPTzZDVEuDch2fPxCGU3MchsWF7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNwEgEZT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E76D60BC560;
	Wed,  4 Nov 2026 21:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNwEgEZT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6315C1F00A18;
	Wed,  4 Nov 2026 21:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826973;
	bh=jOORKYyTRJ69x0DsKmtN8GksqPGeGNmAh2sA/2UeKoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNwEgEZT3Fssrr7pIjPHKsRxEa51Kkou4oSXogfkqCyCju2C9FHN9xLs8X0PpJF8C
	 w/9q0XBBedAmBcw2jH192vvltzMpabYRZ2SpXjT0GWYviydX3rF7cFpvnpOcg4KHk6
	 /5+goRnpIhwHBB4uKN7UDrJLPNX0NlHMR5eOKtMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tea La Forgia <tealaforgia+alias@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 118/547] ksmbd: fix extended session security negotiation for raw NTLMSSP
Date: Wed,  4 Nov 2026 16:05:02 -0500
Message-ID: <20261104211041.551194130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 6868f857514bbfd2ed10b9b566664dc4a8ca039d upstream.

ksmbd_build_ntlmssp_challenge_blob() only advertises extended session
security when conn->use_spnego is true. As a result, raw NTLMSSP
negotiation drops NTLMSSP_NEGOTIATE_EXTENDED_SEC from the challenge even
when the client requested it.

A Windows capture shows an initial SPNEGO authentication succeeding,
followed by a raw NTLMSSP negotiation on the same TCP connection. The raw
challenge omits extended session security, and the client does not send
an AUTHENTICATE message. The unfinished session then occupies the pending
session slot, causing subsequent SESSION_SETUP requests to fail with
STATUS_INSUFFICIENT_RESOURCES.

Set NTLMSSP_NEGOTIATE_EXTENDED_SEC whenever the client requests it,
independently of the SPNEGO wrapper, as required by [MS-NLMP].

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: Tea La Forgia <tealaforgia+alias@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -336,8 +336,7 @@ ksmbd_build_ntlmssp_challenge_blob(struc
 	if (cflags & NTLMSSP_REQUEST_TARGET)
 		flags |= NTLMSSP_REQUEST_TARGET;
 
-	if (conn->use_spnego &&
-	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
+	if (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC)
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
 	if (cflags & NTLMSSP_NEGOTIATE_KEY_XCH)


