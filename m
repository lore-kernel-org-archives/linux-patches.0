Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7680533688F;
	Tue, 16 Jun 2026 16:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626724; cv=none; b=KNSo7u7J0+3U5TbY46r/Y1Di/OCRiVmz7v9r6sydb1DH/SFru/ad3KltAVWq/gEOcURMvE+femLXY2HCUFaUWgegYy1HYGDYN+FXj1x3oqy4K7bQGAPnCxfyKCnjZ+rH43Oo3wtg33v+Rb2aACxC7l++GOax/MSYA0IL6ZhEDjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626724; c=relaxed/simple;
	bh=EzEGQv89A6csECx+/nFRYznaz9E74C1WaAAeoovpokc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AIYmNktT6NsIrYTn4HUVJSFSbEsrOjYjP23xg0yoHzMEFJ8sxrIK1m99gL3+YbDswwsIYjkekQV1OI7cDbxEWT9cdy9FBZYZ2/yTA1c7wgpslK3niby3Lpz5eWCyHx6oD7E8sYKfFSNykNHOibfwqHD/eGamuoxDZlPuQ9Ri9Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lijeUqDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lijeUqDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB501F000E9;
	Tue, 16 Jun 2026 16:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626723;
	bh=wbK4hqLmsXUfxraTQmz+IQoMk5AUX/mDqNarW7evRDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lijeUqDqGeOmnAWbCSDi5QLXO1x65bpzde1tDw0rM+KdzCjf68Og7STWPg3yIAHGi
	 6SoJOKDLaYQ0v9sHI3iOjgE6/I1hQPZWvPvj4a3pAoV/5GLmewgI8TAntfodEOa0QR
	 NkF3JP//LLac8HOIvqcHXxz4Osn3hRTMDas8oN8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Roulin <aroulin@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/261] vxlan: vnifilter: fix spurious notification on VNI update
Date: Tue, 16 Jun 2026 20:28:14 +0530
Message-ID: <20260616145047.753432827@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Roulin <aroulin@nvidia.com>

[ Upstream commit 84683b5b60c7274e2c8f7f413d39d78d3db5540f ]

When a VNI is re-added with the same attributes (e.g. same group or no
group), vxlan_vni_update() sends a spurious RTM_NEWTUNNEL notification
even though nothing changed.

The bug is that 'if (changed)' tests whether the pointer is non-NULL,
not the bool value it points to. Since every caller passes a valid
pointer, the condition is always true and the notification fires
unconditionally.

Fix by dereferencing the pointer: 'if (*changed)'.

Reproducer:

 # ip link add vxlan100 type vxlan dstport 4789 local 10.0.0.1 \
      nolearning external vnifilter
 # ip link set vxlan100 up
 # bridge monitor vni &
 # bridge vni add vni 1000 dev vxlan100
 # bridge vni add vni 1000 dev vxlan100  # spurious notification

Fixes: f9c4bb0b245c ("vxlan: vni filtering support on collect metadata device")
Signed-off-by: Andy Roulin <aroulin@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20260602185138.253265-3-aroulin@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_vnifilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_vnifilter.c b/drivers/net/vxlan/vxlan_vnifilter.c
index 1ab78a8bb9e011..272fa31ef07454 100644
--- a/drivers/net/vxlan/vxlan_vnifilter.c
+++ b/drivers/net/vxlan/vxlan_vnifilter.c
@@ -671,7 +671,7 @@ static int vxlan_vni_update(struct vxlan_dev *vxlan,
 	if (ret)
 		return ret;
 
-	if (changed)
+	if (*changed)
 		vxlan_vnifilter_notify(vxlan, vninode, RTM_NEWTUNNEL);
 
 	return 0;
-- 
2.53.0



