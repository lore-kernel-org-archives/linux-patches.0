Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BABB1C173C;
	Mon, 12 May 2025 17:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072090; cv=none; b=YUSPV21AK3sqGelO7Jx3anwQ+iSt0yqdJVGzyxNONrair4gjC1ARK6s0v2DY3JFOnXMAO/OwqVF31NaKQTbYMJLfjhodKXBhRlVmZQcJoNHl0xIxIlv9H6yDWaLwEHXYDl8zjohASGXUz9U9u+OuvCzs8MECrFKNpjJBh1aeet4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072090; c=relaxed/simple;
	bh=sX7FXZoFgRJ4OoltDmCMMibIKZz3NMTZ0ORnXQcZzxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ+iT3+hQB1B1rylTcYe44T1T80yurcMkJkVUCkZx92CQMD2ISG2wiyyzA7fsLS8Fe7W1rDuLvkxRYs5U2fIYPdc5nDIZGXERYe9Ig2pPUXeU64evDF6XdzO3PeHxtxZ3V3/ZKR4kRSGOo20+sy/0I77dwXAi9nzqLxiVDHFbcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtJLTGT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtJLTGT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99C5C4CEE9;
	Mon, 12 May 2025 17:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072090;
	bh=sX7FXZoFgRJ4OoltDmCMMibIKZz3NMTZ0ORnXQcZzxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtJLTGT1YxkiyxIwePYxcViKeKdCDSQxphlRVL0jzw9Mys51gi6sAwAPRQA89GmJM
	 URuyEVtzbjZcWvH9V2DHjoS1GJpVENj8m2CNsIhv/1B4m1cAx+NM8FsU+Fx/ha5lf8
	 PN1qKG4J+VTKB28v+gDR5bjiKLwRWynBZc6nM/pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.14 137/197] usb: gadget: f_ecm: Add get_status callback
Date: Mon, 12 May 2025 19:39:47 +0200
Message-ID: <20250512172049.973828368@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 8e3820271c517ceb89ab7442656ba49fa23ee1d0 upstream.

When host sends GET_STATUS to ECM interface, handle the request
from the function driver. Since the interface is wakeup capable,
set the corresponding bit, and set RW bit if the function is
already armed for wakeup by the host.

Cc: stable <stable@kernel.org>
Fixes: 481c225c4802 ("usb: gadget: Handle function suspend feature selector")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20250422103231.1954387-2-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_ecm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/gadget/function/f_ecm.c
+++ b/drivers/usb/gadget/function/f_ecm.c
@@ -892,6 +892,12 @@ static void ecm_resume(struct usb_functi
 	gether_resume(&ecm->port);
 }
 
+static int ecm_get_status(struct usb_function *f)
+{
+	return (f->func_wakeup_armed ? USB_INTRF_STAT_FUNC_RW : 0) |
+		USB_INTRF_STAT_FUNC_RW_CAP;
+}
+
 static void ecm_free(struct usb_function *f)
 {
 	struct f_ecm *ecm;
@@ -960,6 +966,7 @@ static struct usb_function *ecm_alloc(st
 	ecm->port.func.disable = ecm_disable;
 	ecm->port.func.free_func = ecm_free;
 	ecm->port.func.suspend = ecm_suspend;
+	ecm->port.func.get_status = ecm_get_status;
 	ecm->port.func.resume = ecm_resume;
 
 	return &ecm->port.func;


