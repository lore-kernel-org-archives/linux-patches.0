Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70EEB6FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED969C433D6;
	Wed, 30 Nov 2022 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833000;
	bh=YkLesouzWhoYl75jV+fEvEj4H/qgoLBwVk1C//aR6go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cS3UWNRilSAuB16C9wQFoIIMCg2sc3bCxhCgT2vkagXZ9b7Qw2BDDiD0731nE6221
	 7M2TDnOrnBvMLiN2k2jT6BFR84V9UkD4PiBXbJ1z/z1+9zpK08Mqxm4zHoQ0N8lvz3
	 Zq4J1dQI1Pvi/YX2J0kWrUcibdujQADfd9evxZVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/162] usb: dwc3: gadget: conditionally remove requests
Date: Wed, 30 Nov 2022 19:23:17 +0100
Message-Id: <20221130180531.633574184@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit b44c0e7fef51ee7e8ca8c6efbf706f5613787100 ]

The functions stop_active_transfers and ep_disable are both calling
remove_requests. This functions in both cases will giveback the requests
with status ESHUTDOWN, which also represents an physical disconnection.
For ep_disable this is not true. This patch adds the status parameter to
remove_requests and sets the status to ECONNRESET on ep_disable.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220720213523.1055897-1-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f90f5afd5083 ("usb: dwc3: gadget: Clear ep descriptor last")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/gadget.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 347ba7e4bd81..c753d889ae1c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -752,7 +752,7 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep, unsigned int action)
 	return 0;
 }
 
-static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
+static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep, int status)
 {
 	struct dwc3_request		*req;
 
@@ -762,19 +762,19 @@ static void dwc3_remove_requests(struct dwc3 *dwc, struct dwc3_ep *dep)
 	while (!list_empty(&dep->started_list)) {
 		req = next_request(&dep->started_list);
 
-		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		dwc3_gadget_giveback(dep, req, status);
 	}
 
 	while (!list_empty(&dep->pending_list)) {
 		req = next_request(&dep->pending_list);
 
-		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		dwc3_gadget_giveback(dep, req, status);
 	}
 
 	while (!list_empty(&dep->cancelled_list)) {
 		req = next_request(&dep->cancelled_list);
 
-		dwc3_gadget_giveback(dep, req, -ESHUTDOWN);
+		dwc3_gadget_giveback(dep, req, status);
 	}
 }
 
@@ -809,7 +809,7 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 		dep->endpoint.desc = NULL;
 	}
 
-	dwc3_remove_requests(dwc, dep);
+	dwc3_remove_requests(dwc, dep, -ECONNRESET);
 
 	dep->stream_capable = false;
 	dep->type = 0;
@@ -2067,7 +2067,7 @@ static void dwc3_stop_active_transfers(struct dwc3 *dwc)
 		if (!dep)
 			continue;
 
-		dwc3_remove_requests(dwc, dep);
+		dwc3_remove_requests(dwc, dep, -ESHUTDOWN);
 	}
 }
 
-- 
2.35.1



