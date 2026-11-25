Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623522;
	b=BIkM43rkY5iz9BjsMciGb7Qea20TyiJCDb+p6p+H6gyU3JIsvuniYqDryOKqzl9zSFXE
	 SRUISOye0xTvU81UsFle3JBf3aCLeIcJbPsreDDqTXXLSHmv/KkzgmZRj6yR1UeItkweL
	 AhXiGLRyaYtC/R48yRtMxsNv7vwF5CpzCbgWQvZUkrnR4Yp4a1ZoCRlKa4HW2PdwNO4CZ
	 oTgyXpQ77UMpAwj3QDZqFsgDInOLdLfJLLGuOQTzdyF80IJ38MaCw8uRe2ryO+VfOFU22
	 c416FNeXnGcj5/4NBIpBaer3tc4ROgEW59BzmbZ34CREY1atL1NkFu3SnS6g+yvvSvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hQdfBYvZ4t4vtwQCQNouxTTjr84YjXtYYe05Ou8iPo=;
	b=k5HaZ/GhxelpFTWjKBrjzKFp049CX9o5CUV87gRC8v1LF0q2dP6nGPckre4ZNMb6Roat
	 xH9GA1RLojJni4Ukgg9PyMmDTV8CKfLDUl0ggSqpyz5qkigVuAzWXRAC4N+sSCkQev4UK
	 7ZWBG0evTC4EO1uyO/p2+dr9/7KSgSXr0C1bHPN/RVbNlES6aaSQRAa91AtXmB2UbuhRJ
	 ox/Ab1Jcb8tsNCMeO5A+Ys1sU/Fmzzi1lUsHQIt+YNqE6dzg/W6hHU0/bZF+r1+yMdx2o
	 IMDjglycaR/jhSx0hpRK9bxiKtcxBEmOCwgDfB6OEdzAFPVGV5/7VWaZsW+WosfiuYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uN/WtHXZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D46606A31E;
	Wed, 25 Nov 2026 16:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uN/WtHXZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A811F000C4;
	Wed, 25 Nov 2026 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623521;
	bh=+hQdfBYvZ4t4vtwQCQNouxTTjr84YjXtYYe05Ou8iPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uN/WtHXZVfAA5vWpNlJRjOdEzAW/0VAovZUnJz20skkdfd1oWlCXNmRBOJ0mJI8Yo
	 oPtKFpYjdCzNfJCzhrSloVCSnOVG6oULmSH54UzPp34xX4bB7+duimUZixNBr/OSOE
	 uHci2RuJ+GDed3PDkgjh68Nf5lnMYF8PisYt6eFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 880/990] dm-thin: fix parsing of feature arguments
Date: Wed, 25 Nov 2026 15:37:27 +0100
Message-ID: <20261125143842.630190459@linuxfoundation.org>
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


