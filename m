Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9472F55;
	Thu, 13 Jun 2024 12:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718283063; cv=none; b=fGJFK0SXc7tn9LQy/TGAb2wMuaJgHS30LC2V08nr+DY79hS8Rx0oh64vn3I1OShKIZukeTmoRX5epqU3nMGgunRQNblGfcfFxs6sztNOHM3Y8f25XFzVyUf75k5wlQehYBD+DHcJXxchTa9mZ4f9KdbubV4crkT1GTnTUH089Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718283063; c=relaxed/simple;
	bh=N21xf0syEnIPT3IpCUwiUpjGtqn45xN5O+ueHhoVWD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZuX+ssJSWYiU3Jy4+g9aM9XYsXJyls49Q0FzHHU6XsxCjckzlY1HnRn4X4m9WkwcbfuAw7OWNZjlK2gmuUImDVWKG1yoqWnRGSrzf0TW2ipx8yGQw8SjOsbnlrSKfBROvBLL4RlUD5j+hRvCY6G6QYP31pIqRnTrV+jRXmGbcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hl+S3g2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hl+S3g2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DBA3C2BBFC;
	Thu, 13 Jun 2024 12:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718283063;
	bh=N21xf0syEnIPT3IpCUwiUpjGtqn45xN5O+ueHhoVWD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hl+S3g2ucenJTklzDDeWGBq4k2/SaUWURI5GtrQsXaUI7l+c2s8Wu++FQEYBUpgyy
	 W5FvSCPvn9EyZ1wmzDL2Kl0UTsNQei1cntrPjSOss2gSDeUlUPNeVkZu+nydqINwcm
	 9s/g94ydo7slgbYPUNhpJ8xYhFztIp3Dt7FqfVzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Yu <fan.yu9@zte.com.cn>,
	xu xin <xu.xin16@zte.com.cn>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 56/85] net/ipv6: Fix route deleting failure when metric equals 0
Date: Thu, 13 Jun 2024 13:35:54 +0200
Message-ID: <20240613113216.301222478@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: xu xin <xu.xin16@zte.com.cn>

commit bb487272380d120295e955ad8acfcbb281b57642 upstream.

Problem
=========
After commit 67f695134703 ("ipv6: Move setting default metric for routes"),
we noticed that the logic of assigning the default value of fc_metirc
changed in the ioctl process. That is, when users use ioctl(fd, SIOCADDRT,
rt) with a non-zero metric to add a route,  then they may fail to delete a
route with passing in a metric value of 0 to the kernel by ioctl(fd,
SIOCDELRT, rt). But iproute can succeed in deleting it.

As a reference, when using iproute tools by netlink to delete routes with
a metric parameter equals 0, like the command as follows:

	ip -6 route del fe80::/64 via fe81::5054:ff:fe11:3451 dev eth0 metric 0

the user can still succeed in deleting the route entry with the smallest
metric.

Root Reason
===========
After commit 67f695134703 ("ipv6: Move setting default metric for routes"),
When ioctl() pass in SIOCDELRT with a zero metric, rtmsg_to_fib6_config()
will set a defalut value (1024) to cfg->fc_metric in kernel, and in
ip6_route_del() and the line 4074 at net/ipv3/route.c, it will check by

	if (cfg->fc_metric && cfg->fc_metric != rt->fib6_metric)
		continue;

and the condition is true and skip the later procedure (deleting route)
because cfg->fc_metric != rt->fib6_metric. But before that commit,
cfg->fc_metric is still zero there, so the condition is false and it
will do the following procedure (deleting).

Solution
========
In order to keep a consistent behaviour across netlink() and ioctl(), we
should allow to delete a route with a metric value of 0. So we only do
the default setting of fc_metric in route adding.

CC: stable@vger.kernel.org # 5.4+
Fixes: 67f695134703 ("ipv6: Move setting default metric for routes")
Co-developed-by: Fan Yu <fan.yu9@zte.com.cn>
Signed-off-by: Fan Yu <fan.yu9@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240514201102055dD2Ba45qKbLlUMxu_DTHP@zte.com.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4435,7 +4435,7 @@ static void rtmsg_to_fib6_config(struct
 		.fc_table = l3mdev_fib_table_by_index(net, rtmsg->rtmsg_ifindex) ?
 			 : RT6_TABLE_MAIN,
 		.fc_ifindex = rtmsg->rtmsg_ifindex,
-		.fc_metric = rtmsg->rtmsg_metric ? : IP6_RT_PRIO_USER,
+		.fc_metric = rtmsg->rtmsg_metric,
 		.fc_expires = rtmsg->rtmsg_info,
 		.fc_dst_len = rtmsg->rtmsg_dst_len,
 		.fc_src_len = rtmsg->rtmsg_src_len,
@@ -4465,6 +4465,9 @@ int ipv6_route_ioctl(struct net *net, un
 	rtnl_lock();
 	switch (cmd) {
 	case SIOCADDRT:
+		/* Only do the default setting of fc_metric in route adding */
+		if (cfg.fc_metric == 0)
+			cfg.fc_metric = IP6_RT_PRIO_USER;
 		err = ip6_route_add(&cfg, GFP_KERNEL, NULL);
 		break;
 	case SIOCDELRT:


