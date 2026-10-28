Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209840;
	b=kE4Bb9Nxe2TnmrE/H0vR/Yu8mhzA2K9jKq0QDsXeRQBCgA6TeGs4fXapIwwtpUSaKNOj
	 K7Yg3EOGwoi8/071H4Vono7+pCS9xPr6nmYiTv7gNk436+kmO9IcvpO/8IgQZq++cb6uQ
	 TzhqZ7wTvd8K5BN3oOf0hrUWP35O/jVcSGx+ndfs7ssY89hH77StOTcwwfx/dAKLOtXbV
	 qNbJ07ZA8mQuTKaavRNReqPDAfJsVejCkVeCpJPMxU8iLBMHNC+jCLOeTKO52Ww13FxxP
	 0RRieUeRadbTffrd+sr51uj2x5UbP1hVgQAMs599sGod/uM6fU7rqNsNYUlaYg9E0uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209840;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OqCEs/Qeh4eU73a4useOuKUIPXE+9UOiplqFd9dhKik=;
	b=n+XJ367z2U6vrZzmiNMqzSzmveYS/Xg2dd+3cZW+UcU9UFI2hwpqXjkG1E62ThoUzsBs
	 e/FaoX0uZSVl89O1mHYsnFMc1S1a4stNoCt8Wh0TPAF4mUC5xq9eCUMLDBNUAg8YJ7j4d
	 S5g3W611JuLOljc1mlJkn7D7VJOBKSG1LUnPnDPON6Lkh78HgsYlUKNtAiaKyrrNukDnh
	 +XP0gZNCr7lDiW/TcaytjgV3HHVXl9dNzqRjftBl3bp5cmyWwzp95WdBNMYDV5DIWmoc9
	 5mEIFFV9JxJyup/E+XTCCtd1no4EF/VeLjILLx1zGL4KT2Z9DtRPRVONQ3qAu3/DKAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLiisZRa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA77D606A323;
	Wed, 28 Oct 2026 17:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLiisZRa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173B61F01828;
	Wed, 28 Oct 2026 17:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209839;
	bh=OqCEs/Qeh4eU73a4useOuKUIPXE+9UOiplqFd9dhKik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLiisZRaJmk6jnLL1l/gEObsFmu46BSr8AqVcergJn8F7opTlRHg9JSG45meYB2jl
	 BvrSIvNH2j8ai2vSxvP6ZcipO8p0dswBqcoKMEi3s6hTddjrHShFXfb+XeNSWKS3RH
	 X8eo8pTz98rvMPkn1+mACFpmzSsHwTHZ3viYtnxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyeong Lee <jylee5498@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 088/109] io_uring/waitid: prevent cancel reference wrap
Date: Wed, 28 Oct 2026 18:01:12 +0100
Message-ID: <20261028165944.427873638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Junyeong Lee <jylee5498@gmail.com>

Commit 98787d3fa4e99564d2b2bc21255b21f670c450d0 upstream.

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


