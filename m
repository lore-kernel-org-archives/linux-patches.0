Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB8F25392D;
	Mon, 23 Jun 2025 13:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685496; cv=none; b=LU1z7EP79NVoOOpwyKDcwP8yPfZwMHeRmO6Of0Hx0h6klMylwjJXhT6jAjXkJOS4M1nPhcnO35tS8F2B/kdMhjX4XbTPWD/ZPL3y8obvIpvsvJPqc8EKQz/riPzfwWfNKjFqekXC7hKHvY0yxSSuP0UZWhI+++tSivtSH81hF6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685496; c=relaxed/simple;
	bh=PdZgKg1EP1GbNGHvfScLwX1EGBdPqaCwcTap9DFIwzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iN2TU7CgEbCQg1P3tR1n60Jdep9Jtg/fSpFWZgSCijFLMDu+dcRpfvDG8egyx5NPinlndWm1ailKrJKYkMJvsrIZ6wh+JPvCe6avkU0FT4/3jp5b36hqESytu1d/hZ4BR0vGdDQyITgdv+aSvAGTs7pFSkVsjgfuCIK+JN6I0tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+GZc8HV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+GZc8HV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C26C4CEF1;
	Mon, 23 Jun 2025 13:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685495;
	bh=PdZgKg1EP1GbNGHvfScLwX1EGBdPqaCwcTap9DFIwzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+GZc8HVTtwPy9FSeQtHWjhdhxRGGWVk9bBI6sCQ6bAUqQM9CqXvMTDxr5u7F10H0
	 5Or9v276p6Rs3RZjVGJ4hGd3lI2Y05/b5wGIzFHfrb3Mdp4Br4JQHpKYD5YtJ2twNg
	 GKyy4dn3kxe/Qq33l9A3g9W70N1sYAU/CIxyPu68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 239/592] drm/dp: add option to disable zero sized address only transactions.
Date: Mon, 23 Jun 2025 15:03:17 +0200
Message-ID: <20250623130705.973961329@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

[ Upstream commit f0ddbb1eed1898286d2bd99fd6ab64ca9700d267 ]

Some older NVIDIA and some newer NVIDIA hardware/firmware seems to
have issues with address only transactions (firmware rejects them).

Add an option to the core drm dp to avoid address only transactions,
This just puts the MOT flag removal on the last message of the transfer
and avoids the start of transfer transaction.

This with the flag set in nouveau, allows eDP probing on GB203 device.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Reviewed-by: Timur Tabi <ttabi@nvidia.com>
Tested-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 39 +++++++++++++++----------
 include/drm/display/drm_dp_helper.h     |  5 ++++
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index dbce1c3f49691..753d7c3942a14 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2081,14 +2081,17 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 
 	for (i = 0; i < num; i++) {
 		msg.address = msgs[i].addr;
-		drm_dp_i2c_msg_set_request(&msg, &msgs[i]);
-		/* Send a bare address packet to start the transaction.
-		 * Zero sized messages specify an address only (bare
-		 * address) transaction.
-		 */
-		msg.buffer = NULL;
-		msg.size = 0;
-		err = drm_dp_i2c_do_msg(aux, &msg);
+
+		if (!aux->no_zero_sized) {
+			drm_dp_i2c_msg_set_request(&msg, &msgs[i]);
+			/* Send a bare address packet to start the transaction.
+			 * Zero sized messages specify an address only (bare
+			 * address) transaction.
+			 */
+			msg.buffer = NULL;
+			msg.size = 0;
+			err = drm_dp_i2c_do_msg(aux, &msg);
+		}
 
 		/*
 		 * Reset msg.request in case in case it got
@@ -2107,6 +2110,8 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 			msg.buffer = msgs[i].buf + j;
 			msg.size = min(transfer_size, msgs[i].len - j);
 
+			if (j + msg.size == msgs[i].len && aux->no_zero_sized)
+				msg.request &= ~DP_AUX_I2C_MOT;
 			err = drm_dp_i2c_drain_msg(aux, &msg);
 
 			/*
@@ -2124,15 +2129,17 @@ static int drm_dp_i2c_xfer(struct i2c_adapter *adapter, struct i2c_msg *msgs,
 	}
 	if (err >= 0)
 		err = num;
-	/* Send a bare address packet to close out the transaction.
-	 * Zero sized messages specify an address only (bare
-	 * address) transaction.
-	 */
-	msg.request &= ~DP_AUX_I2C_MOT;
-	msg.buffer = NULL;
-	msg.size = 0;
-	(void)drm_dp_i2c_do_msg(aux, &msg);
 
+	if (!aux->no_zero_sized) {
+		/* Send a bare address packet to close out the transaction.
+		 * Zero sized messages specify an address only (bare
+		 * address) transaction.
+		 */
+		msg.request &= ~DP_AUX_I2C_MOT;
+		msg.buffer = NULL;
+		msg.size = 0;
+		(void)drm_dp_i2c_do_msg(aux, &msg);
+	}
 	return err;
 }
 
diff --git a/include/drm/display/drm_dp_helper.h b/include/drm/display/drm_dp_helper.h
index 5ae4241959f24..736dbfdd6321d 100644
--- a/include/drm/display/drm_dp_helper.h
+++ b/include/drm/display/drm_dp_helper.h
@@ -518,6 +518,11 @@ struct drm_dp_aux {
 	 * @powered_down: If true then the remote endpoint is powered down.
 	 */
 	bool powered_down;
+
+	/**
+	 * @no_zero_sized: If the hw can't use zero sized transfers (NVIDIA)
+	 */
+	bool no_zero_sized;
 };
 
 int drm_dp_dpcd_probe(struct drm_dp_aux *aux, unsigned int offset);
-- 
2.39.5



