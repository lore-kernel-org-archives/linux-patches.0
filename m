Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6546C14F9F4;
	Fri,  6 Dec 2024 15:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498395; cv=none; b=Vds4y0sq7MmwrEnxg6aGOKXmVNvD9qsgICMLLNlcC0mN5ywklcy+5A4LiQOdISlAZ5SJmJD0juhYgvQIZj1WdR+dgzK/Gts8BB+8Y0O5QFt+q3yNBpQ1WhHfdKzE4VULLZHn1RJrV8H2II+DMA0xOHna+5tXTjShlSR9dMiC3rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498395; c=relaxed/simple;
	bh=pDCIPWZwsE82zHdnPfeuVzhfmiOGiv/y+ygz+T08eFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtLPhNuds3qkHE/CUo2Hi2vAW4A6sjxpDYhZgl3GsFUJbs1N9RkkVMP7PM+G/JylYyyG1oC4OYLuWlSh9DdzVlN3tUIa/gy3JQURxskps8AwG2zAKZBfmHBNvbu/OJgVsaX2vM3j5KVqHptz2Wfev8ylakS+fkMbX4QJDw05gXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoYdzDez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoYdzDez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C684BC4CED1;
	Fri,  6 Dec 2024 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498395;
	bh=pDCIPWZwsE82zHdnPfeuVzhfmiOGiv/y+ygz+T08eFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoYdzDez0vnxF7+jJS/dVFH6QwH3ipNXFOKgVeiMMTtS3FEQLBM1p3g0jqXsjLquO
	 IIpPHSdsVmck3TTx6P61KQiMg7+TZQ+0ZHj2OrvojNXqeMG5Xh/vwHXfosSI1Y5mra
	 4cF8SG/hftkCW2GiKC0haabZBJGRt3OYXcjR/NkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 572/676] 9p/xen: fix init sequence
Date: Fri,  6 Dec 2024 15:36:31 +0100
Message-ID: <20241206143715.700999265@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Alex Zenla <alex@edera.dev>

[ Upstream commit 7ef3ae82a6ebbf4750967d1ce43bcdb7e44ff74b ]

Large amount of mount hangs observed during hotplugging of 9pfs devices. The
9pfs Xen driver attempts to initialize itself more than once, causing the
frontend and backend to disagree: the backend listens on a channel that the
frontend does not send on, resulting in stalled processing.

Only allow initialization of 9p frontend once.

Fixes: c15fe55d14b3b ("9p/xen: fix connection sequence")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241119211633.38321-1-alexander@edera.dev>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 1fffe2bed5b02..308dae05aa9a1 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -466,6 +466,7 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 		goto error;
 	}
 
+	xenbus_switch_state(dev, XenbusStateInitialised);
 	return 0;
 
  error_xenbus:
@@ -513,8 +514,10 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
-		if (!xen_9pfs_front_init(dev))
-			xenbus_switch_state(dev, XenbusStateInitialised);
+		if (dev->state != XenbusStateInitialising)
+			break;
+
+		xen_9pfs_front_init(dev);
 		break;
 
 	case XenbusStateConnected:
-- 
2.43.0



