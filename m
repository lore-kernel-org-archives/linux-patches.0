Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208041;
	b=175eaFyvd64ln0Dya1fB1WOHOqnsMdZC80JiUNc378rUOqz2n6MOsNRLQIHiiZ1tdeWt
	 LTMSRmJgBhpITYd8whzCnTf9j+jm2REGSkHKKrmmw8XjNkooRTyuADibzHB/BkEgUGr6h
	 y34vDED2Wp61qRkPiMngGQEjNI7MsdthYH5/cqU4wMeseDfVl9TeujDP8MdXn3kvIsHFl
	 9UuFS2W8Rn2tKnLaGaOoWOENX4UikBEGyzNSeVNBqvC1a32qEP0m1XmeKFydVpDn7q+8l
	 KRvhkjuJlKC7sUV7EFyEPuh66QTQwExjnVtG5xzVXOn8xzwLrvBFNKEXXuQPGCCgJ4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ER4N8D1r3weWufcvNfuNsGzjAGSwMsLg90NO/D1j2Zk=;
	b=thG450AQ+LTLcuhNEAne3sSsCk9NdpI/eYzdStxn3BFNloZqWIO5i3XXcldNrmo3gJo/
	 VAnijyv+B0/V0+iqPPAnnGwKIgrWapnS9gRpNrfBsvGUJapcQZy2Tr/a57tRXic1r18kM
	 hpiZN2lp1b3e+LdEx+bB9RA38qpi2FHCh/NvQq4Y4Wv+gRYc+656yQXTCeNKMfTrseQIV
	 y0pEZ6dJb1wwbYmC0GWtWX3EWp6ipZqSpz9COMqDNad2PgQ925H5+QHuR8mXYS6CQ5LKU
	 KF60Ztu1MC3/oOZhkVDfkYRFcb5uewTpgKZcJTxOf2z6fcPGdb7B0B5y8Fo7DNMT5mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iybFg9+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC070606A31C;
	Wed, 28 Oct 2026 17:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iybFg9+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01341F01828;
	Wed, 28 Oct 2026 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208040;
	bh=ER4N8D1r3weWufcvNfuNsGzjAGSwMsLg90NO/D1j2Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iybFg9+2oQDKq9c4dv5ZkmeP6bRJxovUozHgBoIcUdI7q/OSq3dfxM9GiETod0CHl
	 RBb1I1O6wVvreSkl7lNnEMicw+hYoLNoQvjGpI7R6W86a5gifAki9gp9ziKYiSqTGM
	 V6tCnTCVzhyJ6a2I7lJCNmnPWYlzi8Q5Aw2jGG0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyeong Lee <jylee5498@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 229/247] io_uring/waitid: prevent cancel reference wrap
Date: Wed, 28 Oct 2026 18:00:32 +0100
Message-ID: <20261028165952.844089325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -161,9 +161,12 @@ static bool __io_waitid_cancel(struct io
 
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


