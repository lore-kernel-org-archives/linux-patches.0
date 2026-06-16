Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A1C2C0261;
	Tue, 16 Jun 2026 18:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635725; cv=none; b=kSgRjfchMoWdHJbl1klFCji1k3zBeRBYAUUrpJIk1tgUXdA0CO40JobukXXyJNjmaPN/NPUZZV9MyLhx8qyTKBu26Rgo2u9Chq+q2a+ZRq/H9tkP0kf1eN7lfzUlqO9u02WrY1bxF4qec9fWYha2yFj3k/dYud38XZGdquQxEn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635725; c=relaxed/simple;
	bh=ug4WcTcMYjwhNWDv/CKyS9FeK3KNtNRHbU+HX9EiqvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZonSzEdDNmXd+wKYfAbzP+k9O15DeqKA0FgxOTw7nXo0Z2rV/5+NTZRtKDyRUTJaAmHBv4DPE89xsc3eKpuUgzpTUKc1h/PybmIh9szFM7rhUqh/B0LJvJeYvZux/jakQkSMU6/Sf9HyrZQlashWChOfLHBa7byMpEyOqJBlJZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sx/UgXDO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sx/UgXDO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D628F1F000E9;
	Tue, 16 Jun 2026 18:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635724;
	bh=JFVRgljtMcpg9b6F+MSRISwJGhi1jEw3xXRtJaqeA9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sx/UgXDOJcAlJQ4ysRQkOHNp4Gx/DLMpOq0rZAu5wAkbYRv5MHG0XiCKeoJj5s8/A
	 7GzlETX2nqkOVInlZy0mmYpY/zL8tfau93MEoqNZtvuOdd5XNrSGdgLnnvue91yl1U
	 k/Fhabz/Q0eNNkOiXvGrnaVYlPmseooAiAnxDs2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 104/342] usb: gadget: net2280: Fix double free in probe error path
Date: Tue, 16 Jun 2026 20:26:40 +0530
Message-ID: <20260616145053.079163820@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit c8547c74988e0b5f4cbb1b895e2a57aae084f070 upstream.

usb_initialize_gadget() installs gadget_release() as the release
callback for the embedded gadget device.  The struct net2280 instance is
therefore released through gadget_release() when the gadget device's last
reference is dropped.

The probe error path calls net2280_remove(), which tears down the
partially initialized device and drops the gadget reference with
usb_put_gadget().  Calling kfree(dev) afterwards can free the same object
again.

Drop the explicit kfree() and let the gadget device release callback
handle the final free.  This issue was found by a static analysis tool
I am developing.

Fixes: f770fbec4165 ("USB: UDC: net2280: Fix memory leaks")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260427153651.337846-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/net2280.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3783,10 +3783,8 @@ static int net2280_probe(struct pci_dev
 	return 0;
 
 done:
-	if (dev) {
+	if (dev)
 		net2280_remove(pdev);
-		kfree(dev);
-	}
 	return retval;
 }
 


