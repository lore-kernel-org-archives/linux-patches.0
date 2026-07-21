Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99008471435;
	Tue, 21 Jul 2026 20:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665373; cv=none; b=IRfNXdFNnj8xVvQa5qHTZlf7ilM5t51tc9xXw9uxbPGg9FMqz6d95081pJ5X1BMuqR9/L496FD+ceOEhWwY+vLum2CVZUPg+XbvhBVKCr7kb7Bj0e2PMN9+iitrPpLQ4d8VcTLd/boI5PHePr8e+VZrHe8fKhcYer76UhmooWCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665373; c=relaxed/simple;
	bh=T3iiR8yMUIG31HKhteGorRw3hP1MGkRt01y2PiF/jw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+RDexKiM5mJhu+RtYg9PMvFMqtCsTUftjUUDc+PxEXNcZiKgWJR9gAEW4NDLOBUQ1lX/ZrndzdxGFIFPia6ueJA1wgQ+F9YbPaieJNvXC1qNwn6Y3R00a2LjgnNzO6g5lHyMexGpesZgJJiq3HRANK4zC+Vqz+9WCGy7GePl8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKWpQ6qT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKWpQ6qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9161F000E9;
	Tue, 21 Jul 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665371;
	bh=J67/Nf1RtShjAmN2Uyx12rNwPVAASHTlpt96086ZEsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKWpQ6qTCZeWcoW7wQXXbu97iecLtJmvsM7eA8bm9tph0aTPuWdi5PaR4oPNiSsFD
	 X32mbLL/59rew/lD3ZHkfcEypghbYY76eaN4U5cq8d/jltf86MlUJWjgJZiDzF+Vhu
	 CY170Hu7lFGehC9qWHsF1HshP9MLGGSvq/q34JU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 0226/1266] usb: cdnsp: fix stream context array leak in cdnsp_alloc_stream_info()
Date: Tue, 21 Jul 2026 17:11:03 +0200
Message-ID: <20260721152446.873774807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 3348f444a4ce43dd5c2d1aa41634cb6eff33aa64 upstream.

cdnsp_alloc_stream_info() allocates stream_info->stream_ctx_array with
cdnsp_alloc_stream_ctx(). If a later stream ring allocation or stream
mapping update fails, the error path frees the allocated stream rings
and stream_rings array, but leaves stream_ctx_array allocated.

Free the stream context array before falling through to the stream_rings
cleanup path.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260622052627.696373-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-mem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-mem.c
+++ b/drivers/usb/cdns3/cdnsp-mem.c
@@ -632,6 +632,8 @@ cleanup_rings:
 		}
 	}
 
+	cdnsp_free_stream_ctx(pdev, pep);
+
 cleanup_stream_rings:
 	kfree(pep->stream_info.stream_rings);
 


