Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FDC17D8BB;
	Tue, 30 Jul 2024 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358703; cv=none; b=lUXKUHCHb77/WFVY96PJ2RTwv8F/LN9uq8vPnVhI9QJNaSRtjGUECE4AaJiO2cyDgPjuSRd/Yp9nAUCQm6k2LM17QTMY7eqPf9UZCrdPq0XubALpuhnk0OnCncsSdKPwXJdnvfu3WrN8IZdzR56gjTfOGP5zk+ZollZ7PuJcfNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358703; c=relaxed/simple;
	bh=mmHIhGJIrsWAO89tpLavLAgWIB06/VTdCVf93O/9fAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMQBQJBGT1FJ5A0tQT/xIpKbE0mPdRDbWdv1bK9qheKAbw9tbiGW/n8/5LeUEM5LG94RQIKRNLwABGIukXRw6/NCKx8XAp4S2OxOSJn6CvdDILXeZ8fT9uIxfi1olyjNbuiWipSPCOKFVndDxXRD9c9FcRlHNb1E/3nKxoKByIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qG67M+PQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qG67M+PQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E6AC32782;
	Tue, 30 Jul 2024 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358703;
	bh=mmHIhGJIrsWAO89tpLavLAgWIB06/VTdCVf93O/9fAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qG67M+PQYhVRuW4bo3T5dj/OX2sA19XUKQbUWBcUUyozpMd/r1unDypL2umLb8Rdq
	 ONIpOX3nlGkGEddAVA/YaZa90fKKV+tGUypjTATjSkVxN9Fr3Z0qw1PAXiXsf4fcWB
	 jMaZmDGxBNAUbze4CaFxKF4ssIDZuYeDUj3bPBUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 372/568] ipv4: fix source address selection with route leak
Date: Tue, 30 Jul 2024 17:47:59 +0200
Message-ID: <20240730151654.403561529@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 6807352353561187a718e87204458999dbcbba1b upstream.

By default, an address assigned to the output interface is selected when
the source address is not specified. This is problematic when a route,
configured in a vrf, uses an interface from another vrf (aka route leak).
The original vrf does not own the selected source address.

Let's add a check against the output interface and call the appropriate
function to select the source address.

CC: stable@vger.kernel.org
Fixes: 8cbb512c923d ("net: Add source address lookup op for VRF")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240710081521.3809742-2-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2270,6 +2270,15 @@ void fib_select_path(struct net *net, st
 		fib_select_default(fl4, res);
 
 check_saddr:
-	if (!fl4->saddr)
-		fl4->saddr = fib_result_prefsrc(net, res);
+	if (!fl4->saddr) {
+		struct net_device *l3mdev;
+
+		l3mdev = dev_get_by_index_rcu(net, fl4->flowi4_l3mdev);
+
+		if (!l3mdev ||
+		    l3mdev_master_dev_rcu(FIB_RES_DEV(*res)) == l3mdev)
+			fl4->saddr = fib_result_prefsrc(net, res);
+		else
+			fl4->saddr = inet_select_addr(l3mdev, 0, RT_SCOPE_LINK);
+	}
 }


