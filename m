Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD3132E159;
	Mon, 27 Oct 2025 18:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591037; cv=none; b=lVoZhh5fXfinT80Dwk2neCb/5CKmlwZaxKr7O5jEcka4IITG0e3o/EzeRn0gqtjQWFBF0icHh8P6s/a8qDYA/xsfo3IMWeSocX3Bh4QZr3eDQXTAptchC/BpFBHlez6io2LTiCjYzDAkNDk9wJgdqHBspgsCu+QtAL5IL3QTkto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591037; c=relaxed/simple;
	bh=8aTXnQh659jOiRYBGs+ZPJA55Kmfyw46HJy3c6BWfcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtUVkb1DvF8Sqd+76XXsdvApppD5SdKPiaqT0NmaD/rdtcTDOhivhOsTBoi2sajYLVPPfETpqzsf9cToj7sE+p79dEDcbGObgWmh/gY/NPYouW5eeYr/qOumk91YdaqlpO0H7sbNsQNacjHbZjP5gWUR1prxpmaYajoIrNRUoJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAdkFt/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAdkFt/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260C1C4CEF1;
	Mon, 27 Oct 2025 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591037;
	bh=8aTXnQh659jOiRYBGs+ZPJA55Kmfyw46HJy3c6BWfcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAdkFt/4r19sU1csUFvE95mMl9uJ5cTJLtFzwUrFbNslp4mTXqDsAgPjuYrEVx5+9
	 0mG9FJ8C291nSMqmmh2SbKt12Objn2304gaPKjhL7CVmSaJ0x5z1ssEhnzaySU2woc
	 UBtCWgXgzsT9afM/y3JS75VVUJJS8rTMu2J9FRxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/332] media: rj54n1cb0c: Fix memleak in rj54n1_probe()
Date: Mon, 27 Oct 2025 19:31:37 +0100
Message-ID: <20251027183525.784963368@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
index 4cc51e0018744..b35b3e4286861 100644
--- a/drivers/media/i2c/rj54n1cb0c.c
+++ b/drivers/media/i2c/rj54n1cb0c.c
@@ -1332,10 +1332,13 @@ static int rj54n1_probe(struct i2c_client *client,
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



