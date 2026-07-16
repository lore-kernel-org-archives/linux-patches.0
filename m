Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A66E424D5C;
	Thu, 16 Jul 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211094; cv=none; b=EkhWNt+A7+Z48zc+2fcWrr3LOzqJXERm8ZMgyYEhRDepc9ZMzCPRKzD0SRO+EBlP9NkE4qBjQJZv/m5ZvQ3Ab64JknQT/1lteZInZ01A6RmI7PHWraqNKenUsFzkdoKUwDYjKFmSU9npzg8dHly5H6gtCrZoKK4yNNueNTprJG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211094; c=relaxed/simple;
	bh=oMkshhEpcglEQwtQ/oo83Pp6I5I9PdZyzD4Sk1AyTQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hmjRsjXBuFSKIRk0vLSh1owjh8Ow0hD8noDbluvYah8/S3TPRk/5lmF3cunVN+g4dr2yxlzbsPGj44eCGdEz59BozIjJrQHXVUa0lXab2Mt/qirRgwya3mV9IqRMqHm8zW14ze2sbfceo3J06E/a+xwMBjF7DkelsBHfFl1qWis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZrsqgvc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZrsqgvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A47E1F000E9;
	Thu, 16 Jul 2026 14:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211093;
	bh=xI3kjmImVM9juqqp5MtIMuqRJINgpzQbkf/LbGPstdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oZrsqgvcFOLzO8gQVdj53X6FhAVPKaCsuT6cQk0qsw9M+BhU89/aCnRBj9asJcix6
	 vUXlb/FR6lfE7+zIORG77XzN4QK/MTnNgWwEZg8GPvuaI7uIhr+OqZ65P9crHpdyvL
	 luAbu2o3g7FgWe6xh9raHUbFtIzKZZU2w8ddbvng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 6.18 297/480] usb: sl811-hcd: disable controller wakeup on remove
Date: Thu, 16 Jul 2026 15:30:44 +0200
Message-ID: <20260716133051.244178076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit 4e8ba83ac4d311992e6a4c21de5dd705010df06e upstream.

sl811h_probe() enables the HCD controller device as a wakeup source after
usb_add_hcd() succeeds, but sl811h_remove() removes the HCD and releases
the driver resources without disabling that wakeup source.

Disable controller wakeup after usb_remove_hcd() and before usb_put_hcd()
so the wakeup source object is detached while the controller device pointer
is still available.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 3c9740a117d4 ("usb: hcd: move controller wakeup setting initialization to individual driver")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260701121625.96815-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/sl811-hcd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1591,6 +1591,7 @@ sl811h_remove(struct platform_device *de
 
 	remove_debug_file(sl811);
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 
 	/* some platforms may use IORESOURCE_IO */
 	res = platform_get_resource(dev, IORESOURCE_MEM, 1);


