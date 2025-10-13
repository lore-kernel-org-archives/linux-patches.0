Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7165130AACA;
	Mon, 13 Oct 2025 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369475; cv=none; b=ckzy0/7yQ1dGgwzEC+HmKVR7tSkLSfpCTSfSPmaZzi/THcPNFsHCtAmaHAcdNuR2kutccpyIojO5hrOK3dTwnwd9RuI7YKQqDSf+zOXkJqdHwGGO6ulTTRr0Ym/V+4QwmP7Y4nJ2WsIcHurwch6NHUPPvMn+RDrnHpqxsbE15eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369475; c=relaxed/simple;
	bh=bymQpmfu8kELnJ7eTDO8MA5h5ccQFStrnG3HYWN6+L8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6qWnCFypEl4HhYr01TJwqOlyIikTU5afF5rjXtB6pXAOZT7E5YuZ1gLTiGni0k0bNjtd1+IyFhqzfAyp5/LfICqVu+xdxvNzi/g3zZUv7WwOvHBu4s7/YzedXEOZfv+TKZewhfuqIUY7f5eySvV9OOaX8YuSaUjguS1IPvq0S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tw7qKPLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tw7qKPLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0143CC4CEE7;
	Mon, 13 Oct 2025 15:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369475;
	bh=bymQpmfu8kELnJ7eTDO8MA5h5ccQFStrnG3HYWN6+L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tw7qKPLxwa+9xuSh+ltm9r7FCXhGy5aK1Ph92hWBFl6XWx6m8ILbZpAl5yjiHMjEA
	 8u3vNKmwAC5zIbBIiB7am6EjYyCtoh2a/Lci1D3qbmKsBmxqKf63RDkRXYddHl+p39
	 75IFZeuVZqnUJj26MCAixad13CHk1mhWgjr5LEYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 259/563] media: rj54n1cb0c: Fix memleak in rj54n1_probe()
Date: Mon, 13 Oct 2025 16:42:00 +0200
Message-ID: <20251013144420.660553978@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit fda55673ecdabf25f5ecc61b5ab17239257ac252 ]

rj54n1_probe() won't clean all the allocated resources in fail
path, which may causes the memleaks. Add v4l2_ctrl_handler_free() to
prevent memleak.

Fixes: f187352dcd45 ("media: i2c: Copy rj54n1cb0c soc_camera sensor driver")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rj54n1cb0c.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/rj54n1cb0c.c b/drivers/media/i2c/rj54n1cb0c.c
index b7ca39f63dba8..6dfc912168510 100644
--- a/drivers/media/i2c/rj54n1cb0c.c
+++ b/drivers/media/i2c/rj54n1cb0c.c
@@ -1329,10 +1329,13 @@ static int rj54n1_probe(struct i2c_client *client)
 			V4L2_CID_GAIN, 0, 127, 1, 66);
 	v4l2_ctrl_new_std(&rj54n1->hdl, &rj54n1_ctrl_ops,
 			V4L2_CID_AUTO_WHITE_BALANCE, 0, 1, 1, 1);
-	rj54n1->subdev.ctrl_handler = &rj54n1->hdl;
-	if (rj54n1->hdl.error)
-		return rj54n1->hdl.error;
 
+	if (rj54n1->hdl.error) {
+		ret = rj54n1->hdl.error;
+		goto err_free_ctrl;
+	}
+
+	rj54n1->subdev.ctrl_handler = &rj54n1->hdl;
 	rj54n1->clk_div		= clk_div;
 	rj54n1->rect.left	= RJ54N1_COLUMN_SKIP;
 	rj54n1->rect.top	= RJ54N1_ROW_SKIP;
-- 
2.51.0



