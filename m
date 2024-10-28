Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D341815B10D;
	Mon, 28 Oct 2024 06:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097774; cv=none; b=V+b2RDsH/wtF58950B5Djh1wVeIXCDIGmSFE+1gtgQcPRa16wo9enO+vSfKDIXKoVBrboYb5iSlvMOesVkk3kvkB+/nyErtAHNQBbM1C34Htiw28vYzDmFg60xR98cIgk5/IE9jl2kN8JRpIJPlNIyLtzatZsIDPQGpX0+XkzoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097774; c=relaxed/simple;
	bh=qBncWh9pN0menQ+SXVucsX1E4A4Fnzuew+R50KOHbzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0ttsjuoAgbMTFm9TBara3d6RzwelQm9/1iLkZ9R8jAg4usv+S0hU2rSJ9o6cBSJt7L7ZadCq6gc4gOEPMV+v//riEOuvhMwSslKH88rq06agrl533bjjeC6T06rpL+3FejTbsCdXaY2iNeqCjgy959Men5qqBVxhUpjjP+tdn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrHXy2/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrHXy2/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72424C4CEC3;
	Mon, 28 Oct 2024 06:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097774;
	bh=qBncWh9pN0menQ+SXVucsX1E4A4Fnzuew+R50KOHbzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrHXy2/T8mhuyIEBMrmyZ6YjwVkMHAGF5XUOcjo1QEhOsX5mlrzhhR8BM8WlHrKka
	 2pjGeu68v3pMLQ3hX2Ros4CKgI0XaFVrUdvD3IuHX5COvwHPhmt1AIM5fovkxg/Jx3
	 JGfQQ621ueEg/ShER/l8xq3qFAlSit3NFgeU+sy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Kevin Groeneveld <kgroeneveld@lenbrook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/208] usb: gadget: f_uac2: fix return value for UAC2_ATTRIBUTE_STRING store
Date: Mon, 28 Oct 2024 07:24:44 +0100
Message-ID: <20241028062309.220437978@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Kevin Groeneveld <kgroeneveld@lenbrook.com>

[ Upstream commit 9499327714de7bc5cf6c792112c1474932d8ad31 ]

The configfs store callback should return the number of bytes consumed
not the total number of bytes we actually stored. These could differ if
for example the passed in string had a newline we did not store.

If the returned value does not match the number of bytes written the
writer might assume a failure or keep trying to write the remaining bytes.

For example the following command will hang trying to write the final
newline over and over again (tested on bash 2.05b):

  echo foo > function_name

Fixes: 993a44fa85c1 ("usb: gadget: f_uac2: allow changing interface name via configfs")
Cc: stable <stable@kernel.org>
Signed-off-by: Kevin Groeneveld <kgroeneveld@lenbrook.com>
Link: https://lore.kernel.org/r/20241006232637.4267-1-kgroeneveld@lenbrook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 79d1f87c6cc59..b3dc5f5164f42 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2052,7 +2052,7 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 					  const char *page, size_t len)	\
 {									\
 	struct f_uac2_opts *opts = to_f_uac2_opts(item);		\
-	int ret = 0;							\
+	int ret = len;							\
 									\
 	mutex_lock(&opts->lock);					\
 	if (opts->refcnt) {						\
@@ -2063,8 +2063,8 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 	if (len && page[len - 1] == '\n')				\
 		len--;							\
 									\
-	ret = scnprintf(opts->name, min(sizeof(opts->name), len + 1),	\
-			"%s", page);					\
+	scnprintf(opts->name, min(sizeof(opts->name), len + 1),		\
+		  "%s", page);						\
 									\
 end:									\
 	mutex_unlock(&opts->lock);					\
-- 
2.43.0



