Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215728;
	b=cI5fRoT8CzGySuHByDwuUs0GpKM5Rdxn02SiqtCciSZlseW7IDeor5eOCk8xk7zJ2Ezm
	 RApK+IhZXJzzHJuXTPcp3rjHHKzPIfPraLf/r1j0E9V5EKAgRkwJwiba6jL5+ctDgJmhe
	 aOjTen5pK58GeVxUQM9hCBRAuLc/uV3k80s3TQGDuSbC+5u66i6LBeGWo4F0WC8NAdRQ1
	 v+ZRYH3LXnX22W8kg2xmsm+8ciGuq8/LTzG+1pw6sufJ00R9f+/xPlIpVAzFUqd1axOl7
	 LcWDBKw+eK+B0gg1XJq5oI1S5BmWTq6DnvsPj0oAWwqFXEABI7FRu6IEcbBscO2mwow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZaYIbzciuplCPmAqVnS8Qh88UYebOgmd/Bc+AS+En5c=;
	b=jKMWkaD8aMs8glROWdWabXY10f1rJTrWS3VXEEke4d/Y6fivZA/IJfahaWGGYDggoP1X
	 9bdIcEavgbbg4Zx1eGc65Ayx60gGCvMaYgsoeEGSOudpGNocjjvOtsMROAGXLpbxLTbKj
	 U7fqzomRS7rRBdDWU/FVhAD6qqOcYTJ1pNeGTdTE1gzX9Y/Wn4nvjIUB3efSXsgEjumgi
	 zQxFpEuVqfh2cJufAhO7fRVmT7mLCT71R7uDigAYsd8/FHDVsvFNQlsY49jq3vJq8+3Dj
	 1o16VnX4TXBnCTpS4E8qW9eIrg8UOzn0kDwJuXL1WVTZI1bURo20+PB4R+wTOpSqwhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iske3iyN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D24606A31E;
	Wed, 28 Oct 2026 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iske3iyN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11021F01825;
	Wed, 28 Oct 2026 19:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215728;
	bh=ZaYIbzciuplCPmAqVnS8Qh88UYebOgmd/Bc+AS+En5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iske3iyNIf+9mnvQK/oBHFC0hsK3JWS8OsBqmORw07CfqJpOY1pyc5+hO9zuSZ9fW
	 IDw7+WxMOI9YuMObKMp0encKUVIbw35XKlR/DQFtY2YhTmH8hJG9ntRt0xV3Icz3Yn
	 4o4S6MEFpsjkzJ2+vvFZR7wegN2z75baB52xV5V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ling Xu <ling_ling.xu@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1275/1887] OPP: Fix race between OPP addition and lookup
Date: Wed, 28 Oct 2026 17:56:11 +0100
Message-ID: <20261028170528.436621104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Di Shen <di.shen@unisoc.com>

[ Upstream commit f5e1cc9a284bff2510981643a5bca4bc4c21b81a ]

A race exists between dev_pm_opp_add_dynamic() and
dev_pm_opp_find_freq_exact():

  CPU0 (add)                          CPU1 (lookup)
  -------------------------------     ------------------------------
  _opp_add()
    mutex_lock()
    list_add(&new_opp->node, head)
    mutex_unlock()                    _opp_table_find_key()
                                        mutex_lock()
                                        dev_pm_opp_get(opp)
                                          kref_get()
                                        mutex_unlock()
    kref_init(&new_opp->kref)
                                      dev_pm_opp_put()
                                        kref_put_mutex()

The newly added OPP is inserted into the list before its kref is
initialized. A concurrent lookup can find this OPP and increment its
reference count while it is still uninitialized, leading to refcount
corruption and a potential premature free.

Fix this by initializing ->kref and ->opp_table before making the OPP
visible via list_add(). This ensures any concurrent lookup observes a
fully initialized object.

Fixes: 7034764a1e4a (PM / OPP: Add 'struct kref' to struct dev_pm_opp)
Co-developed-by: Ling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Ling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Di Shen <di.shen@unisoc.com>
[ Viresh: Updated commit log ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 4211cfb27350f..0ba25aba48abf 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1993,12 +1993,12 @@ int _opp_add(struct device *dev, struct dev_pm_opp *new_opp,
 		return ret;
 	}
 
-	list_add(&new_opp->node, head);
-	mutex_unlock(&opp_table->lock);
-
 	new_opp->opp_table = opp_table;
 	kref_init(&new_opp->kref);
 
+	list_add(&new_opp->node, head);
+	mutex_unlock(&opp_table->lock);
+
 	opp_debug_create_one(new_opp, opp_table);
 
 	if (!_opp_supported_by_regulators(new_opp, opp_table)) {
-- 
2.53.0



