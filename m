Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C69831F9BC;
	Mon, 13 Apr 2026 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099292; cv=none; b=pxwZF2sg/CCSiNt10CWXMPGtF96jMj6S6m7c2IwLrSo/tRdHNJp64gRCBoz4ndoEHV/9Q0aDZK4bdG9gbE71Q21a3y6Q0+5MLywpUX/JVPpMNaaEOW/jSsZQNowL0c1CvJWs/j/SlGyluJRTtzLRi/tXeHOn+OfXJXpgTqptv6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099292; c=relaxed/simple;
	bh=u+J+3ylq2pVVQqoz42+Uw6zzSnCdqoOTQfhXAAqHnqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tj1JUDmaS7F/AXqX1mnT7ARjz69P/ssaf3Bj3Hy0rghDxmhkeKp8GSl/ws77hu9eLErI4ssbCDnIcADG3nmA7svDZ1MjTJm1hbVSYDxvYVR53UQVTMGM0CNBCUwPqKRwSzkE+hhE6QPoB30yrnLkAO7rbDJbG/UQHtuRB4vl6og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkFEBHO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkFEBHO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1573BC2BCB0;
	Mon, 13 Apr 2026 16:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099292;
	bh=u+J+3ylq2pVVQqoz42+Uw6zzSnCdqoOTQfhXAAqHnqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkFEBHO53nc3zc2r+KQNQ9qvKiwoC7ii5qGXbcDOklVy7TuUucD+rbuELYxpKKO5c
	 9miXKjKOccXMEGA6fecNW+JzN1SDDy1FGMSZlY7BXjxYiD73CscTWhyZEBIS0z3kTL
	 qWKfAVrn1mtfzbaYmxlWcrdWLexQPMQQdaQjJ6rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Anas Iqbal <mohd.abd.6602@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/491] Bluetooth: hci_ll: Fix firmware leak on error path
Date: Mon, 13 Apr 2026 17:58:18 +0200
Message-ID: <20260413155828.525720905@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anas Iqbal <mohd.abd.6602@gmail.com>

[ Upstream commit 31148a7be723aa9f2e8fbd62424825ab8d577973 ]

Smatch reports:

drivers/bluetooth/hci_ll.c:587 download_firmware() warn:
'fw' from request_firmware() not released on lines: 544.

In download_firmware(), if request_firmware() succeeds but the returned
firmware content is invalid (no data or zero size), the function returns
without releasing the firmware, resulting in a resource leak.

Fix this by calling release_firmware() before returning when
request_firmware() succeeded but the firmware content is invalid.

Fixes: 371805522f87 ("bluetooth: hci_uart: add LL protocol serdev driver support")
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Anas Iqbal <mohd.abd.6602@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
index 7495ca34c9e7e..ee107360e3bc2 100644
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -541,6 +541,8 @@ static int download_firmware(struct ll_device *lldev)
 	if (err || !fw->data || !fw->size) {
 		bt_dev_err(lldev->hu.hdev, "request_firmware failed(errno %d) for %s",
 			   err, bts_scr_name);
+		if (!err)
+			release_firmware(fw);
 		return -EINVAL;
 	}
 	ptr = (void *)fw->data;
-- 
2.51.0



