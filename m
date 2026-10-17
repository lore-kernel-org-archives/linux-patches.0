Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8EA314B8F;
	Sat, 17 Oct 2026 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254533; cv=none; b=ccjQYhgHMnNmF93kYbgXadCXld2y8X5QVQY3UMBxyCZ8tvLd8Vb9O5vZ5BEO3spofLXsHCK8jYmY25TvATIT/Iz290uSNjKYmznTHQi4Vl65ur2qk7Cb7Wr9IjOQ+K9neCLwDvhyPa3r3VM/ytZwu4pwJnIPQoWlRPxfeT63wV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254533; c=relaxed/simple;
	bh=6bvQi/Luj/D3hV5kxJ7n5t05TaC8u6LI3/soaflZSwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0P3EzfwIsNMkHGA7cQpyX1Gaj1kU+tQjQZOUGIlbQb4AAnMSTBT+C9qA1OlPBcvWv4yY0mcl7hiI7iET0+lphwJas0on3dOgHDTmk5pq5dpDV7xnne8EcX6xTfigfiwMM1o1NEBpiPFvhuEZWEU4QyK486YhzViagsbz4XUT0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=alctF1ws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="alctF1ws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242A21F000C4;
	Sat, 17 Oct 2026 16:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254531;
	bh=LxKpRqJ4wb+harEjxexOzV39TPA1J1WWTzbi0YwYh0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alctF1wssfJFe8vqPwvVXHsgbMRjXJpXo5PZNheQObE4Q0wEioTcJFdciqb8mJ4qu
	 CKA16kVzCLfpn0kl4y1tCJdvfgkkDcQKf3lizIYF6VF/W/THYRJRDaBm97ntkmTfAf
	 c6f9n0xYOD0uzG7cYZu4hm8mhLi0Rx5ssYuaXinY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ling Xu <ling_ling.xu@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 479/869] OPP: Fix race between OPP addition and lookup
Date: Sat, 17 Oct 2026 17:55:20 +0200
Message-ID: <20261017160049.403228976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index b5df41ce3afff..46baa5c36c0d4 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -2026,11 +2026,10 @@ int _opp_add(struct device *dev, struct dev_pm_opp *new_opp,
 		return ret;
 	}
 
-	list_add(&new_opp->node, head);
-	mutex_unlock(&opp_table->lock);
-
 	new_opp->opp_table = opp_table;
 	kref_init(&new_opp->kref);
+	list_add(&new_opp->node, head);
+	mutex_unlock(&opp_table->lock);
 
 	opp_debug_create_one(new_opp, opp_table);
 
-- 
2.53.0



