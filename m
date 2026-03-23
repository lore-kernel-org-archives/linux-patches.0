Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10BA2459CF;
	Mon, 23 Mar 2026 15:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278432; cv=none; b=rcUJUlfAKIPmxQdSukYr4WDa9s1AoG6x6ctSmL05A1m0HK5cdTC801jA0aWPXvH9Sn+JF1ODhQr63psWwYrA5OAIer61Rg0Wi0Xl8yuvLvbdhNV3iS3/B4DNnk5BvId+Lt/MBoG4BiYBpPGikVqxL9EkKxSP2IIVU8eeuW9ZeQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278432; c=relaxed/simple;
	bh=KVp7NqPwWbX4/J2i69tToozWEdpp1kicfFJ2xwfpWlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsC1UiZemat64tzdukmLQmR72Y4u1kCb/UYb+/BeNxgvESUS455l9TQtBhmAQii60Oxn1TTDIuPJ943Tglbg0A2XGabfvblIBTqqfwmMxnsVSCehyRYr0h0kRf+eqAUZKUp2so11SnMjXdhHb1GKYhU7Rm/82zTWtBuGXSmZPQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuVigzzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuVigzzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F93EC4CEF7;
	Mon, 23 Mar 2026 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278432;
	bh=KVp7NqPwWbX4/J2i69tToozWEdpp1kicfFJ2xwfpWlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuVigzzDQiJe1hUsmPektz17f1/sGgF7eGpxAjJp+9sSrnzVnpuiMfpmabKItEbEW
	 T5ZacAcWTXQdC2ctocEwCoLYH1oYfVXTzs7GXmIZm4q+HkrwizC+Ikp8xgC5+NdP2O
	 bM02h5rC3b/UAAlBvgAIg7XcTxOmdZB1xADkU9lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	Arnaud Ferraris <arnaud.ferraris@collabora.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 279/567] usb: roles: get usb role switch from parent only for usb-b-connector
Date: Mon, 23 Mar 2026 14:43:19 +0100
Message-ID: <20260323134540.733017507@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 8345b1539faa49fcf9c9439c3cbd97dac6eca171 upstream.

usb_role_switch_is_parent() was walking up to the parent node and checking
for the "usb-role-switch" property regardless of the type of the passed
fwnode. This could cause unrelated device nodes to be probed as potential
role switch parent, leading to spurious matches and "-EPROBE_DEFER" being
returned infinitely.

Till now only Type-B connector node will have a parent node which may
present "usb-role-switch" property and register the role switch device.
For Type-C connector node, its parent node will always be a Type-C chip
device which will never register the role switch device. However, it may
still present a non-boolean "usb-role-switch = <&usb_controller>" property
for historical compatibility.

So restrict the helper to only operate on Type-B connector when attempting
to get the role switch from parent node.

Fixes: 6fadd72943b8 ("usb: roles: get usb-role-switch from parent")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Tested-by: Arnaud Ferraris <arnaud.ferraris@collabora.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260309074313.2809867-3-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -110,9 +110,14 @@ static void *usb_role_switch_match(const
 static struct usb_role_switch *
 usb_role_switch_is_parent(struct fwnode_handle *fwnode)
 {
-	struct fwnode_handle *parent = fwnode_get_parent(fwnode);
+	struct fwnode_handle *parent;
 	struct device *dev;
 
+	if (!fwnode_device_is_compatible(fwnode, "usb-b-connector"))
+		return NULL;
+
+	parent = fwnode_get_parent(fwnode);
+
 	if (!fwnode_property_present(parent, "usb-role-switch")) {
 		fwnode_handle_put(parent);
 		return NULL;


