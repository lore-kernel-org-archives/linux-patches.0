Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704606;
	b=ewvzh3ke+HgJWr4qr51cLmq1XLVctjyRowQbmPn9VxLD+0gsVNSEw6Yaw6/3RGzxSdSN
	 8JQJGbwt0xnyA4m0hV2wR/VJXYWGxZ7yib9fMP0LnL7okQDQJKkKDgo2NeZzBRCwCGmKL
	 4BuLVT0H+2oY6ML7CBHPESxCXgBZbpmxwWrOVXc3Z3n2ZFYY1dj33nUKO3u9QUghjVtfO
	 VkTFagxLXB1CmMrj9rVMEqGUy7aQZXjohm6q1gBFvG9mSe/u7pb/0xRsFuTGVzcSyidZy
	 PhIH9RRLdcVWUggXES1rgOelm+61OG77f4xo8JC7OwhgSLx6IZk+kZsDpWDjUqrC40A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=t3GgI3OqHxfR1zDhHpybe1ymdkcG68GO+ngr+PlZEUc=;
	b=Bj7HTx8nlLYZfGYbONwF4TOA7L3wHSOe0a3H+NHjh4gbUOs2qhrThfSlPQHfJZFNkOky
	 ryjMkjb3mKZ2nZwc5dyIvD/y/64o3UQuSyFhWzJKiEZvLYUBBTAHwVwOXG1e3hGTqz3I1
	 W4/wQ+zj2aooiSKY4kUWBw8hlcb96BFsDWd3BDggKjhiVMtQYYpfmLtkCqXphiRWCakye
	 bHgQpjrmmYBT3N4S7ZUK0PfoeBQrGTvPO3Sz+zUFBaaJD2ivVrE/XJ4qZ2eS2UllVHr9R
	 Er+bntQsINZCHZjetJc8Ca2Wc5yZ8aU/vLWHIjqE1XgBRP9y8WsuxklHsc/CoxDPL7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dkk9VUwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F721606A31C;
	Thu, 26 Nov 2026 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dkk9VUwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E20E1F000C4;
	Thu, 26 Nov 2026 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704606;
	bh=t3GgI3OqHxfR1zDhHpybe1ymdkcG68GO+ngr+PlZEUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dkk9VUwEsGjJFcHHVC0MsJ//bkBgpAJPks0w1JGwKJDzbcfR/OF/ChGPbiHDMrAhF
	 0xSpp32pfuu3bZWVhQQ1+AukyZmqW3O+Cna6T6Q+sn0q75F0bVlZpUuNZxmJR/MvC3
	 xBWs3fgFLmQehTylO10V5c8T6KmsGX8AIjQnlEYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 180/265] s390/dasd: Fix wrong free and refcount leak in build_check_tcw error path
Date: Thu, 26 Nov 2026 15:38:30 +0100
Message-ID: <20261126143617.788764647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2518,7 +2518,8 @@ dasd_eckd_build_check_tcw(struct dasd_de
 	return cqr;
 
 out_err:
-	dasd_sfree_request(cqr, startdev);
+	start_priv->count--;
+	dasd_ffree_request(cqr, startdev);
 
 	return ERR_PTR(rc);
 }


