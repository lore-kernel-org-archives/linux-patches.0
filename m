Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF382045B5;
	Tue,  8 Jul 2025 16:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993146; cv=none; b=sgfvK+U3fMEWvgNlKV+2g18oYwK5RULVYC1zINWAAycsar4wG7TPG50cCGWIoAbFiFdxi/YQSe9C13EXZEHbES272DZbVMrcTa3kJ1jcjPXGRongPBcPjbN9EtW4aW5/TeX8oxDJ8QuvqpMa/ywIQIfJNsNV8QVYViruxCKs9SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993146; c=relaxed/simple;
	bh=ANpm4ovYunBBwlPqLY6vGAR8hQwPeqipfyBe5LtNpTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnblOCgSzcNc9+hNM7ejpqtXluoArXSsdFh9f4z99lJ1/4yncNQjQdg2tSN60B4Xa/387pFtHY864XZ/PzJRPq1lBrCBKVHq45wVupY3FLrBRZl9q4ov0XMnsePJU0BAarJgj/vfkyVUhSUJS2rqQ5MfdtYVmXvQ8OhALeYXyNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCbJmkQX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCbJmkQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFB3C4CEED;
	Tue,  8 Jul 2025 16:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993146;
	bh=ANpm4ovYunBBwlPqLY6vGAR8hQwPeqipfyBe5LtNpTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCbJmkQXjDjGC10gLbf04Y61NhS9KyHXiE0nIcfcfBO0LpeesHyUL2hjXSMgT6WDH
	 otRgzgrhZw+YGHuTQHBKtte3AvbKHZcV8P0e/bsIs8h2GYBKWLnmj4uuLhjmbJQW+n
	 8dIH9qTnsEaEZMieCAd3jlDws3Pw7xKzJW+2wL4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongyu Xie <xiehongyu1@kylinos.cn>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 6.12 204/232] xhci: Disable stream for xHC controller with XHCI_BROKEN_STREAMS
Date: Tue,  8 Jul 2025 18:23:20 +0200
Message-ID: <20250708162246.776325976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Hongyu Xie <xiehongyu1@kylinos.cn>

commit cd65ee81240e8bc3c3119b46db7f60c80864b90b upstream.

Disable stream for platform xHC controller with broken stream.

Fixes: 14aec589327a6 ("storage: accept some UAS devices if streams are unavailable")
Cc: stable <stable@kernel.org>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20250627144127.3889714-3-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -326,7 +326,8 @@ int xhci_plat_probe(struct platform_devi
 	}
 
 	usb3_hcd = xhci_get_usb3_hcd(xhci);
-	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (usb3_hcd && HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		usb3_hcd->can_do_streams = 1;
 
 	if (xhci->shared_hcd) {


