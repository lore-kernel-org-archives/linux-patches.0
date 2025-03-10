Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05629233731;
	Mon, 10 Mar 2025 18:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630991; cv=none; b=V6+Nbd6qRZ7BIaNpMORxj1FrdYjsBoWa5tAV46dLnZJZ7TMMM/RJ1+E7yDowazOGp/WO0gxVK6qWivGSTqSZfXakexMm69LBiHCXF+ziMsdWBVY0zvllqWo4wWWeUzbGuJPfBgCuWru0NJxVgKm+KA4EW+Lv0Olw+6lBnR6THrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630991; c=relaxed/simple;
	bh=fSzGna09vle9xCkZImX/gQafz9FNaKcKOzE2TcDD+so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkjrn3WSDMD9DhHsmGkp3nUeFpQjjO7wfGXuiLeMYcfdxjRrvauRUue/kW4UHqta7jJif7B3CCKouQf1H/3/XOwKRYeybBjeVTKC8LXA6AFN3DXUWR3DqiSM0zIKV8mW9U0Uk8KDxzxWyAB/oMWv0qvqzMhy/+vXAt48pice2TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g15rkTL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g15rkTL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D252C4CEE5;
	Mon, 10 Mar 2025 18:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630990;
	bh=fSzGna09vle9xCkZImX/gQafz9FNaKcKOzE2TcDD+so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g15rkTL4VBhQK2WXRJxjTfjnWSxtL6axJDYPNbwAQ8+l238Hh5CqS4q4G4n5fEvT9
	 GVWy8+3pND22BfJ3fRpHAL+voHrv/dFeoOxe4IDVp0oM8uMZ50E/z6PyBEpH40YB8U
	 igiZX1XNM8v4rtXi06zGqF0WwowwyZf5GkVCgYUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 605/620] media: uvcvideo: Avoid invalid memory access
Date: Mon, 10 Mar 2025 18:07:31 +0100
Message-ID: <20250310170609.413763159@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit f0577b1b6394f954903fcc67e12fe9e7001dafd6 upstream.

If mappings points to an invalid memory, we will be invalid accessing
it. Solve it by initializing the value of the variable mapping and by
changing the order in the conditional statement (to avoid accessing
mapping->id if not needed).

Fix:
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN NOPTI

Fixes: 6350d6a4ed487 ("media: uvcvideo: Set error_idx during ctrl_commit errors")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1708,7 +1708,7 @@ static int uvc_ctrl_find_ctrl_idx(struct
 				  struct v4l2_ext_controls *ctrls,
 				  struct uvc_control *uvc_control)
 {
-	struct uvc_control_mapping *mapping;
+	struct uvc_control_mapping *mapping = NULL;
 	struct uvc_control *ctrl_found;
 	unsigned int i;
 


