Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623227;
	b=eKnRpIPdhUV6tpHvd1M2hDKtK7EhSw7PCIke1PbobJluKPRdnkedjVWsl1c1qDwaroVr
	 Jp90q0ySbnv1doF0hHLOJ8hr8exGOvDKkneYP85DEUVt8qQJoZUbJRTveoVEOn7yVClCA
	 Sviy5xdsnVJYr81206+zIFifr4HOI5JQwnwQ6ndRI5+VJYC72QTa8cHdjP/d6gNHotSdx
	 KTYowi5K6W3j7/ehe15wtiks/mg/FB/e33CL7uTszJymApO+Ib5Kk6OyjOirn6M4fxY2W
	 OSaEH59b3DHfkfTnGoeCIBscObWz4dIPjvWoDltd/mVT7H32rOxzuVZsYh5OxFHRkXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6+fpVnGVHvOkTDRKNH/Is+6zagx/grL8C72dw6oDUN0=;
	b=DSWMK3P0kakFL7DmnO+rrAvW5GuELbNflQ2/fdjLhFDDC6i0ZpjMI0lVWVlz4JTY9K+/
	 uGI05ClqH41SRJmUVk8n0mnFxL9VGBhVqd8PLU8RPT2xiU1fdJAFpWOfpLTACO2EoaVAS
	 QzUEBZ0P8UWUXSR45vRb73pTjCEQMRS2LgQWsgx/OHp5GS2get4Yue7Rn+TSE4MiM7mFx
	 cLOWJvZXp84dXF1ex494EHlIA0rYeIjC5WqDvmi/cqyiQnqSv7CZDhcpTWrYRA7g2/kjM
	 nRVFcQXbznoFVs8OQc1vPIusossKUl3kWJZJJANtgwUIklAh1L+HSAOygvUCfW+xu3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIK6AW5Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D3A606A331;
	Wed, 25 Nov 2026 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QIK6AW5Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038CA1F000C0;
	Wed, 25 Nov 2026 16:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623226;
	bh=6+fpVnGVHvOkTDRKNH/Is+6zagx/grL8C72dw6oDUN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QIK6AW5Q0L0Yr62rQYV9XenyG2kgog/heuUWUmNl/eHTW1Tt6IvkUmGm7ApQya4tA
	 qO1QCEVOVf2wmR8ZLn0q1ksAcis776Uk2bt7kGGFiqMxXZ01cbyIr7TWEuAYpc1ZiR
	 wxojzMG/4Rm7C8llbw3M/SXS2CGzEITM2oMgA40Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 784/990] s390/dasd: Fix wrong free and refcount leak in build_check_tcw error path
Date: Wed, 25 Nov 2026 15:35:51 +0100
Message-ID: <20261125143840.411347281@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2594,7 +2594,8 @@ dasd_eckd_build_check_tcw(struct dasd_de
 	return cqr;
 
 out_err:
-	dasd_sfree_request(cqr, startdev);
+	start_priv->count--;
+	dasd_ffree_request(cqr, startdev);
 
 	return ERR_PTR(rc);
 }


