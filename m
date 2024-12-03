Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657971EE00B;
	Tue,  3 Dec 2024 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242638; cv=none; b=ebPeCcPXoocSN9PjzQtiw4Kppl5zhxZFd3rzFr/K8/bqrc5uVCJyc3UvJnPsOYfGDCl+ELKfF9dVmZiXaworn5WOlHn/Hxut4J/NQNBEq4cdN7XHzbmjfpkpc4autKBdM38cLcjSGTjJ6bgi5W2DzW0ILfp7OZE1828E3S/2usE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242638; c=relaxed/simple;
	bh=4JHZdHN0l0nOC835NxMLSqdv5/24nPhsqkJ+m5vmbCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iaiSEdS3I+zxHMp+qSYogwXj1hpcyo7DZUs+8enqrRcZXzQpErDJ12//IvMjMeZR83dQ42UZM/KhnRYzlBslBt1I3vyqTpJPuaX9SbvjKDcPnqd1m851cPjDPCXYfxoJh82il2VYG7rAd7PlgM9b3HWXn3eK/9mqOT7k8MnlSJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LU/wlXHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LU/wlXHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F82C4CECF;
	Tue,  3 Dec 2024 16:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242638;
	bh=4JHZdHN0l0nOC835NxMLSqdv5/24nPhsqkJ+m5vmbCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LU/wlXHLCNUy5I/DGSZKY+H8Hc1V3fVt8hMeYEO7nMC7pK79qg2dXvt6i6L5pPAkr
	 9ZA9ojZgFu5kdAbOAfKq3z5iPmi/sr32i4wHJ/6bUdMjedGFGEMNT2omIG3N4+Uis3
	 aOZpoJzMMkZen51cHChKZTeEdvu2WlrF/eY2oRp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 764/826] counter: stm32-timer-cnt: fix device_node handling in probe_encoder()
Date: Tue,  3 Dec 2024 15:48:11 +0100
Message-ID: <20241203144813.567199023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 147359e23e5c9652ff8c5a98a51a7323bd51c94a upstream.

Device nodes accessed via of_get_compatible_child() require
of_node_put() to be called when the node is no longer required to avoid
leaving a reference to the node behind, leaking the resource.

In this case, the usage of 'tnode' is straightforward and there are no
error paths, allowing for a single of_node_put() when 'tnode' is no
longer required.

Cc: stable@vger.kernel.org
Fixes: 29646ee33cc3 ("counter: stm32-timer-cnt: add checks on quadrature encoder capability")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241027-stm32-timer-cnt-of_node_put-v1-1-ebd903cdf7ac@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/stm32-timer-cnt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/counter/stm32-timer-cnt.c
+++ b/drivers/counter/stm32-timer-cnt.c
@@ -700,6 +700,7 @@ static int stm32_timer_cnt_probe_encoder
 	}
 
 	ret = of_property_read_u32(tnode, "reg", &idx);
+	of_node_put(tnode);
 	if (ret) {
 		dev_err(dev, "Can't get index (%d)\n", ret);
 		return ret;


