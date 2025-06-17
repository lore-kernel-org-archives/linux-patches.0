Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBC0204F73;
	Tue, 17 Jun 2025 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177441; cv=none; b=iEqDONvrNOe/MPIA6qrJFtSdrTTMzyM/9owGJFreGc/bI2S3QMjT8lCWF+InXjsFKj9T2AWHFcjM6OWzVIQVLNXJ/f7pOx/jne+qu0qDvbJhx74Xw6hjoRjz0+PsSqHDudxGzCqHTVR2R0cfJAykxHpiED5IZ1AQjQI3vCC/J2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177441; c=relaxed/simple;
	bh=d112IVyhP0xqrlXpChflGVdVUwNPqeTICifYnIFyzfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fecCXQSlhnamLZ9UUIGhhhjWJJZN2gUFEcakBrVKDjf/bM10YTcbIO762iWv9lcrXZiR+lcIw8NQOZMCHZucG0Xb7GGQPgGSeAPk93g9bvTSXFWASes5L2RHiL4psaANEeRAw/S/hFOt67xjBWyan+65Qxb4nMhwwg+Wu+iGRrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTw1rg3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTw1rg3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC01C4CEE3;
	Tue, 17 Jun 2025 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177441;
	bh=d112IVyhP0xqrlXpChflGVdVUwNPqeTICifYnIFyzfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTw1rg3FOstrq2+gxPTgvQURYGjewubJgCzmNfFoRgmUkBxQ/EP3mTOtTsksSFDXu
	 4EiwlI/Nip+/kujeQ+Da+2hWZlJIUAxLDJmR1d0WL4ObGGj6OJdMpPh+eHpZeqaTQs
	 x92zazv9hkS1roJsT2e+F65FxKTnBD6FF0v8HShA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/512] USB: typec: fix const issue in typec_match()
Date: Tue, 17 Jun 2025 17:25:08 +0200
Message-ID: <20250617152433.457254094@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ae4432e01dd967a64f6670a152d91d5328032726 ]

typec_match() takes a const pointer, and then decides to cast it away
into a non-const one, which is not a good thing to do overall.  Fix this
up by properly setting the pointers to be const to preserve that
attribute.

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/2025052126-scholar-stainless-ad55@gregkh
Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/bus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/bus.c b/drivers/usb/typec/bus.c
index aa879253d3b81..13044ee5be10d 100644
--- a/drivers/usb/typec/bus.c
+++ b/drivers/usb/typec/bus.c
@@ -449,7 +449,7 @@ ATTRIBUTE_GROUPS(typec);
 
 static int typec_match(struct device *dev, const struct device_driver *driver)
 {
-	struct typec_altmode_driver *drv = to_altmode_driver(driver);
+	const struct typec_altmode_driver *drv = to_altmode_driver(driver);
 	struct typec_altmode *altmode = to_typec_altmode(dev);
 	const struct typec_device_id *id;
 
-- 
2.39.5



