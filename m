Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5292C1092;
	Mon, 12 May 2025 18:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073145; cv=none; b=Q6wVHysADw2tTACT/8lGmt8qs6zWj4oPxWYKZbNu/kAlxWUt9BfI2EHTftl+hnwP3IGzh/nFpa2A9dUAfBH1jzDJluRJC0jfos4Rz9BFWZWt4Bl56Dh31ZLhCwG45sVdXwmS69n/fh4fIRSepAMqar+3BQi5K1/7IHQbRp+3gHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073145; c=relaxed/simple;
	bh=0M7b1jwuL8aGrtVgJT1veCJSLkJZ6QXbB0t/Micp/7M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HLV/ir5ofsklfFw6jMk7/ERL1LEtmT/vUIf0Ag9vAQY+yiDRc1BVTMgpSYNLlWQMbvqMCfz+DE8uxltXVs9G133dLZf9RvjV1T41OF69vCi2K8OuwG8DJm7h6WnzJ2TC4gLT7gE6/6lR74uxbI459IKYL4cBrWlw0hykrfhDCuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tyuVzCWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tyuVzCWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF8EC4CEE7;
	Mon, 12 May 2025 18:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073144;
	bh=0M7b1jwuL8aGrtVgJT1veCJSLkJZ6QXbB0t/Micp/7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyuVzCWj63wXRMOHJ5MGlLunznISQVMA/lipEyRQCtMonx1NA4tgbZKzpwtNfv7/C
	 3RhMntOlyqtZGbIiUSEDZXB4882iArRoeFc+E3J+E3/ul/EMvRc8UTXS/ViB3JFtF3
	 VfGq4XembhqziMvOavLcgg/da1Pe0cX/b2asOV87qjGQxxnxrJBCPL1sB1ges1Y1Na
	 EhbHGEDiuMbo/UIJblj5zk9es2FLI1JIjy66ZO/BKu5cG0nkMFAPz7Ut3fF1wcBVpU
	 4txeuvt69xDTSAS084chd9p2koow9L/RBjnSCjWI0WCYp4sNr8yK7tPRMh2/IkVeC5
	 jTf/O886yQmUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Andryuk <jason.andryuk@amd.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	chenqiuji666@gmail.com,
	gregkh@linuxfoundation.org,
	xin.wang2@amd.com,
	xen-devel@lists.xenproject.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/3] xenbus: Allow PVH dom0 a non-local xenstore
Date: Mon, 12 May 2025 14:05:36 -0400
Message-Id: <20250512180537.438255-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180537.438255-1-sashal@kernel.org>
References: <20250512180537.438255-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit 90989869baae47ee2aa3bcb6f6eb9fbbe4287958 ]

Make xenbus_init() allow a non-local xenstore for a PVH dom0 - it is
currently forced to XS_LOCAL.  With Hyperlaunch booting dom0 and a
xenstore stubdom, dom0 can be handled as a regular XS_HVM following the
late init path.

Ideally we'd drop the use of xen_initial_domain() and just check for the
event channel instead.  However, ARM has a xen,enhanced no-xenstore
mode, where the event channel and PFN would both be 0.  Retain the
xen_initial_domain() check, and use that for an additional check when
the event channel is 0.

Check the full 64bit HVM_PARAM_STORE_EVTCHN value to catch the off
chance that high bits are set for the 32bit event channel.

Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Change-Id: I5506da42e4c6b8e85079fefb2f193c8de17c7437
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250506204456.5220-1-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_probe.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index fd686b962727a..17705f82f85fd 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -881,9 +881,15 @@ static int __init xenbus_init(void)
 	if (xen_pv_domain())
 		xen_store_domain_type = XS_PV;
 	if (xen_hvm_domain())
+	{
 		xen_store_domain_type = XS_HVM;
-	if (xen_hvm_domain() && xen_initial_domain())
-		xen_store_domain_type = XS_LOCAL;
+		err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
+		if (err)
+			goto out_error;
+		xen_store_evtchn = (int)v;
+		if (!v && xen_initial_domain())
+			xen_store_domain_type = XS_LOCAL;
+	}
 	if (xen_pv_domain() && !xen_start_info->store_evtchn)
 		xen_store_domain_type = XS_LOCAL;
 	if (xen_pv_domain() && xen_start_info->store_evtchn)
@@ -902,10 +908,6 @@ static int __init xenbus_init(void)
 		xen_store_interface = gfn_to_virt(xen_store_gfn);
 		break;
 	case XS_HVM:
-		err = hvm_get_parameter(HVM_PARAM_STORE_EVTCHN, &v);
-		if (err)
-			goto out_error;
-		xen_store_evtchn = (int)v;
 		err = hvm_get_parameter(HVM_PARAM_STORE_PFN, &v);
 		if (err)
 			goto out_error;
-- 
2.39.5

