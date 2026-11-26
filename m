Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705564;
	b=fzB7DRSlTllTN+BJgP5qyTa7aiRPaEv2oa++uEXvRdnad3n/P1Nulu5qPZc3LOJ1xlnI
	 c3tdczdfNlEt7jMHLWcvZOkSAcscbcawtcqp+oQLIW9geVlnCHukg5jG7ANorAZ3N3Jj3
	 1fnww08/GUCgcHtX5dRYOlCtr1jFij5bRc6y0JrQRoaGqsd2EMoYgrSHycfy1rBkqL0j0
	 Me9nw0USBNjwGFhw/nvxqdSdR5IEEKb6Lz13G2b0OE0K8XcxBf3kxXFn1CPtNpl6yBFbR
	 UutmJgfEap8594uGH1+Wa61KVi54xBTpBib2NXLlpfaWzQYbhmdnuhXU6W4wU+6nw1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4IhyHOrwWyqoCLYQbDsK+sC5DoU2b7IfpySdXqXn81I=;
	b=IXcC4C0GUAbIKsUZOnvfusdqXg/onVQLcGPl2BKVoou48JiJW14aQM1mNZegZx/EGy8O
	 RMjs5f7CZSJpDk1eZ1PNRtnnBjAqWEBaaUxOzZIHP5RSqXPW8PCd9cpMF51dN5HLeyXWU
	 2hK0axyeskabpg7izLqy3akG6jrQXvyLdG1cB6TU5w67NeDlbYwqTkv3pgTog5LYalAsN
	 fVM6y7jPDm9dfuZO2CZK/yiCdBfTCZ4vERjZ+T+JD/dJNMQf9OfqEGxCNcjPiTrHp84JD
	 u/Z2dbGLzVGrdI457dotRxrV1ud9z+QapcOqrfukCl64UWizidYdGkPhlaf3dtLnexA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lk69a2xu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD3F606A31E;
	Thu, 26 Nov 2026 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lk69a2xu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED851F000CF;
	Thu, 26 Nov 2026 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705563;
	bh=4IhyHOrwWyqoCLYQbDsK+sC5DoU2b7IfpySdXqXn81I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lk69a2xuWtlsNOdu78nT77WTADWJD9huiplEk5BPjAnJtpc4aqu4uPDcJf7TO7xO2
	 QyA3/1bJJr/pohexF2LTVohM04ieLUXxPcri9RZB2/4492WJjalR2vip2+e5KPZABq
	 vzlroQrvAunA1nT34u0vnovJ2lDKjCivJm4Fb3Fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 240/319] dm log userspace: drop the device reference on error
Date: Thu, 26 Nov 2026 15:40:08 +0100
Message-ID: <20261126144012.162447070@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 0550d3b14e008b033b02cfce668008ec6addffe4 upstream.

userspace_ctr() takes a reference on the log device with
dm_get_device().  When the integrated-flush workqueue allocation fails it
jumps to the shared error path, which frees the log context without
dropping that reference, so the device stays busy and cannot be removed.

userspace_dtr() drops the reference correctly; do the same here.

Fixes: 5066a4df1f42 ("dm log userspace: allow mark requests to piggyback on flush requests")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-log-userspace-base.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -293,9 +293,11 @@ static int userspace_ctr(struct dm_dirty
 		}
 		r = dm_get_device(ti, devices_rdata,
 				  dm_table_get_mode(ti->table), &lc->log_dev);
-		if (r)
+		if (r) {
 			DMERR("Failed to register %s with device-mapper",
 			      devices_rdata);
+			goto out;
+		}
 	}
 
 	if (lc->integrated_flush) {
@@ -313,6 +315,8 @@ static int userspace_ctr(struct dm_dirty
 out:
 	kfree(devices_rdata);
 	if (r) {
+		if (lc->log_dev)
+			dm_put_device(lc->ti, lc->log_dev);
 		mempool_exit(&lc->flush_entry_pool);
 		kfree(lc);
 		kfree(ctr_str);


