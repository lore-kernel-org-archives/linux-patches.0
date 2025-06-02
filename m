Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E1E22F16E;
	Mon,  2 Jun 2025 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874524; cv=none; b=re1QvhGyn7koC4Aj0ljR/FWBNxPiOuAqCrKQfyXkzrHvi6GkPqaGAy/JrR1bO5e/Gnn/aUY27/MjR7VxfQvuQgDsXpSVKS8+rIHfqCWZDHGQtQSmfa81P+9xbT1kYiTGs9caENAsXHbWM5rEUWLlzg9h5FDPTXsVD4PiJJCkZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874524; c=relaxed/simple;
	bh=FDGEkgaB3SeQZdx3SpuOqE00y5ELvvZnI9IhE8tR6I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwxpBvPVOFkHpnhtoIJc5jTKHHrfLx5X6KRwR/JnDKEc5UVPKAabts9NF1lxQQKcAulxrCOR9Vlkh5e7GCmDMmEPF7T9YC8019eNra3HOmqxOdSAgiOvkwbsswK96ppWeIVThOId5vbm3BYdoQrdKoU6AH6jso9DchdI0NatlZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbOrImIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbOrImIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A68C4CEEB;
	Mon,  2 Jun 2025 14:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874524;
	bh=FDGEkgaB3SeQZdx3SpuOqE00y5ELvvZnI9IhE8tR6I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbOrImInQ12EsHPl9n8IOzjLQo7qbZoPMwGjxHLj0OE2O1QYsFiQua/4KuMXM0wsE
	 +O/ogv6RKqCdQagwxiHMXyG+lcWloEVE5QUX1PrSLDIFh0q2uTH9lb1FscpOOJs/Ih
	 H+ISQE5rTVcnlHRA81mpBCPg3ZSqhcwJmcnjMlAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.4 052/204] usb: typec: ucsi: displayport: Fix NULL pointer access
Date: Mon,  2 Jun 2025 15:46:25 +0200
Message-ID: <20250602134257.729440986@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 312d79669e71283d05c05cc49a1a31e59e3d9e0e upstream.

This patch ensures that the UCSI driver waits for all pending tasks in the
ucsi_displayport_work workqueue to finish executing before proceeding with
the partner removal.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250424084429.3220757-3-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -272,6 +272,8 @@ void ucsi_displayport_remove_partner(str
 	if (!dp)
 		return;
 
+	cancel_work_sync(&dp->work);
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;


