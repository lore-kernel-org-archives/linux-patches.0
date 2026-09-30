Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B870509F0E;
	Wed, 30 Sep 2026 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783275; cv=none; b=ITmMmug/VR0Ab/9YWSq752BJkc61gJ83A5mefZUxPw+QGsPLvyJ2qX8FmpQMBwA9ASlp3W0C6uizC0HmqZOcZDMWt/cqjXvhmzrz9PSQacG7PZF/MSC+dH1axG5HphEmEFWYEEljJIno/JXjYesHrRnjd1OyT/f5uxMlr8sfD8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783275; c=relaxed/simple;
	bh=6ACNR0SeioMVlm8PipGj8O+7qPWaOkUw4oJU42BSEY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDiBbgaogelw18Kw81FWCUHoaX1Svx0Itp/VBjfzulprAye00YDw+eF4ItI66jY6knlLEfilREuK7RbTBp2G7oisXDSORjzjHLmFebASrsiOygYXzR+TmT9R/Gfp1p5QfubOhV/dsEBeIIEWuEdhge5MW/WjB/bGaedons6ctWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8mCxlGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8mCxlGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFE51F00893;
	Wed, 30 Sep 2026 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783268;
	bh=ZcwCnTKHhDEzqO49J7LyL4sXsYf+JSCvgVVM44pvCYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8mCxlGKFpifi8jhTeraUpbER964vRHuQhEOBYlSKr5X9PfGVrbiuTfxOKFYjJmlP
	 GGUoAkFpDdGpT5BHgb1LRNd4j8aGOn/yl56Awwf7ZyEoHETCxYYh/hnU82uhKZL3xI
	 kko0145M/QMuxsMvla0DfUNSMlX9vzCe6J1fth8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangguan Wang <guangguan.wang@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Junjie Cao <junjie.cao@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 338/595] net/smc: check smcd_v2_ext_offset when receiving proposal msg
Date: Wed, 30 Sep 2026 17:23:51 +0200
Message-ID: <20260930152354.949478725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangguan Wang <guangguan.wang@linux.alibaba.com>

commit 9ab332deb671d8f7e66d82a2ff2b3f715bc3a4ad upstream.

When receiving proposal msg in server, the field smcd_v2_ext_offset in
proposal msg is from the remote client and can not be fully trusted.
Once the value of smcd_v2_ext_offset exceed the max value, there has
the chance to access wrong address, and crash may happen.

This patch checks the value of smcd_v2_ext_offset before using it.

Fixes: 5c21c4ccafe8 ("net/smc: determine accepted ISM devices")
Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
Reviewed-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: D. Wythe <alibuda@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ jcao: drop the af_smc.c hunk, the !smcd_v2_ext test already there
  covers it; result matches the 5.15.y backport a36364d8d4fab ]
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_clc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_clc.h b/net/smc/smc_clc.h
index a57a3489df4ae..f7f656b297f9c 100644
--- a/net/smc/smc_clc.h
+++ b/net/smc/smc_clc.h
@@ -306,9 +306,15 @@ smc_get_clc_v2_ext(struct smc_clc_msg_proposal *prop)
 static inline struct smc_clc_smcd_v2_extension *
 smc_get_clc_smcd_v2_ext(struct smc_clc_v2_extension *prop_v2ext)
 {
+	u16 max_offset = offsetof(struct smc_clc_msg_proposal_area, pclc_smcd_v2_ext) -
+		offsetof(struct smc_clc_msg_proposal_area, pclc_v2_ext) -
+		offsetof(struct smc_clc_v2_extension, hdr) -
+		offsetofend(struct smc_clnt_opts_area_hdr, smcd_v2_ext_offset);
+
 	if (!prop_v2ext)
 		return NULL;
-	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset))
+	if (!ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) ||
+	    ntohs(prop_v2ext->hdr.smcd_v2_ext_offset) > max_offset)
 		return NULL;
 
 	return (struct smc_clc_smcd_v2_extension *)
-- 
2.53.0



