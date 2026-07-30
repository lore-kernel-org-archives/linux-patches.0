Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D8A2D0602;
	Thu, 30 Jul 2026 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423726; cv=none; b=UqPZV8Pm7IL/OlHBIjc1UnyRl6b97iC4ltEXM/WMxBANZ2ptQ61gdU5GfPqndLzlVB4U4B+NV6ySkGHi8jsoRxC3nx5K45cwXObjWlXP+kUpc/LeF+t2CenjXiXwCyJK0OD/3X4B0XgiLwdV3Q4s0aAJ+mWYS2L+9w3ASaT6Xik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423726; c=relaxed/simple;
	bh=W5UWgMs9pclOuQBrvdF1xeheN3EpMpH7mhrQl0nHQZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMDKBvM550kBU1wsOiLbT3WQylM2mQFoX4KdTTRcAAM+vHdEHWnwkRFdc1RCG9fEVitNNrNzY3iGwtCMWTP0JpPX5HyE0XKUZnhhN9aL2A0ZMw8Q3++eO8p4rERt4+D8s6cgBMQfrqToL23Ce0uQ8j7qkO4UQfAIFWgEfP0xO+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POiXOQsm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POiXOQsm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A161F000E9;
	Thu, 30 Jul 2026 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423724;
	bh=EqULe4OQYs3T/B/DMvwY8WurQx2uEWCKgJp7ogksNPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POiXOQsmGIubsKDUlsfcczspUSMZW8N7jncFQa6FUxQFoE8BWJEoK8XbKGIXFbXiG
	 RLv5WE8buQftr+na/W0mubNT0lbLiewGoUN6kU7o4l86Tk13kehkQHgSh4I4B064J6
	 m1RGwFE1OUbuO0+8NNYuLUbwJ6yolOsaTP5QdLUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 144/675] usb: chipidea: fix usage_count leak when autosuspend_delay is negative
Date: Thu, 30 Jul 2026 16:07:54 +0200
Message-ID: <20260730141448.199231636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit fc3afb5728e297994863f8a2a01b88a920bbf53e upstream.

The probe() calls pm_runtime_use_autosuspend(), but remove() does not call
pm_runtime_dont_use_autosuspend(). This can lead to a usage_count leak if
autosuspend_delay is set to a negative value.

The pm_runtime_use_autosuspend() also notes that it's important to undo
this with pm_runtime_dont_use_autosuspend() at driver exit time.

Fixes: 1f874edcb731 ("usb: chipidea: add runtime power management support")
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260716104126.2763454-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -1265,6 +1265,7 @@ static void ci_hdrc_remove(struct platfo
 		usb_role_switch_unregister(ci->role_switch);
 
 	if (ci->supports_runtime_pm) {
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		pm_runtime_get_sync(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_put_noidle(&pdev->dev);


