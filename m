Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C0E1DFE3A;
	Wed,  6 Nov 2024 13:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899225; cv=none; b=ZihWKIJV3SvEMmIxU6KzR+meAQQqXdCvAkHr+t9mx7MirTeerXpJNIMAjJgg+xihvcjIMUwpaoxfBi6yeGQNG+1n0L6JiVdyqtpKHaQPg7mJUlUuRddLVszeXndE6AcljTDnTSGi2it+preffEf8lIvV1k5gTVdAPYTaaGSIxaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899225; c=relaxed/simple;
	bh=lFDYbLToVFfKe3gwvjG7bzo1jbHK8rzUbJd1fMauEp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAOWIV729W1g/vy1wLPWCUGfd9DgvgU5/Kkk106fGg6nQhpHJ8j5hmFlPu2ni5uFO2HudN8HHdZvG2dDKbyJbWtsCFURjBDg+S+yUkP04BmqqT5pAWgLftj4HbkRs6zyQlwf3xiaGcM+LEUABnXei+9vasp9P+Zr0/WIuzyj9sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEpIDYaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEpIDYaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DE0C4CECD;
	Wed,  6 Nov 2024 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899224;
	bh=lFDYbLToVFfKe3gwvjG7bzo1jbHK8rzUbJd1fMauEp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEpIDYaY/rqPwvsfgwTHto8qiMrfQokK3QtoW6R8Z0Vp/j6zaYxIU7wPuhwODQNyD
	 FCmPshbWaREuydd1ywFoniTblRjd+E6M6bv+Y8F3mouePKbVLX8O0rCC4LtBqcWuMl
	 BH5+ndlkBa714v4Zy2wbRCkjsD31JbIf94Ig84bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>
Subject: [PATCH 5.15 40/73] usb: typec: fix unreleased fwnode_handle in typec_port_register_altmodes()
Date: Wed,  6 Nov 2024 13:05:44 +0100
Message-ID: <20241106120301.158331166@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 9581acb91eaf5bbe70086bbb6fca808220d358ba upstream.

The 'altmodes_node' fwnode_handle is never released after it is no
longer required, which leaks the resource.

Add the required call to fwnode_handle_put() when 'altmodes_node' is no
longer required.

Cc: stable@vger.kernel.org
Fixes: 7b458a4c5d73 ("usb: typec: Add typec_port_register_altmodes()")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241021-typec-class-fwnode_handle_put-v2-1-3281225d3d27@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -2026,6 +2026,7 @@ void typec_port_register_altmodes(struct
 		altmodes[index] = alt;
 		index++;
 	}
+	fwnode_handle_put(altmodes_node);
 }
 EXPORT_SYMBOL_GPL(typec_port_register_altmodes);
 


