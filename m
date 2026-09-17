Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720CC33CEA8;
	Thu, 17 Sep 2026 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671005; cv=none; b=GlXHEGsPCCHyTfcmcuDxIj0aXmH6cTjw3mbmdc0H5XEO4KEycvcY/sOkUgLMCVi0JvbBZx4UI1errIV593VKhLOOvvrVu9WhfHxA+oknw9pFUBsg10axhV2gq1/Ma7uBKxV5H627WbgmnM1x02y1N3jdnlbRvMRaHqO9ljJN+GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671005; c=relaxed/simple;
	bh=5C35yrfalMjEHnojaT67oz0YxbfcXWssGvXF5yRq7Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSwF8dHfHW/GJYxELpi2uvm5UVZhG0RKk42VbQQrshh6zM7LcrytZzG8VHHAozKXReqqc+rKDT6LjFXijRZkfd2QSynyaJsGAxYLltIgYlcwcAxQ0YOkijNq2XuuvsYcSklSYGy6cZhh2gRo9IRvq9wChbCbiDEZuqs6wMD5KCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6mHcvb2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6mHcvb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37881F000FF;
	Thu, 17 Sep 2026 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671004;
	bh=xFSMshyxXnX61nyzX6HPZWbB1O//2g58Avyicg3lWx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6mHcvb2unK7iea2aziat4Zsrx9UeIFw/u8IpTuVTlqtW3W78W34cU3vpUgRq+xPa
	 JTnWcs9hKsFB6PukgWs7hJlkG3qgfkyiRDjj2b/WeY6fc6tTfD93Zzn/+9tWCNJp4o
	 zCVByBRFPcF8uEpS1qsmO41kakeWCajNtfoZRrXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 0837/1102] drm/i915: Fix memory leak in query_perf_config_list()
Date: Thu, 17 Sep 2026 16:13:00 +0100
Message-ID: <20260917151601.531793151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
 


