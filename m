Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADDF3A7F5A;
	Wed, 21 Jan 2026 18:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019799; cv=none; b=A+xxudSuHR9Nb9GIOoC21qzVz+g5b6pLJ7sfGCFSEGug2GOO9levPEBxL+Qsn5elwnz+UbtFy3S4H/kCBsUWJFnJ1VN9PhDewh1bUIRskHXA7J4SaSuAUmr91vd5+vlKBvGoyb6z1u7OMXJCgF/Bb4pXhIItLlJqfCLGDhlXBj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019799; c=relaxed/simple;
	bh=sSrT81sPSuk4Az8yv+kvuizomqhQp5t6xtrOMBGOtTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVZabtnMoVlxs7cILdASwrDzFti8N18qxLQ2ZizDZjvBHGBvxImvaLDLORO6fG/Bz1C5mM1o1agoDGxBzrZsWdO9FwGl1df0i/Xedt4Z8UawYuKY3q+mvrXNXqttmD7dNT6OXEyljJFOvpTIeb0v29tpPYtMhRd3tVV3qdBesPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pjn6K0ag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pjn6K0ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55AFC4CEF1;
	Wed, 21 Jan 2026 18:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019799;
	bh=sSrT81sPSuk4Az8yv+kvuizomqhQp5t6xtrOMBGOtTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pjn6K0agyKSGZxzTvZodXHIrVJ5w04qbSRrpIsFV3/Jbzc6ohL5uoucuwQCZ5cmpc
	 errDjYQtLMDeKwHpqVCr8+czz9DBcTzgZEKsrbbR/Xk4X7BLL8pVgF+8YRauXElS+l
	 0S7keDm+38RAhICSLYiz6ZjmIXv5EemQHC3tArqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Butsykin <pbutsykin@cloudlinux.com>,
	SeongJae Park <sj@kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 094/139] mm/zswap: fix error pointer free in zswap_cpu_comp_prepare()
Date: Wed, 21 Jan 2026 19:15:42 +0100
Message-ID: <20260121181414.836439635@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Pavel Butsykin <pbutsykin@cloudlinux.com>

commit 590b13669b813d55844fecd9142c56abd567914d upstream.

crypto_alloc_acomp_node() may return ERR_PTR(), but the fail path checks
only for NULL and can pass an error pointer to crypto_free_acomp().  Use
IS_ERR_OR_NULL() to only free valid acomp instances.

Link: https://lkml.kernel.org/r/20251231074638.2564302-1-pbutsykin@cloudlinux.com
Fixes: 779b9955f643 ("mm: zswap: move allocations during CPU init outside the lock")
Signed-off-by: Pavel Butsykin <pbutsykin@cloudlinux.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -866,7 +866,7 @@ static int zswap_cpu_comp_prepare(unsign
 	return 0;
 
 fail:
-	if (acomp)
+	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
 	kfree(buffer);
 	return ret;


