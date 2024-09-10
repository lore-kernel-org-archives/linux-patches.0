Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB331891A5;
	Tue, 10 Sep 2024 09:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961060; cv=none; b=hHO8T4uMyTba23DWvt6YIJU658irgKdVP9JBgK57ZTpLGv0FstWfOTjatsJpspdk3OJ8Jyor4HGKycPj+kXLPctci2EESt+PettGjFktknhjddCjE8LS9F09/VCEJwChHtrEATYVnISYwQH1WZoEVBFWHZd/mPhv9S+dP9hVx/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961060; c=relaxed/simple;
	bh=lwx1u+VOvH7TVJX3+uMliJxjcBjftnYNv+ZeCSK8rxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjUaq1U5W0WD8v359AiM1OeEC7EAwa0M9QV8sf2cjD9eJR9fEn3Y4WfQoywOoNbCs5xxNpmGbPcN42cgl6WGvil1T/A0n0RFmwPtH6gcQxi7m/YI/8ejAt8Mtv6+tNBpRFgRk/K1mF+FsJy5D1fetgvilkVCK/wQ0vhRyDnmLGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUeT3gKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUeT3gKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8CBC4CEC3;
	Tue, 10 Sep 2024 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961060;
	bh=lwx1u+VOvH7TVJX3+uMliJxjcBjftnYNv+ZeCSK8rxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUeT3gKAtUuj2LXdGbM5hIEwL2ABNS2MQdh4nlRSr/hELSJbQdDfEtiGZ2usq6Hu4
	 D/Rb9EtRu/df6ceF4FL4DTid/t7dqn1ubpdd8S5NIXWb2lDyjRgGtiK3/wXdmCLeDE
	 Om4qlpiq7GLgM6mXOeMscCWZco2Q2ZXSBWaJXBuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@st.com>,
	Nishka Dasgupta <nishkadg.linux@gmail.com>,
	Felipe Balbi <felipe.balbi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/96] usb: dwc3: st: Add of_node_put() before return in probe function
Date: Tue, 10 Sep 2024 11:31:04 +0200
Message-ID: <20240910092541.498011841@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishka Dasgupta <nishkadg.linux@gmail.com>

[ Upstream commit e36721b90144bb46e1b6477be3ab63439c7fb79b ]

The local variable child in the function st_dwc3_probe takes the return
value of of_get_child_by_name, which gets a node and does not put it. If
the function returns without releasing child, this could cause a memory
error. Hence put child as soon as there is no more use for it. Also
create a new label, err_node_put, just before label undo_softreset; so
that err_node_put puts child. In between initialisation of child and its
first put, modify all statements that go to undo_softreset to now go to
err_node_put instead, from where they can fall through to
undo_softreset.
Issue found with Coccinelle.

Reviewed-by: Patrice Chotard <patrice.chotard@st.com>
Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Stable-dep-of: cd4897bfd14f ("usb: dwc3: st: add missing depopulate in probe error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-st.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-st.c b/drivers/usb/dwc3/dwc3-st.c
index 6127505770cec..770f80f53c356 100644
--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -252,24 +252,25 @@ static int st_dwc3_probe(struct platform_device *pdev)
 	if (!child) {
 		dev_err(&pdev->dev, "failed to find dwc3 core node\n");
 		ret = -ENODEV;
-		goto undo_softreset;
+		goto err_node_put;
 	}
 
 	/* Allocate and initialize the core */
 	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret) {
 		dev_err(dev, "failed to add dwc3 core\n");
-		goto undo_softreset;
+		goto err_node_put;
 	}
 
 	child_pdev = of_find_device_by_node(child);
 	if (!child_pdev) {
 		dev_err(dev, "failed to find dwc3 core device\n");
 		ret = -ENODEV;
-		goto undo_softreset;
+		goto err_node_put;
 	}
 
 	dwc3_data->dr_mode = usb_get_dr_mode(&child_pdev->dev);
+	of_node_put(child);
 
 	/*
 	 * Configure the USB port as device or host according to the static
@@ -289,6 +290,8 @@ static int st_dwc3_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dwc3_data);
 	return 0;
 
+err_node_put:
+	of_node_put(child);
 undo_softreset:
 	reset_control_assert(dwc3_data->rstc_rst);
 undo_powerdown:
-- 
2.43.0



