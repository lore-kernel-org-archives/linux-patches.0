Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705555;
	b=cDB1dQRKznYV44oywTs9wq5rSQZ5/Ox7rMnOJOx1SEpdhD/mOoDRA1OIBWU6486NLkF4
	 jKTNe0mLRkM1zFaGUAt+nlJ95ydFG0sdV1Iiz0HEnzmAT5ek4kfrfqym/GwBklriThQB/
	 bz+fQXLG6jiICUB9UMkQ3i6vNMhEEbbqgwqM/fJdCXDkWldHGm45DsI6G9ACnBNn2mNq5
	 wVvMGaydv/+Jz7zoNcvmwrcf+knoTDbApm/jWf4izdkwTOiTKUz6dJT+q+8gugCNjZ/4I
	 ijCmh9pzXPgxUzWsUVYOevG5UYcpDuMacJ9V3l8VD5n7LDdDHUamj7hrVygwDcCCsdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=q3Hk25enk2XYhexr1xizJaSwiP6CU05N+TkDBYiXg7A=;
	b=Qz+iRuwbBf2xa5vf8y+tIFn5H8HLAPOLnNRtwp542FaxI3xt9AszktIZGTduG2+tr5+J
	 hmHdHE0igx41o81KFkxJ4XGxNCk7yqhs9Hkrrp/cVqPfmyKQfWCJOgI3Svx3R1/MKGAMc
	 HFYXz7MuTccgsKyPmdA4vNQkJXW2qAgZW+1brEGgYt2ZomJhQxwXDhiZ3wL3yJg3mtCvl
	 hRZfMkcuZkGNvwXfiYnuAWK4myUJj9+tQkTjfPxVjzFiJt66WiAHStOdUD6VBmoN3Aq/E
	 mB+SipCEbP0ohi6l5IL4z3Cab1ix+H1MyjtGA1fDpPlw9VbMRaj0v3KnZHCDCcw6X+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeQ95a0K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87210606A321;
	Thu, 26 Nov 2026 15:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eeQ95a0K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F45C1F000CA;
	Thu, 26 Nov 2026 15:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705555;
	bh=q3Hk25enk2XYhexr1xizJaSwiP6CU05N+TkDBYiXg7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eeQ95a0KWsrxZCyOu7B2f65Wlzk+mVpJLaJczl6U3EMM6HLriZl0pEod1c2wvxWjY
	 n7ZmgYox7yHuItqvey2CR5tXJtfER7R3TBqI/QvZWwbiVHanqx9RadYqoraPBfTC1S
	 /Ws3/F3FhA0HZ+1L42KwDtncWctVucCVQdKrdk84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 220/319] s390/dasd: Fix wrong free and refcount leak in build_check_tcw error path
Date: Thu, 26 Nov 2026 15:39:48 +0100
Message-ID: <20261126144011.711962585@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit df56f7a6c20a5eb2794c0a7391bde50ba7c8c54b upstream.

dasd_eckd_build_check_tcw() allocates its request with
dasd_fmalloc_request(), but its out_err path frees it with
dasd_sfree_request(). The latter uses a different pool and therefor,
leading to invalid pointer arithmetic and a crash.
Use the matching dasd_ffree_request() instead.

The same error path also leaves start_priv->count incremented
without ever decrementing it again.
This leaks a permanent reference on every build failure.
Decrement it before freeing the request.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260722103704.1709668-1-sth@linux.ibm.com
Fixes: 8fd575200db5 ("s390/dasd: Add new ioctl BIODASDCHECKFMT")
Cc: stable@vger.kernel.org #4.7
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Fixes: 5e2b17e712cf ("s390/dasd: Add dynamic formatting support for ESE volumes")
Link: https://patch.msgid.link/20261112102608.1057852-4-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2618,7 +2618,8 @@ dasd_eckd_build_check_tcw(struct dasd_de
 	return cqr;
 
 out_err:
-	dasd_sfree_request(cqr, startdev);
+	start_priv->count--;
+	dasd_ffree_request(cqr, startdev);
 
 	return ERR_PTR(rc);
 }


