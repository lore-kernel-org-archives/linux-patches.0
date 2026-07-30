Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494E939C00E;
	Thu, 30 Jul 2026 15:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424557; cv=none; b=YgWPa6fc2HdPeYB3FgqHOwmAcYaSqNppCn8B4VAXgTdo6FSmJZX7ghR0FzqmqsnqHj6/s9hV68ywd+mZNOBKmVgYcf+9E60qYBcARl22p1AVWt6z23ygmpZ3Qso5nL/YagF08prXm1AW4B3q6xFw/CO6TYZSyhgPhj7UFzET5aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424557; c=relaxed/simple;
	bh=HqLAl4GdVI5cp24mLq10iiX8AGxO3j8OPKtV9R7xVyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lw9wREszG9UXr1gCIBdjKmPsgEiffZvGlkPfT/cFryNzQbtWS1WeiiaL16txnGBbEXQ30qRhSqM9LWTe5PfdnD7bfrtMWmWVxoA0baaaEsNUk2tS6LA24RHtbyp6MgmtjDnakvKHjRM+eF6inquAQxDbEmxMW6ZkFgjjDkJptxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHbTRtgl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHbTRtgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F2D1F000E9;
	Thu, 30 Jul 2026 15:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424555;
	bh=j3ZYpGLfeB8f2kP0Awgn/JA0MTegot4wawVnvD90EV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MHbTRtglmSdGfezPWysq2f7qHng2WULJnW8OtwUf/BnGhyLi1D47CHoII/esLJf16
	 rSqabzCESzTtcw4oLnyqurAQssWnHyxiGxyXWaQI3sojbihOiDn5H5QD9IVMnzwaxr
	 aYigBSqmY8B5EqI0ZB8LJ5TiqMZ+wOP4CwGboqTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 435/675] media: v4l2-ctrls-request: add NULL check in v4l2_ctrl_request_complete()
Date: Thu, 30 Jul 2026 16:12:45 +0200
Message-ID: <20260730141454.386851808@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

commit caced3578bf9f104a4aaad8f46c4c719e705d9a6 upstream.

If CONFIG_MEDIA_CONTROLLER is undefined, media_request_object_find() will
always return NULL, so its 2nd call in v4l2_ctrl_request_complete() would
fail as well as the 1st one and thus cause hdl to have a wrong value (at
the top of memory) and list_for_each_entry() to iterate over the garbage
data located there. Add NULL check for the 2nd call and place the error
cleanup at the end of v4l2_ctrl_request_complete()...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: c3bf5129f339 ("media: v4l2-ctrls: always copy the controls on completion")
Cc: stable@vger.kernel.org
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-request.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls-request.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-request.c
@@ -348,13 +348,12 @@ void v4l2_ctrl_request_complete(struct m
 		ret = v4l2_ctrl_handler_init(hdl, (main_hdl->nr_of_buckets - 1) * 8);
 		if (!ret)
 			ret = v4l2_ctrl_request_bind(req, hdl, main_hdl);
-		if (ret) {
-			v4l2_ctrl_handler_free(hdl);
-			kfree(hdl);
-			return;
-		}
+		if (ret)
+			goto error;
 		hdl->request_is_queued = true;
 		obj = media_request_object_find(req, &req_ops, main_hdl);
+		if (!obj)
+			goto error;
 	}
 	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
 
@@ -389,6 +388,11 @@ void v4l2_ctrl_request_complete(struct m
 	mutex_unlock(main_hdl->lock);
 	media_request_object_complete(obj);
 	media_request_object_put(obj);
+	return;
+
+error:
+	v4l2_ctrl_handler_free(hdl);
+	kfree(hdl);
 }
 EXPORT_SYMBOL(v4l2_ctrl_request_complete);
 


