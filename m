Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040822;
	b=0S0WmuAccJnhz5Yipd+sMpKg8MJKpP9ErklM1+EvB82pSPQC9XNA10c7isOi0FgP7wB0
	 fhMwefimzheJ6f31QutHdGJuMU5DN6ihvvosukXb7fCpgsCARf2WMsj3ymt1hohA4hlzW
	 gl/oDWNTwBORylhziCuxUZXgcAi419N0lITN7CP7jZVDfZNpit7iqMIoDNzA73dvLI7Yc
	 H6KTpeJRbXKBeaUg6xppp/YvPEl7ZNI+FORAPaUstQZqnrtgi3Vw9tseaNFsfPvLZAHzV
	 18SAy27cHuUzefwrmNiR6hq9Zf8A2SqE8Nozpi++aHONCJG+hMtUnA7JqtutRY5HEGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=h09sRCEOfmK/bi7GocErf1gwXJ/SURo8RGoBlq+Vx/g=;
	b=EnJP1h/166q9vnE0ZtmuPtEWpifzSCobM1KZvYTnwZfscoKbg+oHto1KAegPdXrL1dea
	 jgugSCtiVizpDLnVAh33Fsl0KlzyS8gyeteGY8xtUmo9gNXlIfr9y78c8UnJP6ufiUgcS
	 7AkmSDKl6YHdyxYzABWZ2IsHh9hBoo5xfNWZNMr8kOdrP6isC98xKZ3+X1XpmJTMOKEcP
	 kFyNRBdmcdXd68c6mlXyCYB/mVgnigGIxhZ1JpXfS6eCf0IdtCUWLfJ8KD5QEP2Asa393
	 IF2xcbSJaGubMNCRadDPj9gpcXuWHbpIw6qPaoebkJB7W9Y3x1yWWCpcKAktVYZ/hNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mD4R+Ot+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1803606A31C;
	Wed, 18 Nov 2026 22:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mD4R+Ot+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EAB1F000C4;
	Wed, 18 Nov 2026 22:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040822;
	bh=h09sRCEOfmK/bi7GocErf1gwXJ/SURo8RGoBlq+Vx/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mD4R+Ot+E7VREJAAWIfAnjh9AfAsQsUt0DTlXQpJOIp3o5LK9iDoXMre7LRVqkzhL
	 60eewzjpoDpTP4irmggnc43kf2vGYOdPrSq12Pc6/N7EtKRpatVFKVmkbri9rPSHq9
	 d2bezgDKZrXk2QM9gkAIrwyuQbVfWymNYnRVQxus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2595/3318] NFS: filelayout: calculate dense stripe width in 64 bits
Date: Wed, 18 Nov 2026 15:53:37 +0100
Message-ID: <20261118150439.017000870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9ba13ef0e3ad033d3ddbaeb740b12d135a88363d ]

filelayout_get_dense_offset() calculates the stripe width from the
stripe unit and count, where both values are provided by the server.
Their product is stored on 32 bits, and can wrap to zero despite
passing individual checks. For example, a 1 GiB stripe unit (0x40000000)
and four stripes (4) cause the following div_u64() to raise a divide
error during the first read through the dense layout.

Update u32 to u64 and use div64_u64() instead of div_u64().
stripe_unit is a u32 and stripe_count is limited to 4096, so the
product cannot overflow a u64.

Fixes: cfe7f4120f8b ("NFSv4.1: filelayout i/o helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index fe6daf526ac0b..15446f6a863be 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -55,12 +55,13 @@ static loff_t
 filelayout_get_dense_offset(struct nfs4_filelayout_segment *flseg,
 			    loff_t offset)
 {
-	u32 stripe_width = flseg->stripe_unit * flseg->dsaddr->stripe_count;
+	u64 stripe_width = (u64)flseg->stripe_unit *
+			   flseg->dsaddr->stripe_count;
 	u64 stripe_no;
 	u32 rem;
 
 	offset -= flseg->pattern_offset;
-	stripe_no = div_u64(offset, stripe_width);
+	stripe_no = div64_u64(offset, stripe_width);
 	div_u64_rem(offset, flseg->stripe_unit, &rem);
 
 	return stripe_no * flseg->stripe_unit + rem;
-- 
2.53.0



