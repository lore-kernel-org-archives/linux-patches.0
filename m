Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187A41DED5E;
	Wed, 19 Feb 2025 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955034; cv=none; b=LI6fmiXOKjhU4J28QiftRLBnMLgIO4B5aaK04g9v6FDSTxxTWGqeTpgqoZtlmxK1XdZ4Gv2lCFDiqOE5IMfdRkE2zC/KcVxIzfJcJxU5P343JxTltD8cdncNosmVsVZKmBiZQ99gF+lZYkUS+oAYe/I5Ai37bif8IvDG/hOujT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955034; c=relaxed/simple;
	bh=O6X0KTDwfrvRAUgRpBzdeGCJo73s8IGoqlIUsUJBYts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gd260hhgu4rc5mgXTZe2UybKK2m0avbnZ63qIwa2d/HsWlTaRpRqmy4iYx7PThlU2prccPGXpkHhB7c3/Nof+7MTlTnoav7rQiqMyH/YBPatB+1VfXGTYA/5Uu8UCo0uXy183/wskdt7bCSjJwDUBbcPV7YmFJ43SJtslFJx1Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/8VzTTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/8VzTTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B68C4CEE6;
	Wed, 19 Feb 2025 08:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955034;
	bh=O6X0KTDwfrvRAUgRpBzdeGCJo73s8IGoqlIUsUJBYts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/8VzTTD+0mjR2ZTyf8W8Bmk/bm0kBq1PvgRzI28lMN5F9NV9xckmG97vrBs476A+
	 0CIQb/u1A5Dib2Ox+gqwXmgYuTtei1bHjIXAPBdTFdY37lL6UdzAme0EMKyf/qefyS
	 g8l5aAzZzSVUkLEDyjj7sKIwUnZfXTWd5Yfbubf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 111/230] usb: roles: set switch registered flag early on
Date: Wed, 19 Feb 2025 09:27:08 +0100
Message-ID: <20250219082606.032869341@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Elson Roy Serrao <quic_eserrao@quicinc.com>

commit 634775a752a86784511018a108f3b530cc3399a7 upstream.

The role switch registration and set_role() can happen in parallel as they
are invoked independent of each other. There is a possibility that a driver
might spend significant amount of time in usb_role_switch_register() API
due to the presence of time intensive operations like component_add()
which operate under common mutex. This leads to a time window after
allocating the switch and before setting the registered flag where the set
role notifications are dropped. Below timeline summarizes this behavior

Thread1				|	Thread2
usb_role_switch_register()	|
	|			|
	---> allocate switch	|
	|			|
	---> component_add()	|	usb_role_switch_set_role()
	|			|	|
	|			|	--> Drop role notifications
	|			|	    since sw->registered
	|			|	    flag is not set.
	|			|
	--->Set registered flag.|

To avoid this, set the registered flag early on in the switch register
API.

Fixes: b787a3e78175 ("usb: roles: don't get/set_role() when usb_role_switch is unregistered")
Cc: stable <stable@kernel.org>
Signed-off-by: Elson Roy Serrao <quic_eserrao@quicinc.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250206193950.22421-1-quic_eserrao@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -387,8 +387,11 @@ usb_role_switch_register(struct device *
 	dev_set_name(&sw->dev, "%s-role-switch",
 		     desc->name ? desc->name : dev_name(parent));
 
+	sw->registered = true;
+
 	ret = device_register(&sw->dev);
 	if (ret) {
+		sw->registered = false;
 		put_device(&sw->dev);
 		return ERR_PTR(ret);
 	}
@@ -399,8 +402,6 @@ usb_role_switch_register(struct device *
 			dev_warn(&sw->dev, "failed to add component\n");
 	}
 
-	sw->registered = true;
-
 	/* TODO: Symlinks for the host port and the device controller. */
 
 	return sw;


