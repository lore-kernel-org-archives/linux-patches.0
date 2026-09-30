Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8AD3B3BF2;
	Wed, 30 Sep 2026 19:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795616; cv=none; b=aMxHSHpLSHIGJ4vXZxCk1ygDJIsVDe2lBMEji+AGfkSs8mSwaxHt+9HXqfeN69vcGfi5paDrqOGfmmFNPXhgIVk5SVNEVMxxdiSP4BJ8Fk9M6qs/GCby8ELbRmZolMoE9H+U5vgZx/femYyzzhnKQ11qFD4aCNzZL6/TnM+hePM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795616; c=relaxed/simple;
	bh=kWG0hYClp577Ir7cpBltK26IIKIGy6mOPzCkzJuXaXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puXCxKPmdV/KzEJl0fduG50FDR6HWHBT69Zwl9ANklIwshiUzU0ahXcoRbgHDFTOqrTc05fP2gunKdA95BOSXoIb8to+AGwwciKaEQl8u3bGK5KLndsCs/8TtBi6aDBSHBIrLmTm+1ANcXlZnn+cN8WeK9LbENsPo6QO/gDCQa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLshFKCU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLshFKCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 548B91F000FF;
	Wed, 30 Sep 2026 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795614;
	bh=qSb8Q8E97svok+nVhaXZESDVY2WrqZoSotV5GKtPZUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLshFKCU1MHUv8X8aWtUWDa203gfrxq8Hw42AZ4inRHhtn8FI5w6758RJ7CAwP+/+
	 5TJ+CJ2E0PxxyzKJFIo3PuHC+Q7KBYh2g1JhJ1xIOc7IT1I8tO8Ic74S0Ipi/1K9eK
	 MxWHjcvkIjphLWrrqxLb+NpiKEfoVqG6p69d8Sjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.6 0624/1193] drm/i915: Fix memory leak in query_perf_config_list()
Date: Wed, 30 Sep 2026 17:21:48 +0200
Message-ID: <20260930152448.105614468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit cbd3dafc2003db679ccd2f6c6a2551db79657049 upstream.

When krealloc() fails, free the original oa_config_ids before returning
to avoid a memory leak.

Fixes: 4f6ccc74a85c ("drm/i915: add support for perf configuration queries")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patch.msgid.link/20260823205028.178597-2-thorsten.blum@linux.dev
(cherry picked from commit 9977e9d84f46d4f12ad35fbbc0ec4638554bce87)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_query.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_query.c
+++ b/drivers/gpu/drm/i915/i915_query.c
@@ -401,8 +401,10 @@ static int query_perf_config_list(struct
 		ids = krealloc(oa_config_ids,
 			       n_configs * sizeof(*oa_config_ids),
 			       GFP_KERNEL);
-		if (!ids)
+		if (!ids) {
+			kfree(oa_config_ids);
 			return -ENOMEM;
+		}
 
 		alloc = fetch_and_zero(&n_configs);
 


