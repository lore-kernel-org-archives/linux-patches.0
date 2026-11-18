Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027490;
	b=J/ZOvHzjr4VTRot0fLzemkLRy/ip7yqDwFJwzqRzgoglhmeBHxoUNgUuBZ1PNOVEegrj
	 nKaa4S9cvIO7Npt8x1q29Ac7IrSV8CxGDN3I8lTytxw4lFXT7OAax5zTj75EAXHfasiDu
	 OK01M0oxK4gQm7dThBwONfeZ0/+qCnCZCD62w7i/CkWHuD+FASPV2SfIPzuHVzqV0E0KO
	 WKkURTI4ZRERIVKYvbIlQNEDBgP8i49T6q0G1HSn2jfzWHUoLe3lv5fCPHh2M8r1Shfuc
	 DfEqse4CJeIAdrfuVp6ipTYJdgXPCmsymt/22SAD0+iwA7rEd+ZSdgGRQr8jkxEuCjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E7hpigCWp56tf48jIkaWTUqLzKDocQb2A0l1vOaS8O8=;
	b=rWDzQUSDQ+RVHRWEfpXq1+k+TW4wSWbBFttQi6YLl/tgdfVAC2YnMm4tSlxXWJtaC37t
	 HBAD8ErByneC4n8CcV7Y1jBnu0VTD4P1Qwh3HFx27N21RDcsnFEGKIZXD7I8hfMIwLRng
	 Z74ox3fhjwE26b+8eafxNSx/saQ1IzMUdy439XhRAsBzZfo/y/O5Lv58U1E2uXyLRGrXN
	 Dl/2TtUd/uqF4hnuB4uZktMa4kquhWx4KLh9W1BeUUnA+jZxecXO7hXU01J8G+RO5X3aM
	 5LS3kSGrK4/gVN3H2U1ZGmvqr5ExvNklr4U9OLDGkkkahTA6SncQgcUBITK09QMNpcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4pwRdsw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685BE60A261E;
	Wed, 18 Nov 2026 18:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I4pwRdsw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4DA1F000C6;
	Wed, 18 Nov 2026 18:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027490;
	bh=E7hpigCWp56tf48jIkaWTUqLzKDocQb2A0l1vOaS8O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4pwRdswOaMbI9PHr2gDJ01QqiA+kjR0OdOC95CYvA/LyUXrCTPoCuFbf4Ub6jEbj
	 LRHXraCAIs7XfxqbZOLmOCqYq6u5ryNwHG1rLHdpzQ+Ess6B88Wf6/Y4ua8v2UX/Fb
	 KUfOyekaNg3bqyRGBLLnWz8kUvsC1emDfZbl/rrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.18 1807/2151] vhost: vringh: use get_user()/put_user() for IOTLB 16-bit accesses
Date: Wed, 18 Nov 2026 15:59:02 +0100
Message-ID: <20261118150227.629597435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3391413379579..e0fd976324730 100644
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



