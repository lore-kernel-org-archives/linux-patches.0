Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E061C3024;
	Mon, 14 Oct 2024 14:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917215; cv=none; b=SxvgdDpkbpk9H5+i/VyzfLcHakOrRzBJFbqw9/638Ji4YGTYFPOo1J/QYwIigfN3kUkHxbYKHp1K5w653Y4Ad84K2HsO51OXC4vcZU/xIf0JCM514E68/1Q9osl6J5xmJNj9oE8ld2AYpuqKoZa0u6G61szl/m2dGGw5XKNalLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917215; c=relaxed/simple;
	bh=fgSOYKoV7jL7RoIj8I6hzWtku8fC4449ca95uQrNDik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM2dJeAtIUUufY6UKnDPRw6mb3jzrlI0F+v6peynTZfaxXhHqADuOLiuzRDYGbOgxUDwzoFrVKtg4akoh+Hb370CLOWpg1ADHtTNsJnpp8wBScHb+JynMUwQoT63u7gANS6F0VhR7Yd1JFOo3y2i5ySrPUTy9xFkag78A0AVjHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=192GzAsE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="192GzAsE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0900C4CEC3;
	Mon, 14 Oct 2024 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917215;
	bh=fgSOYKoV7jL7RoIj8I6hzWtku8fC4449ca95uQrNDik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=192GzAsEMLss9oKxzsFdKHGYfo81DjmPzFZ+YdHsi/HxV1ByY1f3eGKXbWijpUbZW
	 /ja9JbXBd2lBxclclRnsaDgsZ5cnuNm77eNEYQyhLxEPkmJ9hogo9hc8uoz9l1px+9
	 qmq8WcMktdeQiEuAigE8gYuEjdI+/zk5yb34Xikk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>
Subject: [PATCH 6.6 186/213] usb: gadget: core: force synchronous registration
Date: Mon, 14 Oct 2024 16:21:32 +0200
Message-ID: <20241014141050.224257047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: John Keeping <jkeeping@inmusicbrands.com>

commit df9158826b00e53f42c67d62c887a84490d80a0a upstream.

Registering a gadget driver is expected to complete synchronously and
immediately after calling driver_register() this function checks that
the driver has bound so as to return an error.

Set PROBE_FORCE_SYNCHRONOUS to ensure this is the case even when
asynchronous probing is set as the default.

Fixes: fc274c1e99731 ("USB: gadget: Add a new bus for gadgets")
Cc: stable@vger.kernel.org
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://lore.kernel.org/r/20240913102325.2826261-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1671,6 +1671,7 @@ int usb_gadget_register_driver_owner(str
 	driver->driver.bus = &gadget_bus_type;
 	driver->driver.owner = owner;
 	driver->driver.mod_name = mod_name;
+	driver->driver.probe_type = PROBE_FORCE_SYNCHRONOUS;
 	ret = driver_register(&driver->driver);
 	if (ret) {
 		pr_warn("%s: driver registration failed: %d\n",


