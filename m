Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE2A1509BF;
	Tue, 20 Feb 2024 20:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462755; cv=none; b=NQFvw0/5vHqXjtNU9Mvd5WIUSPpEen2fso1U4Mq0l5m4E9fxlG7LyZ3Aj1vIvj4A9IEkGeXg8jrQaL4t0i8c6xMejX91d2/QA5K7yFoAg8DI0upUNTCsYCmbPuRkWSHHG5WfoQqj5sA7FWbudHxsQK5M1eNRCENYG/iizEJq5xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462755; c=relaxed/simple;
	bh=j0JU3OJgIJF0w8nVMVSuyFEPqHN+NpDJLtALJsT4bFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2YyFJ/jJRnhHhGHDHVDPrHI7vBDIw2qDnmbkvRJsDG+AdSmzr52rKg4oSaqlpUPJH5978HkbYof2cYFrjNLB66KkWrlh+lzMOsJTgKwhOiZI1lbfg5H+4VrmGXC/3qKRcv3zLOJ3PNbK8mR9T/NsExKbfOI3ywgkLWjL4KVv/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWgbdmN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWgbdmN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3014FC43394;
	Tue, 20 Feb 2024 20:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462755;
	bh=j0JU3OJgIJF0w8nVMVSuyFEPqHN+NpDJLtALJsT4bFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWgbdmN8MpiY4XY2StajMECBujX+KI0JuZrhoP+2JGIehUlmYWTrp2RF2AIzdLSki
	 GV4mmwTT8cMiBnMnmWrzQEfDWE6B0pY6VJhIvS7vx0hU4Ejz4abnsXnfq6O0yaek8/
	 fZqAEWWLKLY5n10Cp9OBw+7rnz7e+iT/bTI5/md0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/197] net: tls: fix returned read length with async decrypt
Date: Tue, 20 Feb 2024 21:49:45 +0100
Message-ID: <20240220204841.863703319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit ac437a51ce662364062f704e321227f6728e6adc ]

We double count async, non-zc rx data. The previous fix was
lucky because if we fully zc async_copy_bytes is 0 so we add 0.
Decrypted already has all the bytes we handled, in all cases.
We don't have to adjust anything, delete the erroneous line.

Fixes: 4d42cd6bc2ac ("tls: rx: fix return value for async crypto")
Co-developed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d651c50746a8..09d258bb2df7 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2202,7 +2202,6 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek);
-		decrypted += max(err, 0);
 	}
 
 	copied += decrypted;
-- 
2.43.0



