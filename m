Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE142F12DD;
	Fri, 17 Oct 2025 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713735; cv=none; b=uRMmRvqLFIG394TUpXg2R9x28bxElutWIJKSvH+dcFhXbZlfCf3n6JdePHijj0wQLXs8/5nlWOkGzry41OKIX1DoFGCw/1GDym9ku/n/srodQpBXYBQcHiF6Qz6lay2YWLz2z54K4GgOdU4cTo/wVQGdbXykDewzocVgSbgL3QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713735; c=relaxed/simple;
	bh=fRselGrkgSb4tIu2huIn5vHNrlm7PXCn3gEJ9SrcgUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8Ejwzzhna6ZJ9ikuZddMfqOWmYbG2OfGEBsRwytkY28cCCMcroAg/8iTSXOO8WKSa9protmwbFLp+GlCQdPmng9jJ5Nc+MRtXNSIg2JhGrDg0UUwjvaC1oWQJzW2pX/XsqFOKgYU7W0aJtVROzUZez/LVqYWDdQFZpTHDBYrGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZS9S8hxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZS9S8hxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F72C4CEFE;
	Fri, 17 Oct 2025 15:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713735;
	bh=fRselGrkgSb4tIu2huIn5vHNrlm7PXCn3gEJ9SrcgUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZS9S8hxVX3j1ikVv01c2+rLhe/qqzPI9XDytzLmTxofYyhyFX1NVSQlTbL20j63AY
	 1Gan89tG9feXt6Y3miB8Dp980XLccAGhyVDpQZm+7yawAwk7EPFZi0M32xFWf+wscH
	 sOMGWip2erSYTeUH91kOi5llX6JtDfHWemZgbV4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 101/201] lib/genalloc: fix device leak in of_gen_pool_get()
Date: Fri, 17 Oct 2025 16:52:42 +0200
Message-ID: <20251017145138.458067055@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


