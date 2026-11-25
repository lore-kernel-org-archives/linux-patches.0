Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626058;
	b=hU0WkB3LLQMRgaDr6l3lSiWMk3sjkQkf5Filt/vBNvHlWh6hs0iHxts7j9vnUyUB5QlS
	 TPTJ41s+Cct2Yu7bWV/rHcrrSWC6Q5fRyAsMqePQjpEbJvX7FZzNgif3YN8xrrA0khwl5
	 73lX8qJFb794tP1HjiEtLsk4drJL1olXM2rXJibanyDv0yV5uEe3Fsht/BzTOBtE3zslB
	 DIS7yXDUfeMEuPc5X3XVmE7vW7WQWxJUXDqF0jDvrbJ0Q5c8mVBH0wKd8+l6fI1t4teWC
	 /3vtTeTC4s4SAbmLQuBBSKQZ3iODbt0/Dbsbc2yMOrlJdipUA77phTqsxS3DltZR29A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjBTty+LXCBTpBCxy9a61wY5DrJEEIZpu/yVbm2oW64=;
	b=ynpMy5DTUdMbfsjdWH1Du1aqGW2iTMYKdXIEviroPhepE1GlcbT+A1s5/qemb4K+Ui17
	 vxGa5JujSHHFI0D9Q31D0UXiIlVfjhHJ1R6C1m8NoGmvVjOaLFY/4dDgiQUf5mYhpKziC
	 cF1IGiTLpQXu2qSePBwehNuyqMmpEZmnOCoP1cwnGepsLwPdKzZS4YZqrh5E1WwouMD7u
	 6tHrjL+PoX2R2G87c7MCjJSRYMYIbAp6LGc5i3L7jwhF+92ELPcR2lHOD0WR7ntbJbCsT
	 aTv8+LkO6Lmj079Mj+mPIx0pIuDltQB7sSlrwO/Cd/jufR33zBjPjtZxjmrqqxB5wBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+YPWggv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D27606A31E;
	Wed, 25 Nov 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+YPWggv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DDB1F000C4;
	Wed, 25 Nov 2026 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626058;
	bh=JjBTty+LXCBTpBCxy9a61wY5DrJEEIZpu/yVbm2oW64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+YPWggv09/qZtOhiwJwFFtJcYdhJUAvSecZc1rbviw+gnqKZfzhowiHL9D9e7G2I
	 oWgpsh8pPgRE+FKCmuaeeF4jW2wdcN86Nv0RrdzRkLb0yoZwg8jfQ8scX+SZfQGatO
	 lofiIF4NQ4cp/RFrG0JNIFSE3vYrH9PpWuwOBM6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 719/816] dm-thin: fix parsing of feature arguments
Date: Wed, 25 Nov 2026 15:37:47 +0100
Message-ID: <20261125143905.819612761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c557fa19a83efad1e20eb733df821b745a4589ff upstream.

"struct dm_arg _args" limits the number of arguments to 4, but there are
5 possible arguments that can be specified.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 787a996cb251 ("dm thin: add error_if_no_space feature")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3151,7 +3151,7 @@ static int parse_pool_features(struct dm
 	const char *arg_name;
 
 	static const struct dm_arg _args[] = {
-		{0, 4, "Invalid number of pool feature arguments"},
+		{0, 5, "Invalid number of pool feature arguments"},
 	};
 
 	/*


