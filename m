Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9946C4AF;
	Sat, 12 Sep 2026 10:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210141; cv=none; b=NE8fnTYslxCjsdZZixXshSbxRHM+LgoKdSy/cxL7+wEuhqc4WZjLyrBoprfLDk08FpP6vB4hZF0fZWCeGu8TRMKemaZklxzLMp2RjemoTteOYg7is2V51pxe6lda5NKrVoRHIwEZ7gJgAMyV4plDsSL/lBUJjBdWCoudlQMPnRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210141; c=relaxed/simple;
	bh=vpQrneJHVRBxTF8Q/UVjRBYX5Il2dX/mla0OdOqNnwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HILUeqQdfSEBt/t4cTbsoSJ4zoK3yQ9zWDeUDgcuZvoDvCL+u9ImLnT8LnUvgD6+vrJ+S47iL4fpWUa6LWY0CmrefBDo4csKlP+JDil/DArsNvu78qyQPYYnHR8DHWkb4ldjlNzqV9cppYVjJYh/SkMuEJzzxd+zvzMfbirM5dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEn6UTj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEn6UTj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AAB1F000FF;
	Sat, 12 Sep 2026 10:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210138;
	bh=nB9ElR9a1YeScqsZ1CpFRmMSGHL/OlIT5RNIcLwmjEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEn6UTj+jIQl4giZcyLvgFVZoXaSVGf7CTtTxy3zx+1p/h4Cy0EczNkwNFoZ1TKws
	 Nre5SNGU9A8Klzba/r4R47Nzp2vACIlv13lF0IWzokt64Ow7NRJ8QlfQqIj9BMmOJz
	 IqmMOQQuZ4+n/N7UGLQXOd/RqstWlGKkFAsLKN7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0922/1518] cpufreq: imx6q: fix out-of-bounds write when probed more than once
Date: Sat, 12 Sep 2026 08:51:31 +0200
Message-ID: <20260912065644.307220014@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8c3afcf27fa4582c1ab912503dc8a4ebb8dc0f82 ]

imx6_soc_volt is allocated fresh on every probe, sized to the number of
ARM OPPs:

	imx6_soc_volt = devm_kcalloc(cpu_dev, num, sizeof(*imx6_soc_volt),
				     GFP_KERNEL);

but it is filled through soc_opp_count, which has static storage and is
never reset. A second bind after an unbind keeps indexing from where the
first one stopped, and writes past the end of the new array.

Unbinding and rebinding the driver on qemu's mcimx6ul-evk, under KASAN:

  BUG: KASAN: slab-out-of-bounds in imx6q_cpufreq_probe+0x3b0/0xa34
  Write of size 4 at addr c5e90480 by task binder/73
   imx6q_cpufreq_probe from platform_probe+0x88/0xe4
   platform_probe from really_probe+0x108/0x384
   bind_store from kernfs_fop_write_iter+0x1b4/0x28c

The write lands one u32 past the end of the allocation.

soc_opp_count is only read a few lines below the loop that fills it, so it
never needed static storage. Make it a local.

Fixes: b4573d1d657a ("cpufreq: imx6q: correct VDDSOC/PU voltage scaling when cpufreq is changed")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 8110c95059e0e..731f5721ff1ed 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -55,7 +55,6 @@ static unsigned int max_freq;
 static unsigned int transition_latency;
 
 static u32 *imx6_soc_volt;
-static u32 soc_opp_count;
 
 static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
@@ -330,6 +329,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	const struct property *prop;
 	const __be32 *val;
 	u32 nr, i, j;
+	u32 soc_opp_count = 0;
 
 	cpu_dev = get_cpu_device(0);
 	if (!cpu_dev) {
-- 
2.53.0



