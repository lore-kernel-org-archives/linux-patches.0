Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704664;
	b=lrrnuRbs+zNwXw6Buy5WycpanCSsRcTM2ngv0i6wfh+4YC4tsLprhzzh7uly2jEBnHch
	 //E0zqJkwlcf2GY5HaHwR5T5AyB/sawF+LvhXXBevgiUlWG+yM1Y0jphZyCaFGJlct4dd
	 HBYANcyQogw2Gb0s0TC1P7Nhsqi2TEmIMx+iCl/wYQOQms6aMGTwuNh+yprRNCf0ufdAK
	 muH12Tzv5L3JmovlicELOfExGCCW16WKUK8HGKMvi58kEvM2ymtxOajnaHSjntiHrykb+
	 rR6Q4/5kjsJijJhlhgPn+118Li2HsyhZtm5Vr5yVWle0/I+ZGvmFqJZtJie/xWysCoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P1DkMhtSvEEBvrbWLb/fxzF8Z3TMG7uNFdpu0Cpqha8=;
	b=L9rDM+d8xDsHqZiGVE8/E2YUNR8GU1blxfY5g4C3t9cGvJ2viQrR/m4cOhrjjsqXE5ZR
	 CxLWOyi3p3K77ArHoN2BRGjYbOc/QDRfkH9xDYEH/1F2aSxc2Dig78TaWqRqHf/aACTjo
	 EBXI+Ea+ac8vlfufw0XMmaCldAbAK432psCIclrTfKY28G+PumT5FJsvNY3XT9IFWGrRu
	 w+Sk5sQ0vz5ot32ilkHfHuunFQHU88WikA3XSXP+8TyHRBayqnYi2nO+0K8wg4sqPbJcG
	 uVgjjYp2tN+R4fUntceW8v55N9wTRuBUHVLJZq0nBG8AkZQGwvnckuDzisfYkjCSYjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrU68Cy+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626A6606A31C;
	Thu, 26 Nov 2026 14:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrU68Cy+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD05D1F000D4;
	Thu, 26 Nov 2026 14:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704664;
	bh=P1DkMhtSvEEBvrbWLb/fxzF8Z3TMG7uNFdpu0Cpqha8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrU68Cy+kAJjgpZ2PK32XJHw7CQvibsh+cN+GwubmQ9gl6h40w5dkjXzmuHmDZzWd
	 FKLM2whlMpVcbtZdK3Qn2CVwUPuX8NpL18jWYIRmGo+CrG08IBIU2Qty0eYnxq8AMo
	 zy7D975gBRA9yvTHFDhtPnXV2WbKzCFZvjv4si90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 203/265] dm thin: avoid wrapping no_space_timeout
Date: Thu, 26 Nov 2026 15:38:53 +0100
Message-ID: <20261126143619.408168602@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Wang <1075151112@qq.com>

commit bcb78d49620f666b4a9d62997691e8d031fd4ebc upstream.

set_pool_mode() converts the no_space_timeout module parameter with
READ_ONCE(no_space_timeout_secs) * HZ. The usual arithmetic conversions
evaluate the product as unsigned int, so it can wrap before being stored
in the unsigned long delay. With HZ=1000, 4294968 seconds becomes 704
jiffies: a pool that runs out of data space switches to
error_if_no_space and fails queued writes with -ENOSPC after about 0.7
seconds.

Widen the value before the multiplication and cap it at
MAX_JIFFY_OFFSET / HZ, so large timeouts no longer wrap into short
delays. On 32-bit kernels, values beyond the supported jiffies range
saturate at the largest whole-second delay not exceeding
MAX_JIFFY_OFFSET. The timer wheel's existing handling of very long
delays is unchanged.

Fixes: 80c578930ce7 ("dm thin: add 'no_space_timeout' dm-thin-pool module param")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2531,7 +2531,9 @@ static void set_pool_mode(struct pool *p
 	struct pool_c *pt = pool->ti->private;
 	bool needs_check = dm_pool_metadata_needs_check(pool->pmd);
 	enum pool_mode old_mode = get_pool_mode(pool);
-	unsigned long no_space_timeout = READ_ONCE(no_space_timeout_secs) * HZ;
+	unsigned long no_space_timeout =
+		min_t(unsigned long, READ_ONCE(no_space_timeout_secs),
+		      MAX_JIFFY_OFFSET / HZ) * HZ;
 
 	/*
 	 * Never allow the pool to transition to PM_WRITE mode if user


