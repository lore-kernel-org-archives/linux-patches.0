Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209458;
	b=J33JKvOkrOiHz5sIb2nkW/YFWUlnKxRvU8sMGLSyvSmd9QjrV9UUDMARdlKLmuIcxPZd
	 8pexgBVkXROimUQ+m8hstgJKsTRmprZKOn4uWV8vrwA3PUhH0h/cjTUhKvifiAkYYb1sl
	 rImNv7cmwHpHoMF4iz1aU7bpvH+fElHYIHHSUbAiLsGsv6icO6xxvK3TOWipHYTczBvmD
	 htCU048RWDBNzXrYs3mP9F4tFVT6ysv1Blonl2X2pNyaqRVVK4gOJ8rUvZZL/J14/LDG5
	 eztsp84EKi7ts67Y4QhRQdwZSCFV0Pc7Gl4IzOTTbwAzReHcI+GtuHP0bFKyS+r7aLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oUoXV+gT4AyRj0FeawoLIrlTrOzy+AVYNwqydNKYJ78=;
	b=ECEpQwA9O73xDoiyyZouysZGNSO2j+wuEsIOYRKa0odxETAmsEW/H3s1ceYI9Ll/U4mH
	 Vlkgky88J79OGSvDG+nnNRdORG0lZ+nRThviDfSQmQmRE+aobI3wF81M2wXq7dmoCxdeL
	 QWaqAZZuYXD90l/p85PsVIdJdeRf6IJEfcBynGqHRmaUClBpRYKd7LPcKE95zyJCc/jdE
	 vx+ZWl8S7VVxBL/+BaJ9c0r8QGBA051ZKqaNhGmk10SDpcLpas8sv2dgBCwmqlUVZbwEP
	 NTuRpuEhEd+UMA6mhY2uCwRxHX2NntUz5Yk/tqmRsTMmDtLEoO4sLChUGkZ+lifUjQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyLXZWi1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0415B606A31C;
	Wed, 28 Oct 2026 17:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyLXZWi1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5157E1F01825;
	Wed, 28 Oct 2026 17:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209457;
	bh=oUoXV+gT4AyRj0FeawoLIrlTrOzy+AVYNwqydNKYJ78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyLXZWi1Moh3g6ZLQZ2QyrH+yWXAZP83hHZpxQOdV3egP1JqmB64C4bj3YeIKJYQX
	 sZmOu0SQY63sBDsnEiyAT0poHzzUOSN1w7VfjZVQZv4mdlK0UgZDSEtHhHMD2Uw93I
	 ZJpunqGg1xcI3+cvTk/TUdi3mNw38E+5NqO6dPVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ling Xu <ling_ling.xu@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 479/516] OPP: Fix race between OPP addition and lookup
Date: Wed, 28 Oct 2026 18:00:31 +0100
Message-ID: <20261028170014.828051557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7999baa075b0e..76db501ff5153 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1511,12 +1511,12 @@ int _opp_add(struct device *dev, struct dev_pm_opp *new_opp,
 		}
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



