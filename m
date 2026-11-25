Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620325;
	b=B+iy5w/vnVISZHFD7wnYY/0hFS41j5RThGD8Fspavra0mb8Ya89TExJs43dGSrKgY7ju
	 VdPJvC9wIJT2+PvYDLBHoXey7zVMUXIinhEfvzAWjHHJYEAcSkI/k/k2r9lUKqbXALwFq
	 8R021oj+DwZ8pJG6C9TcXCom8bWGTfzIS/D9piZk16I7J5tnurOEyiZzpu0iN2Mxv1tM+
	 d1v3x2Dzh/ZeUSMgZahrcTvLcNr+ZYZq1rGkMPYCQs6yR0QF5MRpt1hYYn9UtrmXbShsu
	 2s2ntGq++77ZPMXH3q5HIX1cSGrDp3dPJewFZe7LgXbgCsCoR144J1185n+zdJUjbxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J34phrA6g2ZA+J3JVvleoaRen3e34DkTBGhSFiyQMPc=;
	b=NXOlIGSNmBsLSSQilL0Fiw+SapIx+MR/cyJk4i3wkzdx3mQqYejYJeAfUZefYKXCCWeX
	 aLkciE+az1guUjtktGLVHMWNP7oiCJ8DZBlhoySDkSeKMf6lbWxF4nFlFlTc0EAsOZUZ6
	 N6ZlcXDG9iwaXLGHCqeixqZPt3tocJ1rR6qmrP0hI+Sl/zbQsl/PI4xK/uTyb7lyDqxnj
	 RvuFthy95XLFhXAHSJ53uHllXHv4+lyBc63kQJT5EAdhao6XpdoKXK9e0pZCvP45qUUaO
	 iyr+RgKT4EG2+gjyUuvGc+I1RhY7QsXMmbdUKyHXoRTAoWkLI5P/KNnIIJeartEiEoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVQ0GndS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875AC606A31E;
	Wed, 25 Nov 2026 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVQ0GndS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778911F000C6;
	Wed, 25 Nov 2026 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620325;
	bh=J34phrA6g2ZA+J3JVvleoaRen3e34DkTBGhSFiyQMPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVQ0GndSY1qRaorU7j+ItNRXYHmWiQ3xwwFUNtSQpy8eJSRJoWcfPDcE7lgA1iat8
	 cBUI4yhbpzBsV0K2SEvhNVv5Riu6D8gvR/JiWXBr+3jMW9eUyYJsqYCdDq5Ov2InXb
	 76nlGNvjbpoc2NiyoGXZw6mSKEEfS93EasQGjS4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.3 0878/1005] dm-crypt: defer async write submission to write thread
Date: Wed, 25 Nov 2026 15:36:56 +0100
Message-ID: <20261125143842.271955436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Josef Schlehofer <pepe.schlehofer@gmail.com>

commit 6fed9e26810f0b466dbcebe35a73d1fd48793ff5 upstream.

With no_write_workqueue, kcryptd_crypt_write_io_submit() submits the
bio directly, even when called from kcryptd_async_done(). An async
cipher may run this callback in softirq or with BH disabled, where
submit_bio_noacct() must not be called because it can sleep.

Submit inline only when async is false. Async completions are sent to
the write thread, as is already done for submit_from_crypt_cpus. Use
the async flag rather than in_interrupt(), since callback context
depends on the cipher driver. Sync ciphers still submit inline.

Tested with cryptd in QEMU (x86_64 and arm64) with
CONFIG_DEBUG_ATOMIC_SLEEP, and on a P2020 running 6.18.55 without it.

In QEMU:

- 4k writes logging "sleeping function called from invalid context":
  100/100 unpatched, 0/155 patched.
- nr_requests=4 on a loop device: 0/6 unpatched runs completed,
  4/4 patched runs completed.

On the P2020, a warning in blk_mq_run_hw_queue() appeared in the
6th unpatched run and did not appear in 30 patched runs.

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Schlehofer <pepe.schlehofer@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1964,8 +1964,9 @@ static void kcryptd_crypt_write_io_submi
 	/* crypt_convert should have filled the clone bio */
 	BUG_ON(io->ctx.iter_out.bi_size);
 
-	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
-	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
+	if (likely(!async) &&
+	    (test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags) ||
+	     test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags))) {
 		dm_submit_bio_remap(io->base_bio, clone);
 		return;
 	}


