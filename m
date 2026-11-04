Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829061;
	b=atOGgvOBjC0gSk7JcXHvWQXlMHcI7lbEV5+Nn5QegbB1VITKYIVNhyM50T/ut3vOJ0Wd
	 Zp78FH7cYwBfGjs/LNwtUBY4DON70bq4vHcCLiWNp6dzWDnuVELHwwvXyffGe2jMz9zZP
	 5OGXhLIeLu49UkIqhZFpqzeNWrk6v12bjtlztIpX8C3dYGwvCEmmn613AZmNnKEvg6Hhk
	 kGymkrRQWO324adjcXEyhyRjrTsKSnbARxp0hSrFzrOBQKk5+tlf4Ld07Ng+GKvnV+fvO
	 J5RzNSOR3bmg3pvf7RpY9T33J14tGnvV21ZSB6dHiRGV21BDRaQKnxxJJe7nOt6fz4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mAB2Y3Ly6PLqW5n68GbKKgYI2JfNO5j+jd8N5GA6smY=;
	b=C3hxunVOE0MleuxG+Pi4zJkDZoZzIeXSXsg9AlYXw+6UA+10d/+xwDPhxqHTDV++y8A1
	 DPmfPxrZf8yF96dSL71YhLZuLWEThOQpxS67Q920hRvbuqI6qrR3T57RguZUv2vQZXJvd
	 t/w80VEBuXENYwlIvSyxn3UDPgcgzWJUbGOpPktCblip+ckF9zAnH3NO+eF6NUwLZyTue
	 Ejz8cgbWcJ6tvVz6/wSlNmk+xV5lhwTjkHproxB2mvdxse46JOZ54f9JTqas8kxwzeFxD
	 uezcS+5IIoroSuizBtZncdZP/RCXgQ5dXooy0JKMIz479WRa+prTFySWp9VfruJm55Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bworpfpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB56607077C;
	Wed,  4 Nov 2026 21:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bworpfpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34591F000C1;
	Wed,  4 Nov 2026 21:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829061;
	bh=mAB2Y3Ly6PLqW5n68GbKKgYI2JfNO5j+jd8N5GA6smY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bworpfpetKYWwThk4jiHWZqM/v6qBnYlN3y5ZaFSVAHTtZHyvqUheruCwzk5Iq6aR
	 f/aEAuFAubG3eZW6FudxqX6AD2bGJ03bShkSNg38fGwFe7Wvdg0e+pkbvfz5tlpgjT
	 oMMBDp0Ce0c0MyOiFHiGNsFg6N8l6y61LIa4FHEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 418/547] NFSD: Fail a pool_threads read whose reply does not fit
Date: Wed,  4 Nov 2026 16:10:02 -0500
Message-ID: <20261104211050.202765684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -477,7 +477,7 @@ static ssize_t write_pool_threads(struct
 	char *mesg = buf;
 	int i;
 	int rv;
-	int len;
+	size_t len;
 	int npools;
 	int *nthreads;
 	struct net *net = netns(file);
@@ -531,9 +531,13 @@ static ssize_t write_pool_threads(struct
 
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


