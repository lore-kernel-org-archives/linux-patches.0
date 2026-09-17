Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5151850E5A5;
	Thu, 17 Sep 2026 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666349; cv=none; b=lNrYqhsq05Me08qMMnt2pqnu7WIRN2sogr3VloobV4A1clI3ysPnR1O2isRb/Qy3lwoPoLWXO6VcBxd4Iq74Ld4dKI8hk15UBjYAzlXu7GczEaj0qouBYExjVcvuBa8WnrlJCY8UHA6Vud5tvChksAh3PSEvCbFJCA2vC9aeT2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666349; c=relaxed/simple;
	bh=xSKZBIiUO8OBT5zuIs9k0KsQm+WJ8HwB48J76OHtwJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etxxxcmIk88tWAP4meIVRDqAvVyyA7xuSUMNw2evNyguh9uVSWju0UpSv4XA5b3cUQAyy05HlLg/sKcOQJENpPI8NyCZBQdOYzlzvbZfL9QvOdWMQGQPt4ZDgHtQSOk8KCPwNsg16wDft2U5aASNiwtTeLLdW/VNjHV9wU0zm7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnLCq6GP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnLCq6GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87E31F000FF;
	Thu, 17 Sep 2026 17:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666348;
	bh=1LmCKAO6oqiVJb7qSMrhpTKWDlZLgLmgIkybD8nspO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnLCq6GPByRBN09cMvNbnQD86jem3o/Hv1wzDbiyZxqePleMFnnOvHx2Wwhk2b+CC
	 d7ib91b0O79EtKGYSCCGXkSJMXson5pXMWZcDjfBYhYzLC9H/9Y5cph35lXMJ/sbUO
	 VKHVxJ1aj9QTi94mKU66vAK++NnZV/DGfbkzblao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.18 1007/1250] drm/i915: Fix memory leak in query_perf_config_list()
Date: Thu, 17 Sep 2026 16:13:22 +0100
Message-ID: <20260917151619.337372035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


