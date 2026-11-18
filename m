Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044556;
	b=fZWyXPBNeInEcJbn/U4flcP9Vvl6QSyvw4csr4vtWut9Q4GEPoONmNlhJa82Nq8V9m6+
	 uQTnt4PNwqjzWawREgyjvgL8pEKR/s0FTSFwiEzpQXcDe2gImMurHQazD6RfZWwcELuTe
	 FW7W6RcwshUBZoioNGAEw1cym1SJHdFGkvuXHQJcCdJULlUvwWp6I8y+vtOiDItggwbBr
	 +DaT45BDuzjL0BPrDC1mfWhG5Q1Ghx0QyCcTygKHQIriEGHgIsb3NNkUrBcwU7Yrwz7yv
	 v+04z6in1o6PVo/o3G1GtwEJIgtgt3eKm3PHiZCd/az6c6wPQNVoKWnRbhOioxoTOgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CvbNaCYZ8vA8lAesT5gH/GJGfmTxKPP9nbNa79QZHe4=;
	b=20iv6EY6N7FcR5FYsstO8v+eu6zNPsehlJp6daZDcrbpxEUgMkGa4N8gA8r3f5wgJwkz
	 GOExFOXYR2TK/JxLg7MLvNl8ZXzwjRJzpotJpbelkafcNuNYavJ7jQddFS4cRq2yN+exf
	 kDP/UrJt+E1f8MZR6CNver3SyrFxiwXvtgA0ynGqLy39CFS817lFndv/7HGQbY5b3Afyl
	 UKqkFFvrQzJsjEc+Ep36D5H9L7stvocz2kKm2SktRtEO4LbCcoeZ0E2t9fCFbGUro5xA8
	 9gCejqEnje2Ik7F/LD5pJMofjSAMv4MMcUM5gnGOTYgMyxv+PbokoMQGwG3OAJBn5gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QL+yIHN0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627C4606A320;
	Wed, 18 Nov 2026 23:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QL+yIHN0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7051F000C4;
	Wed, 18 Nov 2026 23:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044556;
	bh=CvbNaCYZ8vA8lAesT5gH/GJGfmTxKPP9nbNa79QZHe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QL+yIHN04DqSH8z1vZwrZQ8pj6huYbh7usskyVRDtLkqkv9bC87UzDeZHl0wsdG83
	 A9nhhBSFLogdafglbcaqesgqgdJLaNAC7/tiOUln4528ur1tbUQkhE3NUCKOtsIr5J
	 mDpMFOVnowriaRHMeMOI/19kacP6gkdnjeMQCOaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0608/2857] NFSD: Fail a pool_threads read whose reply does not fit
Date: Wed, 18 Nov 2026 15:27:22 +0100
Message-ID: <20261118150223.382294888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -460,7 +460,7 @@ static ssize_t write_pool_threads(struct
 	char *mesg = buf;
 	int i;
 	int rv;
-	int len;
+	size_t len;
 	int npools;
 	int *nthreads;
 	struct net *net = netns(file);
@@ -505,9 +505,13 @@ static ssize_t write_pool_threads(struct
 
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


