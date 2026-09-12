Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A3C38AC9A;
	Sat, 12 Sep 2026 13:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220593; cv=none; b=u974js0bY5YTsjbLbjeXQ/4igNFURDqQlZHwy/xMRJcZGnYSgNH5X6ry6j71XtTGOWALlx+TRa5RqpmEsFfJoMJpwQKK4LChUem/EAz3ZP5HRsTyxkLfnZNwaiWo4QmfQa19tsCCZHmGWEZ31uKP+FnA1gwToHWcFXVEn9g48Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220593; c=relaxed/simple;
	bh=jDxWwAoTi/aOAEH6lu+hEei41XNU9q8MqwwLsoBYC0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSNvDxpzBotGGv0OYetLuqK982PTH1HVnX6Guv+o5nlKw6Lp+NOg/++bkRyX/2wEsdPo2JgDQU2OgLYfcM8sJgC87plhMnY5Gl2Y0eyxCKbNDgtifMKNhl9v6QmvLHYCYv0xjVmWz2xnVOY/XkoDK8VQpjnFugJLj6MA13Avl9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PlmwGbc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PlmwGbc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320951F000FF;
	Sat, 12 Sep 2026 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220592;
	bh=qFShwJJaSIdJIvm9xBD8S7tJzubTwwpY2khEmzHxS9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PlmwGbc2IQM+ZZvHNm4yfkz+V+m6E+JtjhAUEKcGXbAmFhtNCs8W8sNceHR3868Sn
	 ojsHNPB/iikM2sj4k7EeisFRS3q0yr2wnte/Jj+vQ41cycHwnp+9yYciAJJMLL1AOr
	 oZ65QhBIZTaG5866mMTEavmNnNj8xAkLSFxdBdmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0166/1424] staging: media: tegra-video: vi: fix probe failure on skipped last port
Date: Sat, 12 Sep 2026 08:43:18 +0200
Message-ID: <20260912065611.010337845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit ae15adeed9f7ec54989175fe3c9e0815186821bc upstream.

tegra_vi_channels_alloc() iterates over port nodes and skips those
whose reg property cannot be read or whose remote endpoint fails
v4l2_fwnode_endpoint_parse(), leaving the negative result of the
failed call in ret. If that happens on the last port node, the loop
ends with ret still negative and tegra_vi_init() fails the whole VI
probe.

The same defective port earlier in the ports node is skipped silently,
so probing succeeds or fails depending on the order of the port nodes.
The CSI equivalent, tegra_csi_channels_alloc(), returns 0
unconditionally after its loop and does not have this problem.

Use a separate variable for the per-port checks so that only fatal
errors end up in ret.

Fixes: 1ebaeb09830f ("media: tegra-video: Add support for external sensor capture")
Fixes: 2ac4035a78c9 ("media: tegra-video: Add support for x8 captures with gang ports")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/tegra-video/vi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -1262,6 +1262,7 @@ static int tegra_vi_channels_alloc(struc
 	struct device_node *parent;
 	struct v4l2_fwnode_endpoint v4l2_ep = { .bus_type = 0 };
 	unsigned int lanes;
+	int err;
 	int ret = 0;
 
 	ports = of_get_child_by_name(node, "ports");
@@ -1272,8 +1273,8 @@ static int tegra_vi_channels_alloc(struc
 		if (!of_node_name_eq(port, "port"))
 			continue;
 
-		ret = of_property_read_u32(port, "reg", &port_num);
-		if (ret < 0)
+		err = of_property_read_u32(port, "reg", &port_num);
+		if (err < 0)
 			continue;
 
 		if (port_num > vi->soc->vi_max_channels) {
@@ -1294,10 +1295,10 @@ static int tegra_vi_channels_alloc(struc
 
 		ep = of_graph_get_endpoint_by_regs(parent, 0, 0);
 		of_node_put(parent);
-		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep),
+		err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep),
 						 &v4l2_ep);
 		of_node_put(ep);
-		if (ret)
+		if (err)
 			continue;
 
 		lanes = v4l2_ep.bus.mipi_csi2.num_data_lanes;


