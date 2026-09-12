Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B6B38F92F;
	Sat, 12 Sep 2026 19:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243073; cv=none; b=ONexz/+P0bSGNaM+iFpgs6TouuA5ejWpJbC6PPrJsfFMg3zsr1cFkT3+0x7XG8EJAYqhao5KLmhT/XljgNcrmIo+WWef1HGQf6iTq9Km88uS4ZTWNJuA0Pn4x4V++1tH/LU5AGYI0h3380fV+UQ1XbykS5ToUAtZissp7QWvZYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243073; c=relaxed/simple;
	bh=nwfzByyhlGOan3tlFz6x2pLe53oSZ8zecLOOUj7TRJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZPyqjFPiCYD6KzRUQGraj/dB3CF6a/GmhlFCiO+bT2U+vkQk5BO1B1rIH3iaM/nKxzG/ItwaBSStYL0Qw4rHlsAErlQgFWhufZv1QS/vHffoB6tumufYtjM4LWL6rCGHbR2wBSRArU9zjDbVs9nPBlFAraZ7HSSmDgdjQw8Pz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4ZrhoXz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4ZrhoXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04D61F000FF;
	Sat, 12 Sep 2026 19:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243072;
	bh=uF0gm+Y5QTaDa6zve8TYDnqDG5O7RUfZK1QlAR6KreA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4ZrhoXzaxMK3Y2wlpZDrb1rL1paBAIweDb0sfKHxkiUAWtp7Gtx5c2BEblXtqM8g
	 ZQ8v3nXfsDgMkjaYUVba6hqc+bhemrFiTX9U1BOYRYulRPr5MLLBwFRn0I/8lxy1x6
	 s31HFi2FR/4DQqE4YFWa562eIZnNi1qaFqoXuxNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 627/798] cpufreq: imx6q: fix out-of-bounds write when probed more than once
Date: Sat, 12 Sep 2026 09:04:15 +0200
Message-ID: <20260912065531.493972902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 3aa7930f5751d..822f798484b84 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -53,7 +53,6 @@ static unsigned int max_freq;
 static unsigned int transition_latency;
 
 static u32 *imx6_soc_volt;
-static u32 soc_opp_count;
 
 static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
@@ -346,6 +345,7 @@ static int imx6q_cpufreq_probe(struct platform_device *pdev)
 	const struct property *prop;
 	const __be32 *val;
 	u32 nr, i, j;
+	u32 soc_opp_count = 0;
 
 	cpu_dev = get_cpu_device(0);
 	if (!cpu_dev) {
-- 
2.53.0



