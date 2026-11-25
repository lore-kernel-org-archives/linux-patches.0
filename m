Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625824;
	b=29+2po8G2esPJplM5koQ2K+Y6uTSmHC8g5SEzd6FIOJTRGHPj68uBEWpaHiIP1WalqGS
	 6Lct8WkNdyJnxkavgUaa/F/W0L5kYXB2Aa6EArc9PIVLDlz5peIa2p2i8yU/OSHjr3i/K
	 Qd0d6h3Z87ETUr0bhBStyJxm1M2R8u+s2D2ug+Rc7Pn5tHVsLbJ2tr9ms+63PCt0ivOss
	 cHXVS3X6XbUxn3MLv3P5zEGBvhjgWq/qmbhy503DVy7y7qQqV96aQLKPrff53qTr4rd0j
	 8vRK+vJeWJbizKoAHqursMmIaQYB4bq5Q/vON70bvsAMEdAsVGhaYPuquIB418Ro30w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HafEz2LX/NDJsWcaQcaBOiXe2sKNGtECswMQbiMyuFY=;
	b=YNdlueB33IZwcmb0/rxJm8pgJ6PMxKcGcqBItfvDrbXoMIpxsBF/1bVxC2pwX7hQ1CsL
	 W3X+UkEUhsKyoJGbY249efEZ6oBMhuMMLFLWTt93Mc6RpwLgylz0vheeopUXPghU7iUSx
	 0gSPHhUn4r8KNkWvlF3ovDZZGbyZgkS1SoVEVIiVMDUkysOMfHyJ3Ay0RNtYAnZqBT5mx
	 A5baYi2I0u2dCmPidnTLUNnV6Ag6Vt+KL2EeCTVXQ7xB3sx75WlN+tzCKusz6HOvsrdZf
	 xXcLjN0zglo5POJoPSKLYEK1sdqSB93wiosXHD1T0BePuaa0ozHdHuPUE3hE+lkbFuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZjJ/gSnR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6630F606A331;
	Wed, 25 Nov 2026 16:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjJ/gSnR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5781F000D1;
	Wed, 25 Nov 2026 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625824;
	bh=HafEz2LX/NDJsWcaQcaBOiXe2sKNGtECswMQbiMyuFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjJ/gSnRwqotDtBGDgMcaBuh2XKvizpkir3UG4Tre6UGTpORSusS/yJkGdTg5Rny0
	 yFR03nhRZcHA2nUoUgF78uD5KoC/RUaQ6rNLtyWIGGCkdX6IbW7VhuDVnuOSwN2Egj
	 OtuSmd8DVG3ZfyFVlWF9bojSIIcZXQ/4qIMzU2Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 642/816] s390/dasd: Fix wrong free and refcount leak in build_check_tcw error path
Date: Wed, 25 Nov 2026 15:36:30 +0100
Message-ID: <20261125143904.043143933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2593,7 +2593,8 @@ dasd_eckd_build_check_tcw(struct dasd_de
 	return cqr;
 
 out_err:
-	dasd_sfree_request(cqr, startdev);
+	start_priv->count--;
+	dasd_ffree_request(cqr, startdev);
 
 	return ERR_PTR(rc);
 }


