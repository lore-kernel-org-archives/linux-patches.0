Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64CE8003D;
	Thu, 17 Sep 2026 15:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660267; cv=none; b=hwSZPx9jbc2Ht2luyTyq/OosUFN4EdfpWNbDcq0VNVi24oXMMqP57fXECMcdQdV0SFrjTh/YGOUVXQjowT0luaNsJfJ0DOD4Sji6YhNyYz0FYXqQQmFqMD6iyCrMxOFq0XaGFO7xBse/cCg7BZRRsS/PSLco5UkV/nhodUPRhQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660267; c=relaxed/simple;
	bh=RFdFpv19o0LYowLZlSanM/yoT/mIHSg32TuyVgkvMTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXKSygfF2LQd8RoRVRzuBAZnCnyn/tG7+KJE798+xtzK0zAIz2Edlr5KsEjNU1yVe+54FRw1M/A9VD+aEzI1sb4Xqd8w1+bCT2KJLAf8cGk9YaihoLqpcnC/uB9PfFgy1ees0jt9A3WCXcJFiFe73EtVYGxviiQMzMqjkS1NEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TxX+VaZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TxX+VaZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107BE1F00893;
	Thu, 17 Sep 2026 15:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660259;
	bh=fO4+hnF3gl8wUtUUfutrJBkPm87hxvHzebu/K0P4I+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxX+VaZy4UYaE3v7xKjDpeVO3A476JTx8mKsjBXELTfUjgn+/98dJjX9M/Iy+gtgZ
	 EXPmgTLVxITcD+iRq+M5kxk9iq7UyN4WY5q/GiBQUyA6rtiuOSyqGVd4DaKGlDFbn1
	 KdJdQjdwe50GeIYXlDcTYs+KMNxWLlvJ65g7wdfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 7.2 531/733] drm/i915: Fix memory leak in query_perf_config_list()
Date: Thu, 17 Sep 2026 16:13:59 +0100
Message-ID: <20260917151405.428606639@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,8 +403,10 @@ static int query_perf_config_list(struct
 		ids = krealloc(oa_config_ids,
 			       n_configs * sizeof(*oa_config_ids),
 			       GFP_KERNEL);
-		if (!ids)
+		if (!ids) {
+			kfree(oa_config_ids);
 			return -ENOMEM;
+		}
 
 		alloc = fetch_and_zero(&n_configs);
 


