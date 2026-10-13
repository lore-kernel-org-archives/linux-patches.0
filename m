Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA9B3D9DA8;
	Tue, 13 Oct 2026 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893730; cv=none; b=P9N+uDAcYUQe/tQjrV+7ZCNcYld7BuKtLm1okC/4cL2U7TtneTrSiMEYHWylCTihALKDHYdJ2YFmEuLVo0nhzKIULFkh1Wt0IVQywUPwUszcrJKMbemt3iU9hkhNWXX0Vr7GYEq4rF1X9yNpp5Mbr5+vIzYxuYi2jGbNiYe4wP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893730; c=relaxed/simple;
	bh=Gz6eEtCzdxhETOnK7jOfq9/mhl+7bTvG69uKQgG/fA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNJn80LgrINnLb6PJPXAc08Q1b8J9fhTLT/N0feC/Vd8sTReo5jDB0ItEuEBqNap/WGJRHfDV3Z5YnLT6nbxD2ervg6RRyp66i3LA5SScM4uDBXdwZTOJrRCnoaSoaldoiFPXQ8z9GVMW0aum1ev2zfb0ZubSjSMNsxTSSVzVCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BziQoWLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BziQoWLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AEEB1F000FF;
	Tue, 13 Oct 2026 12:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893728;
	bh=yplSVtBEVqk9cBV3Q8DCBCgGQrtpJ9/2IMsHhudyPww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BziQoWLCu3FMXU+Pft2fLzIWUary5URVy5BWJFY8MnO6cQFnZrdMGmKDx3QclylMa
	 OJ/MNbBeISZUU6zZ0J+3/bGbZszrH+0iaFinMITsn2dAzsvTpqlpqJAsUIBQT2NOx4
	 yimpV6LsFC0ZyylNxC4YVRsDTKL8bnhqqvKWqj+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Kriish Sharma <kriish.sharma2006@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 323/621] hdlc_ppp: fix potential null pointer in ppp_cp_event logging
Date: Tue, 13 Oct 2026 13:35:18 +0200
Message-ID: <20261013112928.517839595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kriish Sharma <kriish.sharma2006@gmail.com>

[ Upstream commit 3dacc900c00bad7275ee8c096dbcaab699d83e36 ]

drivers/net/wan/hdlc_ppp.c: In function ‘ppp_cp_event’:
drivers/net/wan/hdlc_ppp.c:353:17: warning: ‘%s’ directive argument is null [-Wformat-overflow=]
  353 |                 netdev_info(dev, "%s down\n", proto_name(pid));
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wan/hdlc_ppp.c:342:17: warning: ‘%s’ directive argument is null [-Wformat-overflow=]
  342 |                 netdev_info(dev, "%s up\n", proto_name(pid));
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Update proto_name() to return "LCP" by default instead of NULL.
This change silences the compiler without changing existing behavior
and removes the need for the local 'pname' variable in ppp_cp_event.

Suggested-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: Kriish Sharma <kriish.sharma2006@gmail.com>
Acked-by: Krzysztof Hałasa <khalasa@piap.pl>
Link: https://patch.msgid.link/20251013014319.1608706-1-kriish.sharma2006@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 56e78b670356 ("Bluetooth: hci_sync: hold conn in hci_connect_big_sync() callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc_ppp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 22affdcb4ceae..302ed27944e7c 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -126,14 +126,12 @@ static inline struct proto *get_proto(struct net_device *dev, u16 pid)
 static inline const char *proto_name(u16 pid)
 {
 	switch (pid) {
-	case PID_LCP:
-		return "LCP";
 	case PID_IPCP:
 		return "IPCP";
 	case PID_IPV6CP:
 		return "IPV6CP";
 	default:
-		return NULL;
+		return "LCP";
 	}
 }
 
-- 
2.53.0



