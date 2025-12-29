Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6F924EF8C;
	Mon, 29 Dec 2025 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025642; cv=none; b=UAsDTYZjmw2aqbyWZjE1QbZQkergc0wRYdFNOfVzs8Cqn/vHeBFZA10J1PLohgx7O6j3XoWUa/S/dW9T0Ev05FLRWDOg34iRmaECRXuLxLz9HC60DXQ1cT51QYnP/myzbZ4/0i5zn77QbXye1RKcTRu7gZXj9ux6UqtJuS81jzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025642; c=relaxed/simple;
	bh=oAD7nQs1YFsVNJuzZZg8+UTKCE3ExA3vsSPuWuOf1ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFxnlboXLSxTP9hm3x2zujZ1F3OlgntuxXYmu6KqbIfvA56HURU0mtSEcdokgycdrOq4+D2l+efgNRg71q2LYYpWhGlLOkZ0XNyeV/+bJ4WABSY+dhFQMATluOzhoNP1xqTLZmIjlFm6YjoeDSSPZs6ly4v7Mf/PlDpJ4yInjLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZT99k0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZT99k0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C66BC4CEF7;
	Mon, 29 Dec 2025 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025642;
	bh=oAD7nQs1YFsVNJuzZZg8+UTKCE3ExA3vsSPuWuOf1ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZT99k0jftjPjhH03coiKAmrIgPFh+4AtgXOzCX6felPocAqfl/td34IYGZJxFdDV
	 VPpR7qQ/O2cI8Vz1TfSVeinYFYetJjVdSrOVZbxzTjPVQRZMryct0s5Nf3+9is8mpv
	 +7KOoJ0Nko4VJhs54LUxIpp+NDPBiNveuu+s/uyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.18 286/430] usb: typec: altmodes/displayport: Drop the device reference in dp_altmode_probe()
Date: Mon, 29 Dec 2025 17:11:28 +0100
Message-ID: <20251229160734.871223404@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 128bb7fab342546352603bde8b49ff54e3af0529 upstream.

In error paths, call typec_altmode_put_plug() to drop the device reference
obtained by typec_altmode_get_plug().

Fixes: 71ba4fe56656 ("usb: typec: altmodes/displayport: add SOP' support")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20251206070445.190770-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -764,12 +764,16 @@ int dp_altmode_probe(struct typec_altmod
 	if (!(DP_CAP_PIN_ASSIGN_DFP_D(port->vdo) &
 	      DP_CAP_PIN_ASSIGN_UFP_D(alt->vdo)) &&
 	    !(DP_CAP_PIN_ASSIGN_UFP_D(port->vdo) &
-	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo)))
+	      DP_CAP_PIN_ASSIGN_DFP_D(alt->vdo))) {
+		typec_altmode_put_plug(plug);
 		return -ENODEV;
+	}
 
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
-	if (!dp)
+	if (!dp) {
+		typec_altmode_put_plug(plug);
 		return -ENOMEM;
+	}
 
 	INIT_WORK(&dp->work, dp_altmode_work);
 	mutex_init(&dp->lock);


