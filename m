Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC1F4AE10E;
	Mon, 31 Aug 2026 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184115; cv=none; b=E4+WfQc5Jh/6RtSwi/kviCw3hq7Jz5mb3nllQ+t3YIKVyjjCxRtk6+kRmBKGRwDeKUg7VJ7P8OffRlKCpY5+4W+YKZ/MKhBXlc6yqSGzq7PyVSU6TmBs5ctTaCFZcE2nADNgvXcCXNaSCJG6YplKqc/BGLO1u/0xsryDvD6wHEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184115; c=relaxed/simple;
	bh=srUIoQhvcstl0fiz4NTf9nZhUT0FwE9pL/BeNCKMjvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8OGS7FjJzRJ9CoZOnEHrxwbDhGcErEkH3viPs6DPUEgXllv5FrHREwvvRAVVB6fkjamOZT2ekCDvRMJBAXyM7x2amWysImBE0/YKKNO6oFNNIEK30b4Hi1e2MwZZHirmotLf2rn00lJVuhwe5+DmyZwMhhMFImNuOhAOFjbL/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBSIq9fr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBSIq9fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23B61F00A3E;
	Mon, 31 Aug 2026 13:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184113;
	bh=e4vSOiEFAf7PfriwbRa5Q5hv0Ft2uLPvdHc3L7XtcLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jBSIq9frrwSIzioyG+9ahQ61YDgSBN0uAhw+RlQxvu4SSC8/4Wep22/AykvwcKgiu
	 hYv1GfkGIhvGbwlKWeJvDQopoXCeynW6pRAMJsFV0gJLnsPUNu4MpS/YF+UjtYu+1I
	 pGSa3/VBBP+bi5OXLHw7obCYSMQwcAzBY5tkNBZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.18 76/83] usb: core: Strengthen error handling in hub_hub_status()
Date: Mon, 31 Aug 2026 15:34:52 +0200
Message-ID: <20260831133403.300821721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit a29496745aa335d97f617385809583241e118610 upstream.

Add additional error handling after the call to get_hub_status() in
hub_hub_status().

get_hub_status() uses usb_control_msg() which does not verify that the
message is the correct length, substituting it for
usb_control_msg_recv() would also solve this issue but increase memory
allocations.

Instead, error handling is copied from the method used in
hub_ext_port_status(), which shares the same flow of logic as
hub_hub_status().

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260722-usb_core_patches_2-v3-1-87622252bfdd@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -998,10 +998,12 @@ static int hub_hub_status(struct usb_hub
 
 	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
-	if (ret < 0) {
+	if (ret < (int)sizeof(hub->status->hub)) {
 		if (ret != -ENODEV)
 			dev_err(hub->intfdev,
 				"%s failed (err = %d)\n", __func__, ret);
+		if (ret >= 0)
+			ret = -EIO;
 	} else {
 		*status = le16_to_cpu(hub->status->hub.wHubStatus);
 		*change = le16_to_cpu(hub->status->hub.wHubChange);


