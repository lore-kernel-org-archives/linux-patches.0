Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623484;
	b=mvO63vTmA0gT8JUFO5trqJkeSxqrkeFslX1aqb6FY+pYVGRhrYqWtpRngYLo5ADwzqXS
	 AK81hqPpBpiFwgvhDYKaz2YXCA0THfmWVgqswuANH7OuzlzCp+PalY7fSaHABT6ET/gGb
	 9pU4CU0L0MSa+Q26zu1WFKtyXEPu7tpU45E8eoE3XO/yi3zZG2AZzztznll8C0ckNuto7
	 b/lUxACpL3vessr/spO/B2py0hmwW1Y40OG4ILaKf6lOBymQ1zzThO6noM18kPnbcRVjf
	 4rfrHjQdyiKpSi7DM+XbC2RsYsvvpXAX9t1GeFG7fXLiTFmtcIYO2GSsLEx7n7Z4QPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hw3UrFapDf25mvCAfRxA2r04N6LwW5ygHsMjAJYIWKQ=;
	b=tqofpP6mQlDoGkhGXO8wTotIVEA+xgrJ68lxbYrciJ+JHE4C+8/SXzuqXUapVKS5kLW5
	 RQBD8qyh8GkAprQ0J1JGJVwRpqPdeCxpdZvQlFI1lbT32J2Mi4tkXtVf6eLzqAMTfzEVV
	 69RuWMyV5aqJBljuAVFRKmLgq42JEDWt5hYaERVqxI+aaMJNAxMuG6bGjFXq8OSCLqyNB
	 pcEYgxJ+j2x9puRNbKEMCwuNA9uom0WMvqT6cVR4rYjJ3UXfD4ejATOM4xSmmkGekGvkE
	 FE3WDnlDhw+ZUEsyh7jk4rsVDkxz5EMq8J/4Jtuel4RHi3iDT2988wWeHzWes8UMIKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RxCGsajq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A003C606A31E;
	Wed, 25 Nov 2026 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RxCGsajq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B2C1F000C0;
	Wed, 25 Nov 2026 16:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623484;
	bh=Hw3UrFapDf25mvCAfRxA2r04N6LwW5ygHsMjAJYIWKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxCGsajq6hBEvF38TXgbUI3qTTvkooyGKwlcNoUI1/roT4d7e4Jew8cIEJs7lsyhn
	 VTdDbKUcsCA5qbLRjXecMN9WM3wWkfnjcqsiSsYW7eqHYoG9kq2r6O9d4Zf1W7ZLim
	 agb6lLid6uKkCaIQyHzQOMDzGYZcgKCiClMHICZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Schlehofer <pepe.schlehofer@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 873/990] dm-crypt: defer async write submission to write thread
Date: Wed, 25 Nov 2026 15:37:20 +0100
Message-ID: <20261125143842.468975651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -2039,8 +2039,9 @@ static void kcryptd_crypt_write_io_submi
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


