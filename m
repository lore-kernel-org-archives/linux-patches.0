Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A9D44AB9F;
	Tue, 21 Jul 2026 22:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674425; cv=none; b=K8Jh70CwaXY7ULJd8TRq9tYBbCvRcB2hAo61WAYVQds1TthsksCqO+dl1GsQilIZS89+TIsEZBuxNrG7PNerpAxjVyBUKG6Cyaw4p07Ct64ju0g5yppM0bCOzLlzr1TbSWP1aMIYYeSmgvLSKUa793NGOFCJTPHhkV0TsaIWkxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674425; c=relaxed/simple;
	bh=XODjo6DwH8/Oq+iultMY4UpTlVNGMeUQkwrlTSGFcs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xj0GYPT6tBoj1XdjezCbLeJNEDomE3m6Ks2fqEgLktxruegnO55WW5AiOmQkpXENdC9kx9Ra8JiiYf/Lqw4EIgVbTbfrXJePF6EpSkJhY1aq+uGnEu3tLfLh23iWniYUQoHyjlgw2UcDBn5WzUP/RD2KuALW06B0tFQ1eCPk088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIeyQiPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIeyQiPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623BA1F000E9;
	Tue, 21 Jul 2026 22:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674423;
	bh=CBYyj7eiDZUsPSvTL4Cq4wBEuv2NmOqxlkU1BL+CGww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIeyQiPimyoTO/IUU5tnCcdZvnMHNjVuMqIhpoPGq307/X8bQE9XT5OMKJ27MW5G0
	 XYzO7schYVPlgzza9JlMpmkI5i9mGS7XR2Zlp0RCqK3fwHswM4QdKyvJwCjsoUVS+a
	 AYDZrPyjHWmXtX66p1DxLWtedpywNHzuAIL9jIqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.10 499/699] time: Fix off-by-one in compat settimeofday() usec validation
Date: Tue, 21 Jul 2026 17:24:18 +0200
Message-ID: <20260721152406.951741285@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

commit 269f2b43fae692d1f3988c9f888a6301aa537b82 upstream.

The compat version of settimeofday() uses '>' instead of '>=' when
validating tv_usec against USEC_PER_SEC, allowing the value 1000000 to pass
the check. After the subsequent conversion to nanoseconds (tv_nsec *=
NSEC_PER_USEC), this results in tv_nsec == NSEC_PER_SEC, which violates the
timespec invariant that tv_nsec must be strictly less than NSEC_PER_SEC.

The native settimeofday() was already fixed in commit ce4abda5e126 ("time:
Fix off-by-one in settimeofday() usec validation"), but the compat
counterpart was missed.

Fix it by using '>=' to reject tv_usec values outside the valid range [0,
USEC_PER_SEC - 1].

Fixes: 5e0fb1b57bea ("y2038: time: avoid timespec usage in settimeofday()")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260622103348.120255-1-wangyan01@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/time.c
+++ b/kernel/time/time.c
@@ -251,7 +251,7 @@ COMPAT_SYSCALL_DEFINE2(settimeofday, str
 		    get_user(new_ts.tv_nsec, &tv->tv_usec))
 			return -EFAULT;
 
-		if (new_ts.tv_nsec > USEC_PER_SEC || new_ts.tv_nsec < 0)
+		if (new_ts.tv_nsec >= USEC_PER_SEC || new_ts.tv_nsec < 0)
 			return -EINVAL;
 
 		new_ts.tv_nsec *= NSEC_PER_USEC;


