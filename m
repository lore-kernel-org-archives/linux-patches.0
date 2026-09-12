Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142E7390615;
	Sat, 12 Sep 2026 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230694; cv=none; b=JV9durO8hMuwHDyTy4O+vmjQSiaG7mqKdEk6rX5Kkf/B1/2l59i90hxXUe11xGzZuibOxbefyijmSbTKZFJCB/WkH5sqbDS0Z2ivC24HTxdfKA6w5PiSiGU5Kaj+YgJx9uHgJRIRjuj3ke04ZT6yo2bFSqp8deoCu26ismKAnLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230694; c=relaxed/simple;
	bh=7whRv7JLC14yZNenDz2xEi/buSKCV0w7U3v9xIg+chM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PQOW13AZh1JyeT3n7qlkSj8hhsfpqYAHk3cvUzZ9O6TxIWJlOhL6T/ITiiJMCEmghmTlnEqABklar3Hj+PVGhpTFUynuOHLXqaZdKpitKy888yNnCfRh8A6/+rcLjHPioHWhz5H/Y4nmRGcchfFn4lzxTxLbH8t3hbauT04Nzis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK71uAxY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK71uAxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43F11F000FF;
	Sat, 12 Sep 2026 16:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230693;
	bh=P6pngMjFMG/P3Fri5nBZ0Ib+bYXU1UJFM4chgM+SXPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iK71uAxYjv/kgwy5D6K8/h1qjDKPi/3tLaSI+tBoQAlS+IMnKFLsh5Pf4zAYhAArf
	 y3npKXmjtgEGsWXw1hqe8UXVrg7trYwQ1k+1E2XimTupAjM61JZbHHLxm2Pbh9DAAl
	 +INTJ3UoA1D3AucDkKix0+LVAjPTca1u2xHZyguM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0829/1191] wifi: mac80211: skip unused probe response countdown offsets
Date: Sat, 12 Sep 2026 08:59:17 +0200
Message-ID: <20260912065606.885525669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit fd2bf5e718108c00732eb07fd94a5d8830f62a9f ]

mac80211 copies cfg80211's variable-length countdown offset list into a
zero-initialized fixed-size array, leaving unused entries at zero. The
beacon branch already skips those zero entries, but the AP probe-response
branch writes through them unconditionally.

When a probe-response template has no countdown offset, the write through
an unused zero entry overwrites resp->data[0], corrupting the first byte of
the template. cfg80211 already bounds explicitly supplied non-zero offsets
in nl80211_parse_counter_offsets(), so this is a zero-sentinel bug, not an
out-of-bounds write.

Skip zero probe-response offsets, matching the beacon path.

Fixes: af296bdb8da4 ("mac80211: move csa counters from sdata to beacon/presp")
Link: https://lore.kernel.org/all/20260708195911.84365-6-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260723011001.76851-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 52fcb0c5f8fbe..31f000aa22309 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4948,7 +4948,8 @@ static void ieee80211_set_beacon_cntdwn(struct ieee80211_sub_if_data *sdata,
 		if (sdata->vif.type == NL80211_IFTYPE_AP && resp) {
 			u16 *resp_offsets = resp->cntdwn_counter_offsets;
 
-			resp->data[resp_offsets[i]] = count;
+			if (resp_offsets[i])
+				resp->data[resp_offsets[i]] = count;
 		}
 	}
 }
-- 
2.53.0



