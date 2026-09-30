Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C708D353A71;
	Wed, 30 Sep 2026 15:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783170; cv=none; b=lTPS+YsJm20dZGJ2t7Qqkbb+sEW12c0tfpbipBAialalhXEy9axya5b7jJLKjGlG6lYaaujbqwrELmkJ2gn7OKwMOfTzUslfEl50p0VTgb9xg/bMXYE0dKTMEKSv03KQ/qJ8ydYb+YRnSiJ9A/sL/ymf/zyY3nvxtgDVViZz/5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783170; c=relaxed/simple;
	bh=dwTL7bqg+LQGqvgKTuW1FdhRqna0HdUfpw0dpovyY8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjJKQJpdoXy+Ybn5qksAEsPtsvVVO9nkJlKNAF7+W7wSgb17pk0II77eB1yceBdPVIx0MXa63UlOw+qaiPYHCjJOXDeDVGAqtat+3bV1agFmTyojvqShlq7RNCnOq8WOdIRi17mv0BVbA/0K+wn18ED49wvUdaNhYDpqKMvCDWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGpw61s9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGpw61s9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515DA1F00893;
	Wed, 30 Sep 2026 15:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783165;
	bh=WJiyxR6XH037PlpEqqmWDVI843yXTCRGRsqMjts8Ong=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGpw61s9tEp7luY4AowsP1VgdZpEPzkTAht6SoSQvgYWI6H/mbpNiKrLIfBHkt53x
	 fJFXd89P46mh2iUk0MIe0MS3TelY1oQnobzwKxSW1Nh+j5w9FcwGDMYbngEqr1UPff
	 41qe1QpnFyNzff49vNUjv0VxlxG2KM3l7D9epLzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 301/595] drm/i915: Fix memory leak in query_perf_config_list()
Date: Wed, 30 Sep 2026 17:23:14 +0200
Message-ID: <20260930152354.163355022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


