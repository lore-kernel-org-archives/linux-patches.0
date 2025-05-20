Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A2C242907;
	Tue, 20 May 2025 14:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749896; cv=none; b=ejyWT+qIJfEgVQ+jjipv3ylf/z59JHgImZn8GlIzwNxpGdLdpXPMLheIcp+gXbBVFlaud5Hzkab6Z8xp+Z3hT448acc55XXa/hX1EzjrKXDr7aJcb87OhXCOelM6INfbAazCRI88UhOoHj+ffBL5EMjLEPO/gpERIQEZkbrWH0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749896; c=relaxed/simple;
	bh=+1+H1/RveEw6QY3+07d1ycOzyWK91PerJsw8LeU45dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P39Ab4bbdK41hxvLLTcsWU791xO7PiKkigSTLpWiTX6hnzmwRxHhP+WXhAmEyRhjkBAi8Sr0nSZRkppuZUD1cOIWe3YYkxYlHCqNrlSodst6NiOrkx4Gy7GSpxcp3AoUQIufWsYooAlLR8mumhU1hbJ2DxGVShxBK7sqS+H/AVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvdOcD3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvdOcD3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464D5C4CEE9;
	Tue, 20 May 2025 14:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749895;
	bh=+1+H1/RveEw6QY3+07d1ycOzyWK91PerJsw8LeU45dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EvdOcD3KkoUKh2i+rEts63BDh3oJ6kioIy60VxRWDuD88D19xex9Gr+4U0N083BGH
	 1hOvIIE2/XEQLISrnXcXxCeTrtmi2zYgwkeiyTpX36ZXllB8KQ9G935b3GPLhMj+Ew
	 /W88o9bon8W8qd7GQUQotw+2n7Ejb0VhMzHwbg8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghuay@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 095/117] dmaengine: idxd: fix memory leak in error handling path of idxd_setup_engines
Date: Tue, 20 May 2025 15:51:00 +0200
Message-ID: <20250520125807.755222606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

commit 817bced19d1dbdd0b473580d026dc0983e30e17b upstream.

Memory allocated for engines is not freed if an error occurs during
idxd_setup_engines(). To fix it, free the allocated memory in the
reverse order of allocation before exiting the function in case of an
error.

Fixes: 75b911309060 ("dmaengine: idxd: fix engine conf_dev lifetime")
Cc: stable@vger.kernel.org
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghuay@nvidia.com>
Link: https://lore.kernel.org/r/20250404120217.48772-3-xueshuai@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -265,6 +265,7 @@ static int idxd_setup_engines(struct idx
 		rc = dev_set_name(conf_dev, "engine%d.%d", idxd->id, engine->id);
 		if (rc < 0) {
 			put_device(conf_dev);
+			kfree(engine);
 			goto err;
 		}
 
@@ -278,7 +279,10 @@ static int idxd_setup_engines(struct idx
 		engine = idxd->engines[i];
 		conf_dev = engine_confdev(engine);
 		put_device(conf_dev);
+		kfree(engine);
 	}
+	kfree(idxd->engines);
+
 	return rc;
 }
 


