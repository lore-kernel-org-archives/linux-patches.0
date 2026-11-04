Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831784;
	b=K8VeCoJoas80i7dJBlGpiUq3rByVczePNUTUtYSSXNbM4T40GQwJXECQvbiHVAa2v+6K
	 5CuPCyP/yrybmhkryEBZzYloiBSFD2QOmt5QsEKAcWIDGgkZ5Aq2zIMbhUxNgT0ZGBrAq
	 LUjAITFbFG2V8wluM0ZM9V+N2828ua5onLrNXwLYxw98udK8+GImelLZDqWNxLePhGTyQ
	 8g58hzGQHbM+ryI+8om3w41ZyRWNGQcGT/PMl2DIxnndlKStTXcjTvV78fIVsgAzqeT+A
	 jG5RpM1PdcXLqywa2vUwneDxYkgtSZAKzbnrp7JdAoIOHKKMVHIXTmi07xKCRAVuKYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xO+twGPLs4s5FfFQ3PrS266ozQRcxyjK3i7f4cH4voE=;
	b=hxtreM7dhk5jwppb3U/MQZtZ8tm480i5hVwWP6gnriEfR/ZTX5Eu1yYVZNc4d+s/BHzL
	 but5I173073wel7skauVSi0QKU5xD4INxyrI1dDdNlG4h6pT3eKdVv6ylZ7QxhE5JisSE
	 I53Sll+tWWlgXD0j6xPEQKtaasYP6jliPkTCmh1pofG6DKyOTCKLYcZQwkiv3tJYUYJoG
	 d9nbGoI9qY0qnVVEm0N6/gb9z5JvHssmMH+W6Bxx+9yg97UiLthS6ePY3OQqAph8lsRVQ
	 FelpMvteQA6dYNkeNL9btRVVo+7QKZEKoDYBgaWz776ZqPG6lwcYfAp9hxiQd9V4ftA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JypF36Um;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E79D606AC2A;
	Wed,  4 Nov 2026 22:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JypF36Um
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF69C1F000C1;
	Wed,  4 Nov 2026 22:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831784;
	bh=xO+twGPLs4s5FfFQ3PrS266ozQRcxyjK3i7f4cH4voE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JypF36Umg/lvDaAxrgtXhNSOutwLDZKqUUjhPjNbAv7XhSGDrIn/sguxs6U5/VTdx
	 TYdpk81lZTeQ6lj5SAwpgvc04Bp0NbY0dCF/OZ7HbpsEGd6BI277yzeYFAtrfOkmxw
	 XwIUOw5/Gy/UlZ5i8m7Ijt/s8AqaZdmC4HpxR6ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0910/1005] SUNRPC: keep the first error in svc_register()
Date: Wed,  4 Nov 2026 16:10:43 -0500
Message-ID: <20261104211108.661986314@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit 9ed91d7c4698e611ea5bfca45076008def831fb3 upstream.

svc_register() assigns every pg_rpcbind_set() result to the same "error"
variable and returns the last one, so a later result erases an earlier
failure.

Keep the first error instead of the last.

Fixes: 642ee6b209c2 ("SUNRPC: Allow further customisation of RPC program registration")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260901-nfsd-nl-hang-v5-3-a540d86668b0@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1236,13 +1236,16 @@ int svc_register(const struct svc_serv *
 		struct svc_program *progp = &serv->sv_programs[p];
 
 		for (i = 0; i < progp->pg_nvers; i++) {
+			int ret;
 
-			error = progp->pg_rpcbind_set(net, progp, i,
+			ret = progp->pg_rpcbind_set(net, progp, i,
 					family, proto, port);
-			if (error < 0) {
+			if (ret < 0) {
 				printk(KERN_WARNING "svc: failed to register "
 					"%sv%u RPC service (errno %d).\n",
-					progp->pg_name, i, -error);
+					progp->pg_name, i, -ret);
+				if (!error)
+					error = ret;
 				break;
 			}
 		}


