Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48511D07B7;
	Wed,  2 Oct 2024 13:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876501; cv=none; b=jJzz8CYyqG3boWoyteWgnr0+sCfIt4kojq05PjbbPemwqiRMcHyHKJOCrnt7hd7hXKnQ2fvDnKB6Z10TlqkuIGOiOF63PSnDmUOq29cT/ndNmEgsZinDzSj/6KCRMtWvqHWDi+z3r2ocjJ5dKG2nOStthi1p6Q3lIcT1B7JIUbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876501; c=relaxed/simple;
	bh=XLqQb+VDihZjcR5EPkndDn7kRvn8hxzREgAAUq+XrQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um8Csg4P/p92/9V9D9h2qf+la4XHuac07RTIQw5+pEngUeh7dH69fEzc28SASTqxtHGy6A+0vUhFZ5waYI/ir8j5lJ8C+sJtarqUano6wmjDoZZFT/ABjToiyG1iBH5DjDe8EK6ewZZkosqd4spkPXIjCepmmvxlZzFkjRjrS48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIYFHxQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIYFHxQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB50C4CEC5;
	Wed,  2 Oct 2024 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876500;
	bh=XLqQb+VDihZjcR5EPkndDn7kRvn8hxzREgAAUq+XrQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uIYFHxQCOM1ivMIC+KT3LbUrb8zb2F83o5cqDhVB/lKuzd12nTiREZ77sj0fWeb4B
	 z9/HUdoZCXVMjfFu6wmp1wgtZ6zj7JpWcXipiV+pftZ2Se68DC6sNVPWZRlDoWb71H
	 85O6KVCrn8rARGH8Xwb7Y53Gw7fpI1XWNjrce+zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 466/695] interconnect: icc-clk: Add missed num_nodes initialization
Date: Wed,  2 Oct 2024 14:57:44 +0200
Message-ID: <20241002125841.058601645@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit c801ed86840ec38b2a9bcafeee3d7c9e14c743f3 ]

With the new __counted_by annotation, the "num_nodes" struct member must
be set before accessing the "nodes" array. This initialization was done
in other places where a new struct icc_onecell_data is allocated, but this
case in icc_clk_register() was missed. Set "num_nodes" after allocation.

Fixes: dd4904f3b924 ("interconnect: qcom: Annotate struct icc_onecell_data with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240716214819.work.328-kees@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/icc-clk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/interconnect/icc-clk.c b/drivers/interconnect/icc-clk.c
index f788db15cd76a..b956e4050f381 100644
--- a/drivers/interconnect/icc-clk.c
+++ b/drivers/interconnect/icc-clk.c
@@ -87,6 +87,7 @@ struct icc_provider *icc_clk_register(struct device *dev,
 	onecell = devm_kzalloc(dev, struct_size(onecell, nodes, 2 * num_clocks), GFP_KERNEL);
 	if (!onecell)
 		return ERR_PTR(-ENOMEM);
+	onecell->num_nodes = 2 * num_clocks;
 
 	qp = devm_kzalloc(dev, struct_size(qp, clocks, num_clocks), GFP_KERNEL);
 	if (!qp)
@@ -133,8 +134,6 @@ struct icc_provider *icc_clk_register(struct device *dev,
 		onecell->nodes[j++] = node;
 	}
 
-	onecell->num_nodes = j;
-
 	ret = icc_provider_register(provider);
 	if (ret)
 		goto err;
-- 
2.43.0



