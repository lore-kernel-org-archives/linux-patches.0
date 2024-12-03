Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F041F8AE1;
	Tue,  3 Dec 2024 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242536; cv=none; b=IGeqObWken8kXBM0RjHwEOU6f0TvNWwlGCa7HEwtaHn6Q8n2aNcs/XpafuiSC9d6tBE6kUws3sxcaJPnNsmHiyOeW350hhiz2Rt9aQTL5mWeNPqai0qmSCqMQUiyLkDZpsBULMsABEYdmZIeJYPUmOlln5SgsCIHahBc60f+cNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242536; c=relaxed/simple;
	bh=Nwfg02/28d+iPh8vZAf6NJJiMbkNjYi4Jp0Zj19XQIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6MD9zjOSGstSeKBdZMCjCwrpWjUO3xsLwuhIud1h6G8Snr8Hx5zeAtYT5E14rxALhzvayzac9Kj7yirmWgPpuqlLC3KMvIYvk7+l11QyvPLp4IlIFbKZi0WieDPJw5OZB6OxFByH0cHYFHpii0HfMlcLTvfTSUCyqeFYaMGsK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYMgkTfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYMgkTfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33974C4CED8;
	Tue,  3 Dec 2024 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242535;
	bh=Nwfg02/28d+iPh8vZAf6NJJiMbkNjYi4Jp0Zj19XQIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FYMgkTfoDNQDGhnqTZcHSWNzMC1dIXeNeH+gHgbXjbZAAyhI15wCFFa8JVT7tWBwA
	 Z6K43KyDTPSiVbvQqzU7gaz0cWZ0TQ4ljDCKcqFOvNihj5B/O4l6V7P5zendzhjefI
	 xiQIAs315oIirI9W51U6IRrbGLVyZaYJLCPBRbYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 734/826] netdev-genl: Hold rcu_read_lock in napi_get
Date: Tue,  3 Dec 2024 15:47:41 +0100
Message-ID: <20241203144812.399048820@linuxfoundation.org>
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

From: Joe Damato <jdamato@fastly.com>

commit c53bf100f68619acf6cedcf4cf5249a1ca2db0b4 upstream.

Hold rcu_read_lock in netdev_nl_napi_get_doit, which calls napi_by_id
and is required to be called under rcu_read_lock.

Cc: stable@vger.kernel.org
Fixes: 27f91aaf49b3 ("netdev-genl: Add netlink framework functions for napi")
Signed-off-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20241114175157.16604-1-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/netdev-genl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -215,6 +215,7 @@ int netdev_nl_napi_get_doit(struct sk_bu
 		return -ENOMEM;
 
 	rtnl_lock();
+	rcu_read_lock();
 
 	napi = napi_by_id(napi_id);
 	if (napi) {
@@ -224,6 +225,7 @@ int netdev_nl_napi_get_doit(struct sk_bu
 		err = -ENOENT;
 	}
 
+	rcu_read_unlock();
 	rtnl_unlock();
 
 	if (err)


