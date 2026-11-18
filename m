Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042291;
	b=XulKLePjUCtRFj/HncSkA5Z9Pwy5+WSesWxNvvUZxV/ejo6btW67mOA6XmQppGDZgAzt
	 I3nt1Mc7WPBw2uenjLJbFs4aaP+z9eN6bNZr3RLwdR0J3LJl8E2MX/8HDao3xvdTqW/Cq
	 cIyGptsLohaF13qLGtDop6ameIMJqZeP0GMF3RlrHw4kUG0l3j9cEfK090p/Q8G1piQtg
	 q1sVVzSzUMoE+jZUaMIKaP7JISZguJDAsSJ1nsd2327pIdP8eWoYU9wwKZYkv7+xTCFdB
	 1WpBdvsigGKrliDcWAxk9Mkh47HsYlaHnuhvzlV71S0IVj97hH5LOj/cXApIj0L/D1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4dRa0w10bA4QdwyWCNv1g0XCcp67WtCwW8bz0C3XEqU=;
	b=raxq7kcQw3idihDEDfO8aQPm3r109NYq62K6fNr8dGnX0l8bk7Ptabl9YT7iu3LYEPSj
	 +z5ocDzW6cp5Vo8ID5tHErayZZk++SqZinExZf0ZQ7fSaYYPzGAEG6RSyjhwBY2ja008i
	 fKx4+mVXrsz9S5QBbv6GDsKFb8f1iEQNryM/d+tNgkg2PUQjBeeniASvwI8YS80k2ii8C
	 6EIt9EH1RVVn6LCJZvNzEZ8IystKC9P+WV4CmpLcc1YMXdYlPkYaAaBUf/n9MC3t10uJj
	 BcuL8TS8ZCOLZPPIq+rlxDrWRAhZSOT1+qSJM1DkAL+8LhwmgPKs+X3lTiG1LK13iXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5soP4PK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E610606A32C;
	Wed, 18 Nov 2026 22:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F5soP4PK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1281F000C6;
	Wed, 18 Nov 2026 22:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042291;
	bh=4dRa0w10bA4QdwyWCNv1g0XCcp67WtCwW8bz0C3XEqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F5soP4PKKIYjjeAugJMXJolMLL0ktNQZ9AYFM3+QU82I0S3jDYRbBeWAeJeOr9nvK
	 2hflZwqHr/YMKtXQ1QM3B4dVb+cxO5KFaTK4dcoO7diqx0x3l+cMFfaJmf/fyXVYs1
	 XlrbJA1HzR7AgnOEx/ma8aHaVUXM1nfoKoy6WMeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.6 3067/3318] vhost: vringh: use get_user()/put_user() for IOTLB 16-bit accesses
Date: Wed, 18 Nov 2026 16:01:29 +0100
Message-ID: <20261118150452.128296927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 95a214f31a3b1ef40034f1e1cb3b9d758a374f01 ]

getu16_iotlb() and putu16_iotlb() use __get_user() and __put_user() when
the IOTLB maps to user virtual addresses.  Nothing nearby checks the
translated address: that relies on the mapping having been validated
against the user's VMAs when it was set up.

Use get_user() and put_user(), which do the same single, untorn access
and also check the address.  The only atomic-context use, the vdpa
simulators' notification check, now disables page faults around it, so
the might_fault() in the checked accessors stays quiet there.

This is part of getting rid of __get_user() and __put_user() entirely.

Tested-and-acked-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 42823a871fd4 ("vringh: support VA with iotlb")
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vringh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 9fc522489106b..88c683f4b5a14 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1290,7 +1290,7 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 		return ret;
 
 	if (vrh->use_va) {
-		ret = __get_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		ret = get_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
 		if (ret)
 			return ret;
 	} else {
@@ -1329,7 +1329,7 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	tmp = cpu_to_vringh16(vrh, val);
 
 	if (vrh->use_va) {
-		ret = __put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		ret = put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
 		if (ret)
 			return ret;
 	} else {
-- 
2.53.0



