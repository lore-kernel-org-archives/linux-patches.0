Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5885151FCA6;
	Wed, 30 Sep 2026 17:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790913; cv=none; b=mHPzgMYtZARQWYDy9XTu6C+h7TGQJDcZWZ2K8s9lIGyjq+KAGbR5EDaOEkhWqIuuEx8qsAWCWhzj+3uThNDwdD8iatUfgm9nNJCRLhKKRWVa1BzzSRdBnGEmRlM33oIF8oN+QINMBfG9Km98sTSFbCFY8RpdpcGQO+vfhIBk2/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790913; c=relaxed/simple;
	bh=DkqG719VXcIOXFZtMLvYgpqyW6OC36nNBBDSPrsCE+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODuYujk3/n5QlIhRq74PRiXXaV39F26yPmQR6enFAO2kqxsUJdOpJcDSTHH2QaOsHr0UtEkE30duv864Q7gsmHwrUo0wNAOicO+R2s8SNm1xhvoj22ekpJzsBDYAo14QhQdkSlNDGT9knsITdksNt5EqGcZGZL1BXP3YjZe6Q7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GG12C7zS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GG12C7zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BCE1F000FF;
	Wed, 30 Sep 2026 17:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790912;
	bh=rjjyeVBsNphZHQQQzGIVF27lO0zK+o1kD0b+turzfus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GG12C7zSdkQmJE2bblF4YIICuO9AL66iDlQepwGnccXG8Q75w2ZDDfVpcN4Fg3O3p
	 rnCXCjm3OXxYNwqAeYXzgyqdT4A7FgqSavVeXLouB/+RaHI2S/9XpBFk5x1kweopFm
	 uk/zx2LJN/tMahZacFr1bJw5la+z8VUH2oyykGns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	Randolph Sapp <rs@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Antonios Christidis <a-christidis@ti.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/752] clk: keystone: dont cache clock rate
Date: Wed, 30 Sep 2026 17:19:46 +0200
Message-ID: <20260930152400.687380976@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit a80b32a140c8612bbaed27009c383d43304db6d5 ]

The TISCI firmware will return 0 if the clock or consumer is not
enabled although there is a stored value in the firmware. IOW a call to
set rate will work but at get rate will always return 0 if the clock is
disabled.
The clk framework will try to cache the clock rate when it's requested
by a consumer. If the clock or consumer is not enabled at that point,
the cached value is 0, which is wrong. Thus, disable the cache
altogether.

Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Reviewed-by: Randolph Sapp <rs@ti.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Antonios Christidis <a-christidis@ti.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://patch.msgid.link/20260507-clk-sci-v2-1-38f59b48777a@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/keystone/sci-clk.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/clk/keystone/sci-clk.c b/drivers/clk/keystone/sci-clk.c
index 8af2a9faa805a..422482f60bbb8 100644
--- a/drivers/clk/keystone/sci-clk.c
+++ b/drivers/clk/keystone/sci-clk.c
@@ -342,6 +342,14 @@ static int _sci_clk_build(struct sci_clk_provider *provider,
 
 	init.ops = &sci_clk_ops;
 	init.num_parents = sci_clk->num_parents;
+
+	/*
+	 * A clock rate query to the SCI firmware will return 0 if either the
+	 * clock itself is disabled or the attached device/consumer is disabled.
+	 * This makes it inherently unsuitable for the caching of the clk
+	 * framework.
+	 */
+	init.flags = CLK_GET_RATE_NOCACHE;
 	sci_clk->hw.init = &init;
 
 	ret = devm_clk_hw_register(provider->dev, &sci_clk->hw);
-- 
2.53.0



