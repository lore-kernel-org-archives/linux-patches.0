Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA84158D68;
	Mon, 29 Jan 2024 17:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548131; cv=none; b=uqMP0qgx3XpUGaPac1pokdd6iuJGinsDoXgszLt0bqBTiNw9cc0J29U7rag/KBIy8iRd1DZHlxp6U5ZEhL4wDgBDl9wEV36UJO/L8i5thdY6f9D5kIgcpebjkbN4bc58koNN5Ph3yfk01hsPTDN9PQ9hXINqHE0GYw5WfivDlLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548131; c=relaxed/simple;
	bh=yLm8MTD9JYWjo0VKVJ+2HPfzPIMw7CCTz70UHQXwFqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cy8mBICqVsKW4orP+K6fKFUlEtwfT2O5c7PDgDOfq1RNkhsZ3Y+LXT8Y3dHzG7s6QyGNtgJyQAhEvZ2Ncf2vF6d8CNMQriT7K2NXprzfBM/+tnCCBQd5NW6RZeN1xfIP6CJb17Wrp6lSo8syJDJ6xEeN2t3Kpk2eKtEZZrFUWTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROTZDKJc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROTZDKJc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88342C43390;
	Mon, 29 Jan 2024 17:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548131;
	bh=yLm8MTD9JYWjo0VKVJ+2HPfzPIMw7CCTz70UHQXwFqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROTZDKJcs9St06Qg7yHBqZRVuvbXYbeUxKiPhMF93tw4PTCh3bYW5me6qDANnpf0d
	 5mSx8wlAp3JEoICjEhRr1u5TYO5RjPLGlHa7qj2fbj+bCn+7cUvgS1Mx7/k2w+Mjfm
	 lwgW33Z7pZOHpqQ+4GfoP+SGaoDU5Bu6CUmeAiWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 161/346] dpll: fix broken error path in dpll_pin_alloc(..)
Date: Mon, 29 Jan 2024 09:03:12 -0800
Message-ID: <20240129170021.136506619@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit b6a11a7fc4d6337f7ea720b9287d1b9749c4eae0 ]

If pin type is not expected, or pin properities failed to allocate
memory, the unwind error path shall not destroy pin's xarrays, which
were not yet initialized.
Add new goto label and use it to fix broken error path.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 830ead5fb0c5 ("dpll: fix pin dump crash for rebound module")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 3568149b9562..36f5c0eaf604 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -440,7 +440,7 @@ dpll_pin_alloc(u64 clock_id, u32 pin_idx, struct module *module,
 	if (WARN_ON(prop->type < DPLL_PIN_TYPE_MUX ||
 		    prop->type > DPLL_PIN_TYPE_MAX)) {
 		ret = -EINVAL;
-		goto err;
+		goto err_pin_prop;
 	}
 	pin->prop = prop;
 	refcount_set(&pin->refcount, 1);
@@ -448,11 +448,12 @@ dpll_pin_alloc(u64 clock_id, u32 pin_idx, struct module *module,
 	xa_init_flags(&pin->parent_refs, XA_FLAGS_ALLOC);
 	ret = xa_alloc(&dpll_pin_xa, &pin->id, pin, xa_limit_16b, GFP_KERNEL);
 	if (ret)
-		goto err;
+		goto err_xa_alloc;
 	return pin;
-err:
+err_xa_alloc:
 	xa_destroy(&pin->dpll_refs);
 	xa_destroy(&pin->parent_refs);
+err_pin_prop:
 	kfree(pin);
 	return ERR_PTR(ret);
 }
-- 
2.43.0



