Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58458229B05;
	Tue, 29 Apr 2025 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945328; cv=none; b=rbFXhvOKIPiFuVJIUbSXbDMYjErO/MDl+pvzvYobWUv4EKf5JqWLTCJSgSm3wni2XiKrs7417KwQGgEANpvpyxW4u5xjjDVExB7GIro/KZS/ErlYpbjffDSzZVHiY3Y60ryFDxu3MkhLFk2FZ+8OVn90cRdsHDWVPG84bklNVzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945328; c=relaxed/simple;
	bh=LGtv5277mREodKUyRIu1taB9JVVb62AT94/p4GNJj5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1PvOJ2yRIpaLRs5CwRDdP5/2ZSltcvps0hz61ny3aiJ6syya8R179oYDEU1h6UShqbE0Ki5Oo3GvOvbNwYzVLPPiKo01jxMYqgduNEa6gIlfkA8W7ff1T2ZY+/NB28uY+Qddo5Y+d9D2tRgc0aCpsLDn1Bghy4KQtegHTVZKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jK7Rym5K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jK7Rym5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB658C4CEE9;
	Tue, 29 Apr 2025 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945328;
	bh=LGtv5277mREodKUyRIu1taB9JVVb62AT94/p4GNJj5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jK7Rym5Kc4AQiYcxEt6SHv4F1vThWtyGHgrYkIjaWNJ5uFZX+y5Kq7ZzdUIJfiaCt
	 ComCFicTEMAE1GtezeVcb0wHM90ooaOK0t4B/pfriUp/pga30AFn3kRXddkxJno54Z
	 Yi3cQwxAFsLU3pdb8hzGLEO/Bw/bAV403OroXzXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 5.4 075/179] of/irq: Fix device node refcount leakages in of_irq_count()
Date: Tue, 29 Apr 2025 18:40:16 +0200
Message-ID: <20250429161052.449660883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit bbf71f44aaf241d853759a71de7e7ebcdb89be3d upstream.

of_irq_count() invokes of_irq_parse_one() to count IRQs, and successful
invocation of the later will get device node @irq.np refcount, but the
former does not put the refcount before next iteration invocation, hence
causes device node refcount leakages.

Fix by putting @irq.np refcount before the next iteration invocation.

Fixes: 3da5278727a8 ("of/irq: Rework of_irq_count()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-5-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -443,8 +443,10 @@ int of_irq_count(struct device_node *dev
 	struct of_phandle_args irq;
 	int nr = 0;
 
-	while (of_irq_parse_one(dev, nr, &irq) == 0)
+	while (of_irq_parse_one(dev, nr, &irq) == 0) {
+		of_node_put(irq.np);
 		nr++;
+	}
 
 	return nr;
 }


