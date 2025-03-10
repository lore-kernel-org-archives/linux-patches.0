Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63A51C5F1B;
	Mon, 10 Mar 2025 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628846; cv=none; b=Me1sUc5opl532xuISljsYiZv64VkgkD3yl5uPKRUEAY2HInUNpR1eNvI3GoBb5qBsoDNiI8FdJaffkcXNlfYuZ2c6TlWEijIJoels7SYgDi2PMeXu56n5MWZZ36clMCGu0llkh4gMEKowgMPPlMfQv3DL+w+mk+7+Qy157KpmtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628846; c=relaxed/simple;
	bh=Q7JBzymQ/ouwM+PoKgYYU6qJgZshkCh3+/fTb9Gyaj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyLp1n4U5PKmh2ojOS0HS9s4VycZcOL+hJ38LNIdmEfq05vlya1bE9CFzwxzJpq5SWCR+6lAwISPGS+MwZRp/LT8KTLu4v7wVg/8Z/4WEzNZXzGqA9O2QoBcKO1KhmOgl8wjUhHpe/JjTDfTu2x4RQ3+/OsUGjdRN8Dso4YNboM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uf591pGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uf591pGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEF7C4CEE5;
	Mon, 10 Mar 2025 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628846;
	bh=Q7JBzymQ/ouwM+PoKgYYU6qJgZshkCh3+/fTb9Gyaj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uf591pGUJlSWWtIFY+pxMbQP/UDyCF17nJ6Xe42wpublGhOQr043axUApCEDC5m7H
	 f3yXdqRn272ndobhAIpCHUZX2qIhFmreYag0+MX5VPxfdXVdmqDVSrz9UZg4rQb7Mx
	 j/JePVFibPDa7D/6T9QoiIG4tlqNPPlsNco2SNT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/620] crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()
Date: Mon, 10 Mar 2025 17:58:56 +0100
Message-ID: <20250310170549.134912571@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 98730aab287c3..2bf315554f02a 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -470,6 +470,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		npe_id = npe_spec.args[0];
+		of_node_put(npe_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
 						       &queue_spec);
@@ -478,6 +479,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		recv_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
 						       &queue_spec);
@@ -486,6 +488,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		send_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 	} else {
 		/*
 		 * Hardcoded engine when using platform data, this goes away
-- 
2.39.5



