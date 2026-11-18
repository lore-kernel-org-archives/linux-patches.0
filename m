Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021253;
	b=swwd4CtCQv7esrlyhBrW+PJsx2ds90b26o/8ObwO+7QI2rYOrZYmLTSl0AhFxd/21vmK
	 ZewRwXWx6VNQhOTjJG8z4ZkB2RHHtorub07KPih7b4jpqAhGzsSsN8xg/CHzNPIqfQQ+1
	 YbLU5Q62HqitBpHC9z0VKGomKUi+U60ACXoVXVo5mmIlWQRRwFOOz99GGuzG2WvMnB+eh
	 oaFLKW1lPB6aosoIhDvvPUewuq3hZAam9iHIXXL+9dFdSjSvqobhzJ7DsM12hRI4/cjJx
	 Pv8kT3lmpg3h0adaXcbZMaSXPEDezfV/gnDdWEzF/1fusrN3gwQ+JtnIFw8uS5SFFRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=piazapLDb4wmA9fsavNyeLnl60pm1kLf/G0tDXoXNHs=;
	b=ib5I6aZpVsEmJ2Iop91rjPaCLYZMkYTU+H7AvMjZ+pPpDl2+r/+Ix5j7aAa0WffqI5eU
	 jSSZxuaDQP+b3ycljNiPYOxbB48e3xByQNTcWuvgzqEvp/IGIoy/224NOi6sXDjUXm088
	 YI6d2C5CbYo6SKFf/BA/cHwalewfZsZX9n8Yl5wCH909qaj1XPobtPFZfz6S4lUC4pQU7
	 5eZcYHxuxV82ieifZU0CiHbSNyD7er77K55SMtwPe6cTTi3YxaRa0m9xKj8EqL07bt2FY
	 PECVIkS5nVYQMdPW1x3EYulOkHC3V+hMYHrxfPJ1wrNt1dYsOe/pcnZQkkKgQA9qFoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSrrtskP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E595606A333;
	Wed, 18 Nov 2026 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSrrtskP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7C11F000C8;
	Wed, 18 Nov 2026 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021253;
	bh=piazapLDb4wmA9fsavNyeLnl60pm1kLf/G0tDXoXNHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSrrtskPfuIyzzTIONUVQPJgxWS2iy1XtfjXNXMQZJZd3JeGnznAnBr2iOpKkUt0M
	 TMirGG6JbEqb1xIoVg7C/e6S7tbJIRA+I2fFNtiM7vo/AeKCWEzeMhaEw4vdkmRebY
	 q69P2kO9nyFkbpzt4ypYGeS2wcC1+U59Gz+1NqII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.3 2242/2651] vhost: vringh: use get_user()/put_user() for IOTLB 16-bit accesses
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-ID: <20261118150406.190090604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index f027f669460f4..12809fced6087 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1214,7 +1214,7 @@ static inline int getu16_iotlb(const struct vringh *vrh,
 		return ret;
 
 	if (vrh->use_va) {
-		ret = __get_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		ret = get_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
 		if (ret)
 			return ret;
 	} else {
@@ -1252,7 +1252,7 @@ static inline int putu16_iotlb(const struct vringh *vrh,
 	tmp = cpu_to_vringh16(vrh, val);
 
 	if (vrh->use_va) {
-		ret = __put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
+		ret = put_user(tmp, (__virtio16 __user *)ivec.iov.iovec[0].iov_base);
 		if (ret)
 			return ret;
 	} else {
-- 
2.53.0



