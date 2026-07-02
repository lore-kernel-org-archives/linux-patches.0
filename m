Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31BD33F8B7;
	Thu,  2 Jul 2026 16:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009553; cv=none; b=sLLkTOQ3FKWzkSdzY79U6TmvOfu7ZueB6wRTw800PIVfw4dUM5HE8i2fTcBfQZW6FXNA1N1gD4rujAEBq1nemNYKRmi8R8TvFOT3Uq+i/Y0IqxwfFH0Qf8LftgaVYGpUvRUxlP6Wxrgu7hcUXHY45tOr8RqcqjjJyyd91tGkXZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009553; c=relaxed/simple;
	bh=0uck7hF2cbxP7lWriV3rxmw4DLL0fXeMEsI2Ax7iNRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5QfqpVBQts0CZVp08egoyAM+wxIUyDh0Hx5UylFRAcvv7/HZTO5EWNYYkanzTaXY4Rb34b+zoQEKl7+iBamQAo2kp6sTUDxVXbLK4tDsZvIAxElf8A+rAVHQdGwEfKOc/vFylMFZ1nPKcYVHiwaW42yPqC0AKoeibs1TPxeFyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnCDnpVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnCDnpVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153151F000E9;
	Thu,  2 Jul 2026 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009552;
	bh=mikM6KoaJfSADDfmO4fHAkcQ5q6+tbeyvob3Fin8Z/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mnCDnpVHM/rmzpaliPiLF7erL1CNDtey5sO3l91RZTf4yg85kFS8twG4S5q/wazNl
	 i2f4m6XB9Gx6L/uyled4hIm6gou5Gfy5IdQj6WDXOvfP5ltMUFlqp2GSCz0XVlK1zQ
	 cmylg5yo5fb0i99euCV+JYWJ6ktw6WaLZ3eP5SPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Kalluri <santosh.kalluri129@gmail.com>,
	=?UTF-8?q?R=C3=A9mi=20Denis-Courmont?= <remi@remlab.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 93/96] net: phonet: free phonet_device after RCU grace period
Date: Thu,  2 Jul 2026 18:20:25 +0200
Message-ID: <20260702155110.936477331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Kalluri <santosh.kalluri129@gmail.com>

[ Upstream commit 71de0177b28da751f407581a4515cf4d762f6296 ]

phonet_device_destroy() removes a phonet_device from the per-net device
list with list_del_rcu(), but frees it immediately. RCU readers walking
the same list can still hold a pointer to the object after it has been
removed, leading to a slab-use-after-free.

Use kfree_rcu(), matching the lifetime rule already used by
phonet_address_del() for the same object type.

Fixes: eeb74a9d45f7 ("Phonet: convert devices list to RCU")
Cc: stable@vger.kernel.org
Signed-off-by: Santosh Kalluri <santosh.kalluri129@gmail.com>
Acked-by: Rémi Denis-Courmont <remi@remlab.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/phonet/pn_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -105,7 +105,7 @@ static void phonet_device_destroy(struct
 		for_each_set_bit(addr, pnd->addrs, 64)
 			phonet_address_notify(net, RTM_DELADDR, ifindex, addr);
 
-		kfree(pnd);
+		kfree_rcu(pnd, rcu);
 	}
 }
 


