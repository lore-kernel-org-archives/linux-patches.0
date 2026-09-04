Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475A718D636;
	Fri,  4 Sep 2026 05:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501244; cv=none; b=hCv8xx4hfc/h5ZsU8E0nTDcIkJ7lTqcjZx2FiWXceDbIS/k2IuaYAaou9LjI3ZEmi04d8JawBlERy/R44J7UiV0i66PfJbCOPadfJlLmZPvecUn/qD3uCKylG0zRw4Gc6a1qI0hHC0uarUgysW6SrkE8vSv4NvWxqHXW1TkvW+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501244; c=relaxed/simple;
	bh=bO2rkdn5d75dQWtCP1dttPVQm5uwzS8SFq2GLo+DK9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKKHT879lyZepwJvF0RzLEgPlsXiByfKDoSmbTwWAeqBMrTeceXRk/bT/0j6KVvaXTiMgAha6iNrVGHKjeG4WIPBAjuTTmCsepH+bbRXbJ9yARLbXzxaIaLAJqfL1iyKb9kKs/VVWonhmW2W3XVkfcuQXhdEfn7YgiKJUR9zpRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O5Ugey9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O5Ugey9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5701F00A3D;
	Fri,  4 Sep 2026 05:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501243;
	bh=HjKifP0RzP1Q/dF+kZmrQ4tRlZZZZlM48UpGJWhO2eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O5Ugey9Nsj7diwaIJQs7scKiY5E9ifXug9gebFlQEfBF47r/nOuzc066bV/La0JzQ
	 FCe9LhEMTJZFcN28YcHsmWO7XIui2cjIcqwpXj8JqE4W1cSHMF4rzg2Fb3AhPBdiF+
	 k+jGOtZso6AC0BIGIwOXhZ7FZxeCFFcvGZZY8/i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 304/552] staging: media: tegra-video: vi: fix probe failure on skipped last port
Date: Fri,  4 Sep 2026 06:57:41 +0200
Message-ID: <20260904045757.120780984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -1260,6 +1260,7 @@ static int tegra_vi_channels_alloc(struc
 	struct device_node *parent;
 	struct v4l2_fwnode_endpoint v4l2_ep = { .bus_type = 0 };
 	unsigned int lanes;
+	int err;
 	int ret = 0;
 
 	ports = of_get_child_by_name(node, "ports");
@@ -1270,8 +1271,8 @@ static int tegra_vi_channels_alloc(struc
 		if (!of_node_name_eq(port, "port"))
 			continue;
 
-		ret = of_property_read_u32(port, "reg", &port_num);
-		if (ret < 0)
+		err = of_property_read_u32(port, "reg", &port_num);
+		if (err < 0)
 			continue;
 
 		if (port_num > vi->soc->vi_max_channels) {
@@ -1292,10 +1293,10 @@ static int tegra_vi_channels_alloc(struc
 
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


