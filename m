Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211855;
	b=Y2Omk8CZEul1RpmiWhqBTxEQB0N0/4niy8MALvbpjLLj1DvGxEcCT5RzRbMU4/+6pNEk
	 WYZa4lH2pGoGdVbmJkyWFOrOFs/S+LHlsd3YodEFwW12lQHXy1KnTp0HIB3DwdE0MwH2R
	 d7ySDt30D/r+uIfCfKtQtT4OBIpUXi4kV0raWAYEV+0jdWyEB6VNLOX2gL4V/SYLWdOkX
	 KFRdvBWgHmoZ8raHQX6R5Q0oo9w9qYlUhn9uf/+wjyRtJCD06VAKNWJ2CGITHSBZCAL97
	 6+h2MwReHdJdxl6nY4zIDWToY1lD5jTbc3xGpaxl/OZc/dRNdUHwsRV/JLvCXhwDjWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zjGMlgY3H5JR0P12ZizKAehlDz3ZurLV03ZUK6bPlrM=;
	b=WzISQ0q/xK9ViYzgqcfAegsjO0iN8/fQqNNt0j4kwBvAogDe8qXOSfFb5Tx1iL04yJxT
	 pKE1vfXZMflpaukpP+nrnU6khYTpxM27g/uB7Qenj+vfKRCADIjMh6SmuFv0ALWeFktVK
	 l0BWYf4xra7ejQbFHmT6KRTR9yZ+odWBD1eUbGt9taubzpwU+v4CqvGfkc3FyxInwCwhi
	 zG6w/heRtswmFADXEOry6Z5hgij75bUNDQXdrEglfR2YAKvj/YINItbffh72rKDIBXz8m
	 OG992LLspO8rZl6uUdwxQxSTYd71d6itrdRWdMvHUPXsxoktyjzgvpE+u41xcBQJpaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZelR6qW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDBF606A31A;
	Wed, 28 Oct 2026 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZelR6qW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB031F01825;
	Wed, 28 Oct 2026 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211855;
	bh=zjGMlgY3H5JR0P12ZizKAehlDz3ZurLV03ZUK6bPlrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZelR6qWsGI2TF7z1OWQ0G0eUP0tOnjWYGkIWzNjwiH7yMMLSIYvQYRSkBcMgy7MW
	 eTSr44GA8F3SN6vaRcqjoDpG33R1k+3+oudMowgkrXxiKCvMwu/1ArHCrm5W+BgOhC
	 YotdZENqQEgGsBKQpmsZLwGH1g/Wfm3sr9xNhXjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ling Xu <ling_ling.xu@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.15 525/571] OPP: Fix race between OPP addition and lookup
Date: Wed, 28 Oct 2026 18:01:12 +0100
Message-ID: <20261028170020.488419051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index dbd69d8e44e42..4bcea866954a5 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1720,12 +1720,12 @@ int _opp_add(struct device *dev, struct dev_pm_opp *new_opp,
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



