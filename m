Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97C7195811;
	Wed,  5 Feb 2025 14:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766469; cv=none; b=rT22gcVrnEoAb1D/UgnDZ8bMMg2bmUq7lalQHvy0WW5EJDH8aW+/cFsZkz+Hz3zXpQ3AZnia4ISi63+gMj+m1IgMnX5U6aSJiTOOuBnUOtTyMPTUn0t0tw5VcxvaVGA1csfF9umDsaKKcCE7wa6J+fzBVwB1ty5Pvdmi8nnwbok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766469; c=relaxed/simple;
	bh=zPvB/gozm8Di/91X9jmSGnjvbdKatgBTMdaFIub/Kwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7Kn/dvzX0/BFL67U3Ouqugrlk5LX68HRzmzKzwPOyffOwytXOnzeESTVrKTecR9jC7uAMUdM9jdlbS3KDl7u/ocFX+TDW7o6Bs7TFwT9L+qvF1DTgSNu3iFycI02PgHf8LyBj0zIXaefaqPb3v4Xy0fvX3AeRk26qZWZ5AVSD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmLvc16J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmLvc16J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D187C4AF11;
	Wed,  5 Feb 2025 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766469;
	bh=zPvB/gozm8Di/91X9jmSGnjvbdKatgBTMdaFIub/Kwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmLvc16JsE0hFntb7yf001cu6CQABxiMT0yGcRjTOhpUkugDgR9971M94rwu68P9g
	 58NhoLuohMQ3kihalMPBUDmtFiwIN4pInejkXZzFqOnv+DY5Oo04pFYCSsCLXwhpFP
	 l31ljN1OOEOfux+dgblEmV0DHE/cq5InoCLf3iNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 279/623] crypto: ixp4xx - fix OF node reference leaks in init_ixp_crypto()
Date: Wed,  5 Feb 2025 14:40:21 +0100
Message-ID: <20250205134506.903913521@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
index 449c6d3ab2db1..fcc0cf4df637d 100644
--- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
+++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
@@ -471,6 +471,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		npe_id = npe_spec.args[0];
+		of_node_put(npe_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-rx", 1, 0,
 						       &queue_spec);
@@ -479,6 +480,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		recv_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 
 		ret = of_parse_phandle_with_fixed_args(np, "queue-txready", 1, 0,
 						       &queue_spec);
@@ -487,6 +489,7 @@ static int init_ixp_crypto(struct device *dev)
 			return -ENODEV;
 		}
 		send_qid = queue_spec.args[0];
+		of_node_put(queue_spec.np);
 	} else {
 		/*
 		 * Hardcoded engine when using platform data, this goes away
-- 
2.39.5



