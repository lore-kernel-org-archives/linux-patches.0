Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A5F27456;
	Tue, 23 Jan 2024 00:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968699; cv=none; b=kTmtkrYWF4ji2ra98pvQMnPSpPlAu0Z8gSLPOqLZXpd6t0B2OFDMIKR1AL0vlM2tjtB41dus9slupM2F5Og6FtcXxwV4RLWuMmpxTwDbk8e6SQJ5wou6BKzQghvqA43YV/7tkwarnLmouKMxOg5Sd4BGFYpmI/OCmoJot6BEswo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968699; c=relaxed/simple;
	bh=KmmyPVdnqknwd200f15r45DvozXxj0oj2bn5wNgpEWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2pBHnJC5/6FHZMGqmK3Ck4KnM9YVeHTGCUxKqK5HwQC+XDEkNAVyx9m5J1HBo+18BYqWgcZy8igj+jbCK7vrWUrpqtfFa5CPakCzVBKkwmGIjLYI7z5+Or7uZ+a5b/baFxCyuTMJEfOXJR3T1k7+2ZBRwpG8pIAGfZeJ0NYetg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CpEitRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CpEitRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87667C433F1;
	Tue, 23 Jan 2024 00:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968699;
	bh=KmmyPVdnqknwd200f15r45DvozXxj0oj2bn5wNgpEWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CpEitRNk/SpcVOPJi2nNmT5yMQf1qELRK40yBxO++oAXDLrFPvroDq8I3jrBdVsl
	 NNxCZBGc0e4v7kIDtHXgaJdq8jjBi9H94jtlwRZJxQLd09dcdPY07cvqXyiETbcikI
	 a5OPP90kIdwkV9MLwzeOcTT4XtRbTyEnddMjaIJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 148/148] crypto: scompress - initialize per-CPU variables on each CPU
Date: Mon, 22 Jan 2024 15:58:24 -0800
Message-ID: <20240122235718.618961241@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 8c3fffe3993b06dd1955a79bd2f0f3b143d259b3 upstream.

In commit 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead
multiple variables") I accidentally initialized multiple times the memory on a
random CPU. I should have initialize the memory on every CPU like it has
been done earlier. I didn't notice this because the scheduler didn't
move the task to another CPU.
Guenter managed to do that and the code crashed as expected.

Allocate / free per-CPU memory on each CPU.

Fixes: 71052dcf4be70 ("crypto: scompress - Use per-CPU struct instead multiple variables")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 crypto/scompress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -79,7 +79,7 @@ static void crypto_scomp_free_scratches(
 	int i;
 
 	for_each_possible_cpu(i) {
-		scratch = raw_cpu_ptr(&scomp_scratch);
+		scratch = per_cpu_ptr(&scomp_scratch, i);
 
 		vfree(scratch->src);
 		vfree(scratch->dst);
@@ -96,7 +96,7 @@ static int crypto_scomp_alloc_scratches(
 	for_each_possible_cpu(i) {
 		void *mem;
 
-		scratch = raw_cpu_ptr(&scomp_scratch);
+		scratch = per_cpu_ptr(&scomp_scratch, i);
 
 		mem = vmalloc_node(SCOMP_SCRATCH_SIZE, cpu_to_node(i));
 		if (!mem)


