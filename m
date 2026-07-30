Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5A2374E41;
	Thu, 30 Jul 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422781; cv=none; b=gto7XHzR4B2R393mmP/ng5KfFtQIoEhvp/NPvjn8sHeqbtqzRW5AABh+/l7IyH34w1vt/YBSoyCikUlLTIVORZxWllDyq/yGROGWaN/46yXQA36vTiVhSNHl6GXrNwnn1jZrgZvhwOP/qdBKHRlOUPlpXC7SQ5+mh6U7iVWcYb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422781; c=relaxed/simple;
	bh=4KBajwJeadJ6mOk0O2jxXkxHbc5wWV/hIfQv9dNqU9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LS/aJok98Ik7D6aZ6LSPdT25IbEhJ/v8EBqo+0Rs7gWoIGp/Zo/StLuWJpw8N6Z1O+9Hntma4h19NxWt7n47p5F9R6gMm2HTW4zQeMCdkqmsZjRn1NFWr2pBQg8iDaa8thpuFjZwBi/08mxVNnUy6e9/vGA715mIFB/AuNyiPUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+iKNtEL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+iKNtEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029021F00A3A;
	Thu, 30 Jul 2026 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422780;
	bh=YIKGwk/Ikf4quGz3Qjhl65BguDQK6A5eLGIKS7+dL4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+iKNtELYjvduReGLqxx4OMwJC0DVrbBSPhB8yumpJMuTiqZzd3Haw/huQ3giCkrI
	 YSb+++cN32pxSvmc4TWVGgQXIBPFq6yu4E/+4lJ/hH52JqMRGII8lq6QH14MTxth9g
	 LPqhFE6gs4BD0me7+8y2Ja65/A1O5Kpm5PpjL+JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 510/744] media: radio-si476x: Unregister v4l2_device on probe failure
Date: Thu, 30 Jul 2026 16:13:03 +0200
Message-ID: <20260730141455.120412501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit 436a693af04ffb889aaf87cb69ec1f2b21d3569c upstream.

si476x_radio_probe() registers radio->v4l2dev before allocating the V4L2
controls and before registering the video device. If any of those later
steps fails, probe returns through the exit label after freeing only the
control handler.

A failed probe does not call si476x_radio_remove(), so the
v4l2_device_unregister() there is not reached. This leaves the parent
device reference taken by v4l2_device_register() behind on the error path.

Unregister the V4L2 device in the probe error path after freeing the
controls.

Fixes: b879a9c2a755 ("[media] v4l2: Add a V4L2 driver for SI476X MFD")
Cc: stable@vger.kernel.org
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/radio/radio-si476x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1493,6 +1493,7 @@ static int si476x_radio_probe(struct pla
 	return 0;
 exit:
 	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
+	v4l2_device_unregister(&radio->v4l2dev);
 	return rval;
 }
 


