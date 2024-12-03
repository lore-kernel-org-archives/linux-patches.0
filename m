Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F41F7567;
	Tue,  3 Dec 2024 16:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242744; cv=none; b=HX87K2Wvr13e2n3hlma036bGnQPqV5JsxY9PNZ0QjKi5K1oTtLqTh76n5tIB/+oPiNHua0j9NV2wrc5zbP07z4xa//uzQxpwfH9l/x1zTl21ZMzcDZNiN74BrO40M/6BUZbq5d5SwhWFsHnwFPFwQb/w8W3uAhLxsVmt/SWT72s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242744; c=relaxed/simple;
	bh=Wisgkjt57uOnmP+ogYq9YaOGkrDHj8KY3Ibs41H1pMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coMX2cWi/A//pa6S4O7WHbkqhFrX0QwDsa+aqv6WM8ln6sqSQKZdM6IodhYAGy+fiKZz7RyWZwi5JaVzaGL4gFcBk0wr61S1AQwA1jCmjqZyJvBcRO1dByr66mlGYZDg4Z5WC+C14L3WaRM8ZIcDXAquW4IVtg5lfZrBmkjPYOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy4d82iC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy4d82iC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E357C4CECF;
	Tue,  3 Dec 2024 16:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242743;
	bh=Wisgkjt57uOnmP+ogYq9YaOGkrDHj8KY3Ibs41H1pMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uy4d82iCqQe77P0079Fl/yxLqtqqhMG3a45e6no2zCY2YxV9d/IhWpVdU2JMOActU
	 jiVG5sR5eWuWxrFO4bIzsxubPXI7afuGRpfObyD0pAa4BS75HW4KoiKwiXiueXGHuO
	 wAKG4dXvwXJmROBQKwkUk6x07/3T1ef1+5yb2gSc=
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
Subject: [PATCH 6.12 797/826] 9p/xen: fix init sequence
Date: Tue,  3 Dec 2024 15:48:44 +0100
Message-ID: <20241203144814.846859398@linuxfoundation.org>
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
index dfdbe1ca53387..0304e8a1616d8 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -465,6 +465,7 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 		goto error;
 	}
 
+	xenbus_switch_state(dev, XenbusStateInitialised);
 	return 0;
 
  error_xenbus:
@@ -512,8 +513,10 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
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



