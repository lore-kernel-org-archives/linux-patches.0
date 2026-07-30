Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EBE40DFC6;
	Thu, 30 Jul 2026 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424521; cv=none; b=U4uq0tShhSirrgupgVyUlC/Hhr71ZXs2MNMvNWZ4J4F7ZwDTE4FjZaTqxTDt86V8ktuQEmTVWoW1NqqPsxrwtnUGgGDwhivaVbcJixdMHshE+NQ9tSjjMc2B9ZunXUFXPWYcywcwokgDqau2F+/ggJkmZVo+3SZ80/V3iHVPEf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424521; c=relaxed/simple;
	bh=zazX5j48N8D9yXfZZ8ASUhoHfvv4CRfpvBBhGvoscc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQJHMBlDml1aqoDLdeIkX6h5Xabi+cR4YRng/7C3yKAcYdPOPXZYg7Uxf1Bjg/0u8+SyRbQsMvwNuZMrMW8BPtsXi4TngS7XPA71oeQGBNw144COb3hyLDDUbF/d8OPsTWJTkdU8STIftt9YgrErtYte4BI2/FbfRmok26M0/PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GRBoCx+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GRBoCx+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E031F000E9;
	Thu, 30 Jul 2026 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424520;
	bh=XTp9bLb9gRXgjApBjWFIwijIQvGCWSa9Yq/QR4pf+FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRBoCx+z9AtzvaP2bFA5+FtlXkUIT3sWtT8jzbBI3XeX6So2CjHBtPhQbkMr1ID7i
	 OPejIlcwzhYhPfxFoy1ZtLbtXRC6HuFTxZoxypm2eGRWXUnRMNDerWUM9HpEbv+k2A
	 E1sBnEcYpUqPTvyo5nJQPOZDgbZn8Gim6YDWIUC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 424/675] media: radio-si476x: Unregister v4l2_device on probe failure
Date: Thu, 30 Jul 2026 16:12:34 +0200
Message-ID: <20260730141454.145041159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
 


