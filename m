Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A980127B358;
	Mon, 18 Aug 2025 13:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523021; cv=none; b=s+3+HZOhm+wlTj3r1E07BGYol0pSgq88LAQuSlXgG/S0THsVywvT2hTgYaNB+2rgj0cXvWFtJMKiFA8vv8FejZNQ8+Jn/iw9HbNk/BI8eJ0RyIs/coch7w35wU38a9LxIR6BdBDHhiTKGM3WN2F8xdY64dxswnm0EbS4D4KaSbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523021; c=relaxed/simple;
	bh=YnauoailNUtnY1l1dwDnkiYU+j1xy4p1Z/cfsO8uUD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGefKzXmO2lL5rmjv7IQhnXgQFRFZMDSjUtLYMPR2sczY6O054WayrNd+0dJxmOmMcQPm/7PjxRn7ak13XMWm1mlTz07ISPx1d6Xmnstcdpm9gvAZvZEfAmbL3IoZJuPkh4gLKXYnvJB9a6xjj8SLGr5qQ0lVWKSUKOqIumbBYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFb4JqYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFb4JqYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 279C7C4CEEB;
	Mon, 18 Aug 2025 13:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523021;
	bh=YnauoailNUtnY1l1dwDnkiYU+j1xy4p1Z/cfsO8uUD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFb4JqYeahBTKNytp4Ze9JiNKpC+a4NTv3wAkdy2x94DIP8EDAWgL9UHzSspmJjOM
	 yiwFUzLe1Dym1E08Ws1WbKZThCfHreRez96JrUlYBUhWbs67Dfjig5C5t+zN0x6F9U
	 evNEmUcUj6rgvzmgIX1uBF/w11dp1qxjgyGOXNQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongcheng Yan <dongcheng.yan@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 013/515] media: i2c: set lt6911uxes reset_gpio to GPIOD_OUT_LOW
Date: Mon, 18 Aug 2025 14:39:59 +0200
Message-ID: <20250818124458.831785578@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Dongcheng Yan <dongcheng.yan@intel.com>

commit 3c607baf68639d6bfe1a336523c4c9597f4b512a upstream.

reset_gpio needs to be an output and set to GPIOD_OUT_LOW, to ensure
lt6911uxe is in reset state during probe.

This issue was found on the onboard lt6911uxe, where the reset_pin was
not reset, causing the lt6911uxe to fail to probe.

Fixes: e49563c3be09d4 ("media: i2c: add lt6911uxe hdmi bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Dongcheng Yan <dongcheng.yan@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/lt6911uxe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/lt6911uxe.c
+++ b/drivers/media/i2c/lt6911uxe.c
@@ -600,7 +600,7 @@ static int lt6911uxe_probe(struct i2c_cl
 
 	v4l2_i2c_subdev_init(&lt6911uxe->sd, client, &lt6911uxe_subdev_ops);
 
-	lt6911uxe->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_IN);
+	lt6911uxe->reset_gpio = devm_gpiod_get(dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(lt6911uxe->reset_gpio))
 		return dev_err_probe(dev, PTR_ERR(lt6911uxe->reset_gpio),
 				     "failed to get reset gpio\n");


