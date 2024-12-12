Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F7D211A34;
	Thu, 12 Dec 2024 17:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022905; cv=none; b=EBuPUxjAq/+4bi2iPg4TLDy99c11PDvFvzPf2V2vuH9jO6x+3zbZ6F8vxubOi2WzcMRqM2GlkE8BnMxtYrCJ7QjsX9GuGulSFmOPM6iWcHGLZIm7W20rtzPnODOVSlDKrwa0Lp5OEabK6ihFU9R849g6JkxqULCpzlhjYZKVoDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022905; c=relaxed/simple;
	bh=SSK21wSOGFhBDXeE/ox3+RXWEfPy/k0UPD7s9QsYSbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKZMo02/iGn49Crd8w6xYHmrUIA32lwjIs/ncVcnM4wFb3uMraOdM9IRfnFsWIhJZWIRsgoK+quqgd6LgKaBLQKssfSkLXCZ55vvoyJ6EWeyFMlMLFlS/zSSb5FPWV2sShT9cWfeEOaQWKnv1ECulDLCiEEjKLWznUBI6fwDP+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXXVnrv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXXVnrv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3268C4CECE;
	Thu, 12 Dec 2024 17:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022905;
	bh=SSK21wSOGFhBDXeE/ox3+RXWEfPy/k0UPD7s9QsYSbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXXVnrv+UUbNM/c+/hTwKWhcReUFQ2sczYxHpdh0rXGmqW92SZ/wSLLtwCmCSxlaN
	 MFuDiW3ugX3R9zh/Egg1Sq1T3+xXWcCQeyz599YH6Z71EcVELRDCUyiWsCqoj3q5v6
	 nFpDxCChYPPLRMnHEBqjLOvDzapu9ELDtqJ8Bt7g=
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
Subject: [PATCH 5.15 366/565] 9p/xen: fix init sequence
Date: Thu, 12 Dec 2024 15:59:21 +0100
Message-ID: <20241212144326.083011324@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 99e6b2483311c..716736046a18f 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -487,6 +487,7 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 		goto error;
 	}
 
+	xenbus_switch_state(dev, XenbusStateInitialised);
 	return 0;
 
  error_xenbus:
@@ -534,8 +535,10 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
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



