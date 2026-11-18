Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035404;
	b=AZYz9S0KXaU4XZvTMPUGj0rWAvBXJdJvQhvjJfgOEfe0MqrdPE347Dy1YEeE6ABEzBIY
	 JlOKq91Yz2FJJSahzruKThc3JPzwFux8juAAmTfeATLMyTpawwT9bzhV3inaY7+AsHqi4
	 WQx3d8lKz2SuY6rJidXdBjyXsOXpNhn8cKN8ZqKemL6gRq5Nx5+fjU2Ti2auVyXXqpyeA
	 WUOuo6DCxi2BbGzzQ1oBdys/6GiO28l+b4ofnHs/O/wpbUrxHM4WCYKIdXHdNkOaN04rV
	 yh7luem6SFuJgnkHcTfykMTMAbLPGOG9QsW2Jm2ln6hfqEljqgeB1mtPaOcMJz4g1Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K7jT2ZMLUcxfaElofyPdeIMdtn96XFa+VqZ8sh7W0lk=;
	b=ThXbFUT9WrAEe7P9+a3pTqVWvgIn31ZB7D8SY7l8v8Gj+Rvww2UXtpEjuWGm8bQdOyBi
	 49RR3GHItdexv1sRkVRHLrT5TSnN/04cydLWtIQoKBCPABeRnweC1plnfvULfeBceLHvw
	 tbQR0T45hOzW8BP9U/GUCtUJLsJzABIj6v8WuBWPvnm8dPT09wbqhxxn6Un46VTyyNOI5
	 4UN0FNFl4rvgDvNBYziIB990aUXd5afk2TFrRqYlkm28owReCwR5kAjm52MTsV/tSxy94
	 uNXm8XWleGIa9umIQcBAB2RWEKSA/BTHwYjqx43+HOuKfbCNSozOdmDgry4RBo89CsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4z4AF1M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2BF606A325;
	Wed, 18 Nov 2026 20:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z4z4AF1M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FC51F000C4;
	Wed, 18 Nov 2026 20:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035404;
	bh=K7jT2ZMLUcxfaElofyPdeIMdtn96XFa+VqZ8sh7W0lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4z4AF1MT708jEz7tZsqieAxOc5wQGRN6ih0uozrui3trJHkFvn6J1xOHKxSzUhia
	 MIy+OCpZ8HrBZRXOMlEC85HWUYgg+uF5JrJBgrRz9U8HTc4WKWH7JMCz2hLAA3ci2P
	 tS1qFD7kOIeCR0JZt4ZvagqFeQlgO5b8iF/bSHyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0690/3318] NFSD: Fail a pool_threads read whose reply does not fit
Date: Wed, 18 Nov 2026 15:21:52 +0100
Message-ID: <20261118150338.951078088@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit e27c63245903402ccfdb46c576462981a7e032e3 upstream.

The reply to a pool_threads read is the list of per-pool thread counts,
formatted into a buffer of SIMPLE_TRANSACTION_LIMIT bytes. snprintf()
truncates its last write and strlen() measures only what fit, so a reply
too long for that buffer ends mid-number with no terminating newline. A
pool running 4096 threads is reported as 40. Nothing marks the reply as
incomplete, so an administrator reads a plausible but wrong count.

Take snprintf()'s return value, which reports the truncation strlen()
cannot see, and fail the read with -ENAMETOOLONG when the list does
not fit. That is the errno svc_one_xprt_name() already returns for the
same condition.

Suggested-by: David Laight <david.laight.linux@gmail.com>
Fixes: eed2965af1ba ("[PATCH] knfsd: allow admin to set nthreads per node")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260812193349.13347-1-david.laight.linux@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -453,7 +453,7 @@ static ssize_t write_pool_threads(struct
 	char *mesg = buf;
 	int i;
 	int rv;
-	int len;
+	size_t len;
 	int npools;
 	int *nthreads;
 	struct net *net = netns(file);
@@ -499,9 +499,13 @@ static ssize_t write_pool_threads(struct
 
 	mesg = buf;
 	size = SIMPLE_TRANSACTION_LIMIT;
-	for (i = 0; i < npools && size > 0; i++) {
-		snprintf(mesg, size, "%d%c", nthreads[i], (i == npools-1 ? '\n' : ' '));
-		len = strlen(mesg);
+	for (i = 0; i < npools; i++) {
+		len = snprintf(mesg, size, "%d%c", nthreads[i],
+			       (i == npools - 1 ? '\n' : ' '));
+		if (len >= size) {
+			rv = -ENAMETOOLONG;
+			goto out_free;
+		}
 		size -= len;
 		mesg += len;
 	}


