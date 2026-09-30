Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB254F68C3;
	Wed, 30 Sep 2026 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785466; cv=none; b=Tj7DofBj7t/j3+p1mOejZwaEQnGDMUBlaFs0jC0m7mgyW6sPkbf+jRfxX17befAadU8vLSJ+cnOkqzHSFeSHNBzjNDx3pQTziMGkTKPmS+acXgr/xwCFveuf4wBNHa2SRVB1emRkjo87E9RLHQ6dPbWJX0CIYpiGpjsbWTFo6RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785466; c=relaxed/simple;
	bh=W25Kf6Z5GplfO6eHyrI/VKV45huboxdcbXdr8SIc5vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmqDl6nLZO9ledCK5WbBOQRw2G2eHwU0XGHA8Re6VvTVM+xPEWY+9iy2JG7C7XW+f4RsEQr3i1j9SNfvy6ONeDf5MZIM+ue1Ltp23Nl4vcMJm7PBgsxFSpsUkFJO5SXBCG+KitVVdQEIaKEhWa4eAxoKZCUt+Gcj0cnA2x2F/g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdK1pkk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdK1pkk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1181F00893;
	Wed, 30 Sep 2026 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785461;
	bh=3j+r/S/jIp6zdfFbX4tRZAhWfEo+JikjlqQ9NyzfaeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdK1pkk/GEGvzyM94chqCAGuVsyHuxTacHaDc0Cm66j0adO/XWQXz87iY3Pd3W3YF
	 2MKxrB3V4R9Xa8a0sJMamZnuLpzwfpc6X2Wz5SM2X7/Zn2xbfg/kVXBxLvEajPnZDo
	 NsCXiBQuRnowtLzyIugkFaYMbEh/qRgW/sjBlNsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.1 517/982] drm/i915: Fix memory leak in query_perf_config_list()
Date: Wed, 30 Sep 2026 17:20:53 +0200
Message-ID: <20260930152427.882672273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -400,8 +400,10 @@ static int query_perf_config_list(struct
 		ids = krealloc(oa_config_ids,
 			       n_configs * sizeof(*oa_config_ids),
 			       GFP_KERNEL);
-		if (!ids)
+		if (!ids) {
+			kfree(oa_config_ids);
 			return -ENOMEM;
+		}
 
 		alloc = fetch_and_zero(&n_configs);
 


