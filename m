Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F94418368;
	Wed, 23 Sep 2026 14:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173311; cv=none; b=WajHsqJht/uX55GqwqdDJTl1+yFBg28+vc6bKHHwWxNJzq92T7JetZiP5+BZldegOBcmcBe+JdmpT2ky+hp2V0ZFOVtg+PqGmp5MLJubz8hSDUJjqM3paAyey3H+rEzNmEEVEpGEgID83tA6yMmffhj4cPy59ADQpQDtTG57XB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173311; c=relaxed/simple;
	bh=Zhli2zYmF8vy3HSBkpkkCNb4ui2aOBjA2NUUng7UNFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxlISeGInvttfaMFqyftx1Cbt/jpziypWt5F/jGpzAUoena6W+KsUom/19Joo/B6kFLgyvRD55Ab1IWfxUaD3By4MdpT7eauZe6zLH4nWODnUB5336JwqDWd+fOKAdtR6dLoIY0k6iZcFxaT/i0OZqchxLhbvGxKoDdYCCbdH6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DarIpeZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DarIpeZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BBB1F000FF;
	Wed, 23 Sep 2026 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173310;
	bh=ziwI8IIH59foDiiMQe2Taq7hlho+7An4Bk07t9UGaVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DarIpeZ4CXjS70F4zU6N+cuerpDedZkyhCLrF0eX0PpqGJ4fAco/o9xN3/RuQNv1h
	 oPMfC1hZdbXw/QJtmlSd6qJjcvacPk6/TJ9e6B8gKf3tm1+SMLHmabP9/my+siH6p8
	 8O56k9qfQO3M2qhM88hRAJbLRPdFoKH75AT782vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 206/438] net: do not advance stack index from dev_fwd_path()
Date: Wed, 23 Sep 2026 16:03:47 +0200
Message-ID: <20260923140650.102933020@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 5deda60c56eeeab25beb10cf4d48e07587076b11 ]

Update stack index from dev_fill_forward_path() instead, once the
forward path slot has been populated.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 150dba2c69e9 ("net: remove WARN_ON_ONCE() from the dev_fill_forward_path() loop check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 74dd9e25f4ff7..e68463e7310a0 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -742,12 +742,10 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
 static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
-	int k = stack->num_paths++;
-
-	if (k >= NET_DEVICE_PATH_STACK_MAX)
+	if (stack->num_paths + 1 > NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
-	return &stack->path[k];
+	return &stack->path[stack->num_paths];
 }
 
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
@@ -773,6 +771,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		if (ret < 0)
 			return -1;
 
+		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
 			return -1;
 	}
@@ -785,6 +784,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		return -1;
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
+	stack->num_paths++;
 
 	return ret;
 }
-- 
2.53.0



