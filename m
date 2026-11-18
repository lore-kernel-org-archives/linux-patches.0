Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060332;
	b=TBQyWQobnAX0bKBH8nK+StQ6H9C1/gKH0EdBT6+OnIhM1r0j90a9IBQF2rFtUCCIPzf7
	 SXHuKn6C+Tl8Wp96ZVvIRAToF2ZJVGm+mzZW5bHIS/ACaeok1CPthngcDcdLk9WVrInRw
	 3YZym6QxZ+6QCHvPePopDihYpHRCB9yPLmJBhaYbFJ6dtph9zdNy1gZc+GBIvvIPx7zio
	 Ari3kJUM7Qx6+GOUFHiuDoupncgG1ecvfqeZaYxbGb3n0FvPAidRFdr6ayrATIfrQhF0k
	 h3lJ29gKun2xc3I5mI+ZpQLR6jgDgXgIRcBkmu/92fFM2yPoYoKwvE+MgUeNUFK50QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zSldcgvix1eMfkgjz0KNHI32hzjxttW9zpSYMrSvWhk=;
	b=ez3L6JJrfAm4a87JWDFJ5yD/sNG7rIgtDDGG7ZMk9FgkTn3Fj2aQ0z+YqqI5sQOkaYRE
	 cCnLN3B/hFEZYm0hBttXLiVvqHkJ6tYpGppYMXf2TST1+IEYtLTNYvAZl+XOi4hvVQ7K9
	 N57P4vwXVYUtYGqJ1hu9IMwzC7kD9p+4sBQFVnOXswckd0r7bujT59MaKqPVWAMfnk2Gc
	 jZ+DO5WlP9QgO4wSuB5XGHmQvziL+lqNn3tc+VOHVd3OccwAP/DLfrnvpzHjo+PApNd3f
	 GHKhLeL947YkZnNRLnA3SLY1bqAD/1ylB/A5iZpw1ynI77AJ2LafZU33Xai2VmErSUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GeacaHl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ED6606A325;
	Thu, 19 Nov 2026 03:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GeacaHl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11031F000C5;
	Thu, 19 Nov 2026 03:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060332;
	bh=zSldcgvix1eMfkgjz0KNHI32hzjxttW9zpSYMrSvWhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeacaHl07oZEpxvC3GJjQmYGAs5GP+x9nRDnMYcHxyHvBim1cpa+Yq1lpr0pQQYga
	 WEiy7iTZeBL4rJEoDjM6FRKHgBPLJf1bsh0zO8M5INSZ16URSs+jAIAZPZzqSvJ9J7
	 kMKKyUxYHlhL0EsxmqpK9uu/7VqUv7H94/g70uP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1162/1848] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Wed, 18 Nov 2026 15:53:20 +0100
Message-ID: <20261118150008.329917252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 58d27c41542be6c40edac4f91f35a1dd8bf0d2c2 ]

pm_runtime_get_sync() increments the device usage counter even when
runtime resume fails. cctrng_read() propagates errors from
cc_trng_pm_get() without scheduling the work that later drops the
counter, so a clock or reset-completion failure in cctrng_resume()
leaves the counter elevated.

Use pm_runtime_resume_and_get(), which drops the usage counter when
resume fails and returns zero on success. This preserves the existing
success path while balancing the error path.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/cctrng.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 9c61807dfe13b..2948a3d401ed0 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -86,12 +86,7 @@ static inline u32 cc_ioread(struct cctrng_drvdata *drvdata, u32 reg)
 
 static int cc_trng_pm_get(struct device *dev)
 {
-	int rc = 0;
-
-	rc = pm_runtime_get_sync(dev);
-
-	/* pm_runtime_get_sync() can return 1 as a valid return code */
-	return (rc == 1 ? 0 : rc);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void cc_trng_pm_put_suspend(struct device *dev)
-- 
2.53.0



