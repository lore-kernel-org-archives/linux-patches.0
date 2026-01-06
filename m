Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC7E35E558;
	Tue,  6 Jan 2026 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721692; cv=none; b=QcVVq4RouWiTgFY6vAePODWlTB4uu4k6jJ4IESpN0VomqPusS8dr3Kk/GnxeoqA8NQd7LBrJ0xre/Ko88z4T/KYkS+7YQYjiGVwfSh/knCngXi0+CfyHCu6GQXFFUu5IkY8FMgJNYprBI1Kp/rM0SP8UbRux4uuvV3BbMMFZmNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721692; c=relaxed/simple;
	bh=d1yJbe3wHVhS1apXcco8dG1cxnf1PVQb03Y23+m30oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ex7u07hcmWF4CtLpw68As3dnuZZ/79Y8wMKFdhWUS5wWeBjp/x8gn2ZtP188pLg1CrPET1lsVIBnWrdS4VEcEPJf62lwqvV2sqoz+/p6YafvubDsKnwoH5jIeFIZllfUbWGdCG6Oky9YazXcjYHp8n/+SEUDqO/Rp0zKyXEiKFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZJGcfsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZJGcfsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B916C116C6;
	Tue,  6 Jan 2026 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721692;
	bh=d1yJbe3wHVhS1apXcco8dG1cxnf1PVQb03Y23+m30oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZJGcfsDE7ahINWxrhoQsW7Cx+B2Orr20vHIBnaBfRRK9s0gLuaoOAWIPRK6HJfIJ
	 /oXjTxQpiPdb6i1vhWTZpyEXw5TT1P5A9m3fisGADnlLWL+Fv+T9Dg6Gp9tQ7Eq5aA
	 Nl38haphU9BG6LM+sFm26P9JLW4X35cPrcV1GH2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 043/312] platform/x86/intel/pmt: Fix kobject memory leak on init failure
Date: Tue,  6 Jan 2026 18:01:57 +0100
Message-ID: <20260106170549.414872914@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 00c22b1e84288bf0e17ab1e7e59d75237cf0d0dc ]

When kobject_init_and_add() fails in pmt_features_discovery(), the
function returns without calling kobject_put(). This violates the
kobject API contract where kobject_put() must be called even on
initialization failure to properly release allocated resources.

Fixes: d9a078809356 ("platform/x86/intel/pmt: Add PMT Discovery driver")
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Link: https://patch.msgid.link/20251223084041.3832933-1-kaushlendra.kumar@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmt/discovery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmt/discovery.c b/drivers/platform/x86/intel/pmt/discovery.c
index 32713a194a55..9c5b4d0e1fae 100644
--- a/drivers/platform/x86/intel/pmt/discovery.c
+++ b/drivers/platform/x86/intel/pmt/discovery.c
@@ -503,8 +503,10 @@ static int pmt_features_discovery(struct pmt_features_priv *priv,
 
 	ret = kobject_init_and_add(&feature->kobj, ktype, &priv->dev->kobj,
 				   "%s", pmt_feature_names[feature->id]);
-	if (ret)
+	if (ret) {
+		kobject_put(&feature->kobj);
 		return ret;
+	}
 
 	kobject_uevent(&feature->kobj, KOBJ_ADD);
 	pmt_features_add_feat(feature);
-- 
2.51.0



