Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6A93368AB;
	Tue, 21 Jul 2026 17:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655729; cv=none; b=EIItxVClsB4wN+6yQptZCwB2x40sS3lym+0QgiAtzYOY2yPy7mWO1KeBy27laS/TGdwrdydtOfrXWWRc/W/f1kNvtXm8UqdMaz4sIgSxiCoHtdOPXCJPqWMeM9J+vnDM6uLf9aLTp6+wgQr0p2Ee8cVZKv897mN2eEZG1nxpqzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655729; c=relaxed/simple;
	bh=ptUhg+gAzQUQHIdDjp7aIJjQ6IimbIzRVGDCteQXfJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYBVfhGP52vnlMqeiS8QfDrnV6zL0XP4WnxCajqbtcl5W8P1iZdVbrkQYes0a8sCJsKrqbyWmJVWACXt/dunSN8Z6qv7Q81qVQMlpeEUFDIU1O3B+TlKnJy97Zx1F8hWcuE/wM3+2/LhusCiU/TvKwnw1Vb6M9X9FzrqAMrlcMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YD4UBpKR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YD4UBpKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E048D1F000E9;
	Tue, 21 Jul 2026 17:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655728;
	bh=OFiwy6qQ+Z2F296SmFYuHX84vcsoHdnj96/iSOZ/IXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YD4UBpKRSdKNN6/PzXCx6I9NMavSV8Cwy/asFsLcql1hFpMidqLcsWwSdgT/USjgc
	 oCTnczm/zkmnafMfIlQZdAfKceLVGq6oTAWf1TmlIiFnePvT5Kjc64BumsynG7Hpt0
	 NjTc/7E3cxhqKPhsx/Wzu3F/rhyNqQ8M1LUKzzPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ling Xu <ling_ling.xu@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0119/1611] OPP: Fix race between OPP addition and lookup
Date: Tue, 21 Jul 2026 17:03:55 +0200
Message-ID: <20260721152517.533918580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/opp/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 157c84b689feba..a179d57a5a1502 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2084,11 +2084,10 @@ int _opp_add(struct device *dev, struct dev_pm_opp *new_opp,
 			return ret;
 
 		list_add(&new_opp->node, head);
+		new_opp->opp_table = opp_table;
+		kref_init(&new_opp->kref);
 	}
 
-	new_opp->opp_table = opp_table;
-	kref_init(&new_opp->kref);
-
 	opp_debug_create_one(new_opp, opp_table);
 
 	if (!_opp_supported_by_regulators(new_opp, opp_table)) {
-- 
2.53.0



