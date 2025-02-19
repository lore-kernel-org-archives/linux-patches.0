Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AB71D90D9;
	Wed, 19 Feb 2025 09:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956341; cv=none; b=nyZhXiereqyiG7VPHz30Sg7d1dw8kfPNmgfByuReIlBPYvRXsqwAt2pvj/7P8X6IBJ+tK/g43zquDZP1T0uuJBTuBW7JUEonZK4NUTXXzdLhg7Lr7nP8CYlHz5f2TwteSvP0NEDMKq4UUIGFvlAaWkKQZp8zj8FZDzsccH244hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956341; c=relaxed/simple;
	bh=AqnwSS/WaDLDI5K1uKnWSzJUH47MkvyemMAXc7rIxSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lC+LWIwTz/HvFewElD5xaUIEmnDQNCgNnkHoFiysV/UKkMgLJuX/axioSBoPrdzuATQ98r0jmOxth6zIBi33AuiPg5b9Lp5/9WS+2Sf3I97ReGtnqQloHEzIVXJfnb6YMiXnG1NSyLiMPetN844GhllTwuqjfjKveEYR3mf6/mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lp76bFUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp76bFUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89023C4CED1;
	Wed, 19 Feb 2025 09:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956339;
	bh=AqnwSS/WaDLDI5K1uKnWSzJUH47MkvyemMAXc7rIxSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp76bFUaMHAmD5Dj0xCeuSizqyrsAfd2TpUjihez7uLKIXrBGwkcboPXMNWvgNQh8
	 Hc8pqBZ5xcZwd0p0MgpODL79quLzSZYWOv0djpxaO2j7Vm81xKMlIkser6ZCWUjyRn
	 XRKTTKvXimiIhC/aGCNiWerEtU3pbga7Ce8mWQug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/578] crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()
Date: Wed, 19 Feb 2025 09:21:58 +0100
Message-ID: <20250219082657.466364899@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 472a989029aac2b78ef2f0b18b27c568bf76d104 ]

init_ixp_crypto() calls of_parse_phandle_with_fixed_args() multiple
times, but does not release all the obtained refcounts. Fix it by adding
of_node_put() calls.

This bug was found by an experimental static analysis tool that I am
developing.

Fixes: 76f24b4f46b8 ("crypto: ixp4xx - Add device tree support")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ixp4xx_crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index d39a386b31ac7..cfb149302e0a9 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -469,6 +469,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		npe_id = npe_spec.args[0];
+		of_node_put(npe_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
 						       &queue_spec);
@@ -477,6 +478,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		recv_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
 						       &queue_spec);
@@ -485,6 +487,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		send_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 	} else {
 		/*
 		 * Hardcoded engine when using platform data, this goes away
-- 
2.39.5



