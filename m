Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE958345EDD;
	Wed, 30 Sep 2026 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791674; cv=none; b=eEdNs8vCGp1H+idgVADtpdv2iGngJs8t9mcAkHTktis1Fpj+bYHWUWzYNhY8bvhHLuNaRKlR8PSTm49uJrFYFrp39nmadA1carCzSNl8x5CaMAb68N873VX0jGWoDjdKuIBO+PO1DI8+sB7rgHzE+y3XMh54/e0YPG1+DQEa2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791674; c=relaxed/simple;
	bh=T0BpfalZ4WrSsqSm2xRHrqjZTljlyJTq69jr96GlfOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDlxcjOOPoUFADZ7gwcoS31QRbye+h9tFWoEVK4KYiK5P6tY+fDt9nqQ087qaLq7zKxMZ5fwpIqjKkzLTFASgT/X9eqwEELIgL7R+b9MXg/e7OSlPhMPBzRCeyoI9iA9Gvgh/H0jxGwZJ6/z4dX97Dx8buZF97PKqea641IWLcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAXWAsT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAXWAsT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3541F000FF;
	Wed, 30 Sep 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791672;
	bh=1/XtqzBU4RC+k/7IzYn7KA8ERb0hD8xYXvr3+pLF5hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TAXWAsT+ZiRUUNA1AJu4VVVjspuQlSYElPJ3kEK8nuLAJR+DUx+Qs0cWKR3wFAHtj
	 o3ZMqx7ZEzMbiOJy9701AE6IUt6WN/prne4dd2VrFvhCVZbq/+ptUsq4S3B7RV1k8u
	 E+v2RkKnoidlxy1ZL3eb29VB4vrE9M9txxzJA1aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 385/752] drm/i915: Fix memory leak in query_perf_config_list()
Date: Wed, 30 Sep 2026 17:24:15 +0200
Message-ID: <20260930152406.608047082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -364,8 +364,10 @@ static int query_perf_config_list(struct
 		ids = krealloc(oa_config_ids,
 			       n_configs * sizeof(*oa_config_ids),
 			       GFP_KERNEL);
-		if (!ids)
+		if (!ids) {
+			kfree(oa_config_ids);
 			return -ENOMEM;
+		}
 
 		alloc = fetch_and_zero(&n_configs);
 


