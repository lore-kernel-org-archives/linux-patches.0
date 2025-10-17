Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5308032C93B;
	Fri, 17 Oct 2025 15:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714441; cv=none; b=PSrA27B1tcwRqz7XCQISmVKM73k8SxfTda/52NWGcNsQcmHrxttuRthKjOopcTU/WXV/8nBYlAGye6FSApt8Z8GcNMTz2ENtHUlIsg6+K8sdonfM+NNBGGMG1ouwOh7FNsQxgn1v9WYalKroTuMRLGqVh5KRvYdeOsTcAi7m8CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714441; c=relaxed/simple;
	bh=+9eA+KjlNZ4XH8IkqxLsjSVRYrVLuQKH71amR7a2/SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNmlYsyoIPLgyhKqlCMC8ufGKK7gjTJ74Jw4Lem/aonp1KaCCX0F0avw2ZiTse7W/WbSs5E16lRbYCfFQn/q4HARrJALnNSaKlfvypQJGW+Jag6i9Hs8REP2avBnFWsEYsVGg8J3tCp7Ndk/2cpf3lEbiE37DxLPDvtvL3YrAv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhqJ6xrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhqJ6xrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D76C4CEE7;
	Fri, 17 Oct 2025 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714441;
	bh=+9eA+KjlNZ4XH8IkqxLsjSVRYrVLuQKH71amR7a2/SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhqJ6xrTuZTPASprp6CsbR4s1X5G6YHtCpnF4BXrv5Bw8EfbiK9kOgNzvnmaz9a1u
	 7rv6aFmnRftv3FaVsZExZcezdCbt48FpFigbhvKue6LSfTg/g5tI7dXUUAVX+by8cD
	 t4xv1j4ymN9MoCM5DC7qIp+faWq0VQM/mAc+gv5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 147/277] lib/genalloc: fix device leak in of_gen_pool_get()
Date: Fri, 17 Oct 2025 16:52:34 +0200
Message-ID: <20251017145152.491121049@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 1260cbcffa608219fc9188a6cbe9c45a300ef8b5 upstream.

Make sure to drop the reference taken when looking up the genpool platform
device in of_gen_pool_get() before returning the pool.

Note that holding a reference to a device does typically not prevent its
devres managed resources from being released so there is no point in
keeping the reference.

Link: https://lkml.kernel.org/r/20250924080207.18006-1-johan@kernel.org
Fixes: 9375db07adea ("genalloc: add devres support, allow to find a managed pool by device")
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/genalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -899,8 +899,11 @@ struct gen_pool *of_gen_pool_get(struct
 		if (!name)
 			name = of_node_full_name(np_pool);
 	}
-	if (pdev)
+	if (pdev) {
 		pool = gen_pool_get(&pdev->dev, name);
+		put_device(&pdev->dev);
+	}
+
 	of_node_put(np_pool);
 
 	return pool;


