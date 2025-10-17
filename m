Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4478330B2E;
	Fri, 17 Oct 2025 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715570; cv=none; b=NDj91v/HpkORsVvlpoHc3myi0FrsQh193X3k3qilJjEvNaRqCJ5/ZIYPRRwvupV69HGvsCD9mVzhZkb+mVvBev09EW2ltGajKRanAJsrWm4QJg2undDBcP8wdoQ3WBgVOkPuKcpcl/5yRIuM3rBn+iHpKTUAOoEevlP+EzolWIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715570; c=relaxed/simple;
	bh=iCzwsPQUy7D4TG/BLfVcrFRcIRqO8cqeBX6vWKMvR80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiJsxl+PYZypx6fdZt0qwnu9yU0OqLdLcuQTVoLod7+PwUz2I72FxusSlkvpj0hes5z0QhmZCPm+cfPXU8Yaern2Yu/aj04rX7vs09dWqu5UozbkfJVolUWa1D5FdzIxPY2d+RO+3b6hhj+jfwqcFuod0TX03Hlut57Kyzxca0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CURUhsR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CURUhsR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23369C4CEE7;
	Fri, 17 Oct 2025 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715570;
	bh=iCzwsPQUy7D4TG/BLfVcrFRcIRqO8cqeBX6vWKMvR80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CURUhsR+YYz85COx65HidnvUnSl/Joax16OyDmQmjkcpL/rqi349qAhOxBiEWqoMQ
	 /KyEqdTyAF2+9led4eSVs+6byVViJP6ohmIthOTr4doquIXQJQ60hU9gI5PHJBIWYG
	 0GRqMCvXP+NJ8VnEq0pRBgqdFKnCY27cnBlJO94E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 235/371] lib/genalloc: fix device leak in of_gen_pool_get()
Date: Fri, 17 Oct 2025 16:53:30 +0200
Message-ID: <20251017145210.584391425@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


