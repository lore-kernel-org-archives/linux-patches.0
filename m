Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127EF19049B;
	Tue, 21 Jul 2026 17:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654708; cv=none; b=OzdRj4JFttB/mkwCXyhTjmBb9b8BFaHzomAotiIDNL7LBhfwtdybZi+7wjHKA7m4VzIqttyjIBNix1Ynd1aCqPMIaIhF3aCQRFCW1E4C4YAc5x2e1/RxJEdDmve2nc8aVDpVvzOBM/NI+fqueBlTXYrREAtIYNqpggbcLEEqD4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654708; c=relaxed/simple;
	bh=yJ/3FKWFv8bFBRaider/WbeBAcOiPwQ4zwKrp6pUsAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PxhxAZA/KA8Gaa9E/aWUVJzbHCPwi09XYPvmg/wPNhEi1zcQb6ukCJyHI7XdJxuzkCyM6/5zOczYRBQn3s3P5BAVui42NCa5FGtc6/9oNqOEEMd9HONpjHYhrj2yCS1Nf3hB/y3g9wmRSGHi4X4l77grcNzha7Ke3FR8rgnnuPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+GuMTBe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+GuMTBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E7B1F000E9;
	Tue, 21 Jul 2026 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654707;
	bh=9y8442t47g12kUeqj81PV70rAIU2eUj4AMqDwmji7Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+GuMTBeynXIZcoYOs33x9cA4cm32tgn5r2ZK0xTWXT47ETPYmN26OPAVsXGe6ahV
	 7LXV6iTYt6iYLGARraOC/ru1F+0ZFhpxMv4IrtPU2bv+j15O3rhlcBa3zad3qTS4vC
	 hYIIMUNN6+GrsPrmsdlPMKJ9FVpJ4orBw6wNS7hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 7.1 1808/2077] time: Fix off-by-one in compat settimeofday() usec validation
Date: Tue, 21 Jul 2026 17:24:41 +0200
Message-ID: <20260721152635.392496860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


