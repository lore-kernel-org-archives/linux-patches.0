Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A91F76B4;
	Tue,  3 Dec 2024 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239852; cv=none; b=vB/Sqf2mYHu7hj8kEPfo76tWTqNWIRFu0+84YLglfuk8ULQKaJSkhL/9xui3Dhl0bj+0ZyOPJ8yGDzWbSzb2lav9Uvw3JRMVhho690Rq5SwZYq+l5Z0qmL7/vf5wfuIOHnIx7fXjui0Lna6OC+KxRQcxFJ1h72cF/Ru0mwdhSj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239852; c=relaxed/simple;
	bh=fF6mVmuLdBrr2JSzymty37Yv9TqGdPTQ7khiv3IrKqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snc15FNzt7vUPy/RozNxH3TUNsYGJp+LQxvMyp9o2bJt1VQLESDem5t2/Nc+hsTZhj3r18IbIrbZPlWwpe+mnKzOKPGaaRfG6eDHZuquAF0Wg0AS4LxBeuGXX4Z8tpR0ViwRFNrzJNYegVNwuDqLgHNALFlTqBeuSvhJszCtP9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSIAIPSs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSIAIPSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404CEC4CED8;
	Tue,  3 Dec 2024 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239852;
	bh=fF6mVmuLdBrr2JSzymty37Yv9TqGdPTQ7khiv3IrKqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSIAIPSsyY+RanXKwTjysiCxZ11/lf/I13MoqnikMSc03MeHrXD50m48o3k3SLDnV
	 TClYTubz+s+7JCsJxih0msvNOkDZFNb8r0ejCwwQKNlal+iU+g6kPnijdoQRpBwM8N
	 9z+UfgpxXkJ5pV52tmD0MvTB6/55eOekBKCUQMSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.11 757/817] counter: stm32-timer-cnt: fix device_node handling in probe_encoder()
Date: Tue,  3 Dec 2024 15:45:29 +0100
Message-ID: <20241203144025.544897800@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


