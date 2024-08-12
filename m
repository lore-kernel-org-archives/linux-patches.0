Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B789134AC;
	Mon, 12 Aug 2024 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480137; cv=none; b=H/97fNVfkKdHYNwdvUscIFJwxojoQWDxll7nQSvqjc0IEuICAlT4iMAK3Dho/59d+lPDL0a/576w1sVK4PWlSsc0ivllIMuBYKIGd/QdYBvfU4X+kD/u9xwpvLOAWmmP40+7PdgbJiZEuEz8LjLoodsvYXzSeBGykKxj6spjBq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480137; c=relaxed/simple;
	bh=7BmlZ0LQFaP72NymsjSePME+sp4hjBxcQjEK2EdfWoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA0LYJCTQXnKY5neJGrnir15+PGjK3aC9K11wYUq7wkK8AwhbglpGLbKlnVCEb479UZDo33zJkpnzR3D97nIJ5MOpsYvqOeJUuor5GE21ykOLXf4W5vB9+IP8vb8RXWnxbVg+cQqKNhV6JJo0ADuLCdUSYstIhywGRxMOozpjbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhqoAqL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhqoAqL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C2AC32782;
	Mon, 12 Aug 2024 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480136;
	bh=7BmlZ0LQFaP72NymsjSePME+sp4hjBxcQjEK2EdfWoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhqoAqL1FhPuFAyECeCJyxm+imMxdVp3TwmsLLMiSlU58MWH+qYJDJwGfXPU34Za8
	 bnQFAIebW00dKyfdqjLyRWhauFJ0pvdwV5oU9YBBTCegnr/R0wz5fb0L4JLW6jcoRu
	 eEIa74X1lwI6LxBjlL3kRUm0BFnrsDO44hALJU9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 107/263] media: i2c: ov5647: replacing of_node_put with __free(device_node)
Date: Mon, 12 Aug 2024 18:01:48 +0200
Message-ID: <20240812160150.641474250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>

[ Upstream commit 971b4eef86ccb8b107ad2875993e510eec4fdeae ]

Replace instance of of_node_put with __free(device_node)
to protect against any memory leaks due to future changes
in control flow.

Signed-off-by: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
Acked-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5647.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/ov5647.c b/drivers/media/i2c/ov5647.c
index 7e1ecdf2485f7..0fb4d7bff9d14 100644
--- a/drivers/media/i2c/ov5647.c
+++ b/drivers/media/i2c/ov5647.c
@@ -1360,24 +1360,21 @@ static int ov5647_parse_dt(struct ov5647 *sensor, struct device_node *np)
 	struct v4l2_fwnode_endpoint bus_cfg = {
 		.bus_type = V4L2_MBUS_CSI2_DPHY,
 	};
-	struct device_node *ep;
+	struct device_node *ep __free(device_node) =
+		of_graph_get_endpoint_by_regs(np, 0, -1);
 	int ret;
 
-	ep = of_graph_get_endpoint_by_regs(np, 0, -1);
 	if (!ep)
 		return -EINVAL;
 
 	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
 	if (ret)
-		goto out;
+		return ret;
 
 	sensor->clock_ncont = bus_cfg.bus.mipi_csi2.flags &
 			      V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK;
 
-out:
-	of_node_put(ep);
-
-	return ret;
+	return 0;
 }
 
 static int ov5647_probe(struct i2c_client *client)
-- 
2.43.0



