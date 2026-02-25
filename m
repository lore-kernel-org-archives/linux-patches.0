Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD71279DB3;
	Wed, 25 Feb 2026 01:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983764; cv=none; b=PS7HcrmTeHBh9ZEGjbJY2nxh2YIeM82VP4LHRDEjgYFOPnaqStdH2VOO5Zz87ziZG/E9S0+T4ez+U8eeVsgPLFQwrexQlHgYBTYAK3cW2Rzw3bloG6DZ315Rn20mJdh8rch4or9pW0iNngcLvWyMXe7+60vB2aSTkBCfMwfkcec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983764; c=relaxed/simple;
	bh=RwDoM/6+TqJAee76dgLIGIbY6KEqRrcvFDHTSKlWyyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRXAd268mxvQcw+Ujq/pH/N/nUK7l2o27tgR6Bfr4eF7MKNuC3ltrN2rSMIAgB+qcfctDUOboUHNS7we9J6UvcfCxjgNkSR2BwZh6F6Pukufy33qYAXDpIriqpOsORDx7Oc8hi/l1H8vxXoa/lsUXxN89cvz1kHZ6n2RquMtnnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3tOTqqD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3tOTqqD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C37EC19424;
	Wed, 25 Feb 2026 01:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983764;
	bh=RwDoM/6+TqJAee76dgLIGIbY6KEqRrcvFDHTSKlWyyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3tOTqqD1RkAfd5C9s2HqNnz8ApPFUmT7BMbY3APnZ4yXP5kRkndlAUprRV/2353u
	 eFrpm96RUQ2h765vJsMQOKQP7enzO/bbmp8CqqfLvImYnuN8te2Cn6NKxE3lP47rId
	 zCbrrQZRR5K+fYxYC5D6QjOGiNrugePptrpbvI58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Wu <wusamuel@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/641] PM: wakeup: Handle empty list in wakeup_sources_walk_start()
Date: Tue, 24 Feb 2026 17:16:22 -0800
Message-ID: <20260225012350.399347576@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Samuel Wu <wusamuel@google.com>

[ Upstream commit 75ce02f4bc9a8b8350b6b1b01872467b0cc960cc ]

In the case of an empty wakeup_sources list, wakeup_sources_walk_start()
will return an invalid but non-NULL address. This also affects wrappers
of the aforementioned function, like for_each_wakeup_source().

Update wakeup_sources_walk_start() to return NULL in case of an empty
list.

Fixes: b4941adb24c0 ("PM: wakeup: Add routine to help fetch wakeup source object.")
Signed-off-by: Samuel Wu <wusamuel@google.com>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260124012133.2451708-2-wusamuel@google.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index d1283ff1080bb..2f630df16bfe1 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -276,9 +276,7 @@ EXPORT_SYMBOL_GPL(wakeup_sources_read_unlock);
  */
 struct wakeup_source *wakeup_sources_walk_start(void)
 {
-	struct list_head *ws_head = &wakeup_sources;
-
-	return list_entry_rcu(ws_head->next, struct wakeup_source, entry);
+	return list_first_or_null_rcu(&wakeup_sources, struct wakeup_source, entry);
 }
 EXPORT_SYMBOL_GPL(wakeup_sources_walk_start);
 
-- 
2.51.0



