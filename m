Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207377;
	b=Qzi8ijJlZSzrcn5S7hedQmtvVc2j7hpQYQvSrbWOrn5d2pfLWZzlcaXWsGNEOU/Eksr6
	 KizYGgkUw91iL9qg/jBkmJ5IXNhbluz06pc5BH65pTAzqdvXUPXSkUngDCoKlMndlmiHD
	 taIhycBjwk1BiQV0JOdEY6WKNstRoFh5cCxVE/rAmPYyxUrwXS4wvCn1DodWf11b1rfv3
	 WOB4L8AK6KoulePKfcx5sI60oAiazThfz+PPhoeUC36GE96vjiVcypeQuOyvd1vmy67KG
	 1IR33LIbNtzvWKj6QSmYQ0q3xjB7Jv3xXvTmBX+MC+jD4WeYqUUbE9RtZRhyQ+Y86JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vX54YBdqC1NTk465lxGrlAXdSJL3jqwpmx8DS3eDp74=;
	b=NWTsAeWneaEtRkKuw8xUtOeSvBMB51K/Cl9T/knLqVwbGino2vEov2GI8HbAYfRIQXzP
	 u6eJebb8Rp8P+nf6DxzOYtIj4xGH37PF+nzAGTnxk4uBucKnPh5+Zt+z+TL60iHZnUbJU
	 tY7do8oyAkNjVn+9WAbsFl4L45TX5umri5kL8g5kzp5OUNB+zfyyXs0JppPWeSUkQNq9n
	 bt9cZ85a+zztiWjqAhCf8F9S5BiRxb/+U8PXt+JKWT52xGdgo9NQ1UAhQwjCgE/pK+ZXg
	 LoAmKv7aEnuZ2igz20cCBZRXvp5Pvof/25dC0k4x1wd99gjCguFgqC83+3/A9mFEBxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6MIBOqo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996E5606A31A;
	Wed, 28 Oct 2026 17:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E6MIBOqo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A006D1F01825;
	Wed, 28 Oct 2026 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207377;
	bh=vX54YBdqC1NTk465lxGrlAXdSJL3jqwpmx8DS3eDp74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E6MIBOqoy7p3N0dYtcGeyGwmku5FHtPN5XIWuBkbPS++yA3yHjSBn/L8KLd5iP/+G
	 CqQohSflRodd0vMF7zlZ3XITzWy/RgiQzBKc1AGxjvJdLzEhWnqlFJzax9j96dpSKj
	 W6o1ift5LsjEKqBWEx+BBJK2Z0Grvkp/fLhxS07Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyeong Lee <jylee5498@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 67/88] io_uring/waitid: prevent cancel reference wrap
Date: Wed, 28 Oct 2026 18:00:15 +0100
Message-ID: <20261028165943.693500446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


