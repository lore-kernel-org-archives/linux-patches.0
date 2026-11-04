Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831837;
	b=5t6hfY+NmqK416Sqp8EMiEkLkB6uuvUPy0eiHlQArHf1CMj2w5/F5oKFP2b4s7joWaK3
	 izO1HQYyTiAYvAKqk1gbcBTGcwMaesc52odOviCyTGYM7Z+gMO/T+9q7UtSlvw30BpoPX
	 757ZlSj8Cn3E/0oyVAQhGqFW2DOnFjxLw+STfKA8U86FldtCusz9rJt4vlPtr1b+/5up2
	 mZFUEQtqgI0txf+0cMnCIQfouU1+iytZ5meeM6ow/BiWAx4fi7wZuCQwDrpiqqlhhog14
	 kuO3aiq6Z/kPCF7U3g3wGehIzp/S1g9wQz2ZFNIgLi61ue4ivvHQZ0zCGyU4j2wJmXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CrSb0tZyKJ8U3KxfRB+n7HCYZczD6E8ZoLfABve56Sk=;
	b=CEyXVhVcydww1wUayrQPseXidIKGQTSrjuh0A0T2MRtoztvJNwohfokBI7wiZA9TNLUA
	 A84mf9kY3zYzwA8IVZwTJzWtFdioLKpF49Lb40snLulUUk+T+LOaYggBNHy7dkAuQumDo
	 GmoQLZdKt4ZpBNOFu+BY0lck+9C73Dq89CFg/rb9Ha2dOb7yTCh6ffm22EQlbnhswc1Du
	 Y3GEFkdvXmbDiVhTzScgUxZCssKazqA85BxhauCp3v2k9CNLBpAdqau29G+/ErbAAszJB
	 66vtXl1kCnnfo3YOmFLkLYx9KQ4KnKFBG5NW43uQ5oNIk7yfrgbVU/VoHmnrfZF7yHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H682IS6j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A792606A842;
	Wed,  4 Nov 2026 22:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H682IS6j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FFA1F000C1;
	Wed,  4 Nov 2026 22:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831837;
	bh=CrSb0tZyKJ8U3KxfRB+n7HCYZczD6E8ZoLfABve56Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H682IS6jP9ndUFwHsHep8TRJjIC4kd8LOjQFx4RW3TVuVENnYNTYHjkYcbaob1cAT
	 96zbY5E8Wx+10bsZTdSpaC7Kh1lpjvMROQ1cEcHluFTKvluES/B0iP2eQvw13Gn9yy
	 up6ftO/Zt3K0pWBMv1ZepC3iF1Ipz2EusPmV7Zcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0893/1005] nfsd: Fix id-to-name cache entry leak in idtoname_parse()
Date: Wed,  4 Nov 2026 16:10:26 -0500
Message-ID: <20261104211108.229892638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 8ca3b74c0c447af17d0e27e76658a3d4cae3c5ba upstream.

idtoname_lookup() returns the id-to-name cache entry with a new
reference. The name is parsed between the lookup and the update call,
and when the parsed name is malformed (negative length or longer than
IDMAP_NAMESZ), idtoname_parse() jumps to the error label without
dropping the reference returned by idtoname_lookup(), leaking the cache
entry.

Release the reference with cache_put() before taking the error exit.

Fixes: f9ecc921b5b5 ("[PATCH] knfsd: Use new cache code for name/id lookup caches")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260917163154.2162438-1-vulab@iscas.ac.cn
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4idmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -252,8 +252,10 @@ idtoname_parse(struct cache_detail *cd,
 	/* Name */
 	error = -EINVAL;
 	len = qword_get(&buf, buf1, PAGE_SIZE);
-	if (len < 0 || len >= IDMAP_NAMESZ)
+	if (len < 0 || len >= IDMAP_NAMESZ) {
+		cache_put(&res->h, cd);
 		goto out;
+	}
 	if (len == 0)
 		set_bit(CACHE_NEGATIVE, &ent.h.flags);
 	else


