Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207074;
	b=w06uALJHePWPrM+AkEGG66QvW6CleOgQ7eIoVwTr9+JEBsDYj+M+eTifISUgoSzk291U
	 NWzMN99Qsl7t5TrmGTm68W7y72kFWBCmRlURQ4/D5uBt/nwCDaUPkhGSy9urzlgeVGYij
	 lDJsCbxjDEdZrJi9xt6Ok8JoZGdh0O/KRT5d4WCoZsW7eQtZmHj7VQ8IRMxQBgGWc2+x3
	 JBKhwluk7K9RS7ch6BMGcTR2FfN1lMCuX/8Lgmv5Z1XjiP173R/PSDzCpz1hFvNESOU2x
	 KZq4p/eXpYFdBolet2DTgm4jccph1Qd89Pd0Sf8/OZWd4skWHV9hWcCtMQq5wmPVcvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4OIakcl79qACRvX1ToX66UeBYVRvcV2RLKF+ll7YbR4=;
	b=rW2QA4EuHeV9AUdR7SaOuO8UvQtvk1CFSe5HLOT5bkE2KDTRgE746KhUbWi0dxo63BMl
	 To7XYAyXbEDib6XdPzT9fQYSK/mlv16SyUZ/DqRj+EdrmYu4ss6ln8GoWvjk167bJcVuT
	 m9GZwlPPY7WcBDZISFtzpU7lwGfMBMeOh0pvbWLpzLUhnorWxNDYWW+GMzB3Zsr3tzld0
	 8HvXJt9QDwZmhPDTV+IAffzSK7zQepTNMdXvTjCTYf2qnKYaEQdWv+NitZ8cRWXIJPJkO
	 Ovv9WUPVbiDz9o38Qo7irYsMcuLduFUtfs3WPJ6i0RL0o5iItvJbxrhjaIeLM17UaGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1alxqAp2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E621F606A31C;
	Wed, 28 Oct 2026 17:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1alxqAp2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062DC1F01828;
	Wed, 28 Oct 2026 17:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207073;
	bh=4OIakcl79qACRvX1ToX66UeBYVRvcV2RLKF+ll7YbR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1alxqAp2vgzVHK56KcJiJNmmK39bOia4jPONHuRhEuMs90m5ETHkozOCb7CUzpRsA
	 HwrsHXq9XFB2VX/pO3aAQEsIOslCewX+AZA693krtkwbatjsxJ91/t94+NthGkr1Uq
	 vtlT9qMt/O6H9tCBslgfmxU4mrmps4qs9miV1vL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyeong Lee <jylee5498@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 17/38] io_uring/waitid: prevent cancel reference wrap
Date: Wed, 28 Oct 2026 18:00:04 +0100
Message-ID: <20261028165940.835757551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

From: Junyeong Lee <jylee5498@gmail.com>

commit 98787d3fa4e99564d2b2bc21255b21f670c450d0 upstream.

io_waitid packs the cancellation state into bit 31 of ->refs and uses
bits 30:0 as a 31-bit reference counter:

  #define IO_WAITID_CANCEL_FLAG BIT(31)
  #define IO_WAITID_REF_MASK    GENMASK(30, 0)

__io_waitid_cancel() marks a request canceled, then increments the low
bits of ->refs to claim completion ownership. When another path owns the
request, the increment remains even though cancellation returns false.
The request remains discoverable by cancellation, so repeated failed
attempts can wrap the 31-bit reference field to zero. A later
cancellation can claim ownership and complete the request a second time.

Use atomic_fetch_or() when setting the cancel flag and inspect the old
flag value. The first cancel attempt continues to the existing ownership
increment, preserving its wake and issuer handoff semantics. Later
attempts see the cancel flag and return without incrementing the
reference field.

This makes repeated failed cancellation attempts idempotent while
leaving the first-cancel state transitions unchanged.

Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Junyeong Lee <jylee5498@gmail.com>
Link: https://patch.msgid.link/20261019152100.63565-1-jylee5498@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -154,9 +154,12 @@ static bool __io_waitid_cancel(struct io
 
 	/*
 	 * Mark us canceled regardless of ownership. This will prevent a
-	 * potential retry from a spurious wakeup.
+	 * potential retry from a spurious wakeup. Only the first cancel
+	 * attempt should take a reference for the ownership handoff.
 	 */
-	atomic_or(IO_WAITID_CANCEL_FLAG, &iw->refs);
+	if (atomic_fetch_or(IO_WAITID_CANCEL_FLAG, &iw->refs) &
+	    IO_WAITID_CANCEL_FLAG)
+		return false;
 
 	/* claim ownership */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)


