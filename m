Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851192EB5BF;
	Thu,  3 Jul 2025 15:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555739; cv=none; b=gEKyF3XcCgUz4EGfycExQkYF1omq30NYABTwe9nBcwkljRlr61YSxd7hpeQ1v4bBask7vUmryC/VOUDLWuQlHQDtGv1yv8Fg5qR3t9PGeayi8LuXDvytg6kmH0Lbg/8xATEe3yy2CAhzntAM7/uRJg0v+8USkXLrFRz5nThreVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555739; c=relaxed/simple;
	bh=u7A1yjJvemc4ziPpnCu0JMSrWjwL2YslPUmOgH7JQHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBtG+FefoW7xkuu8orWWFctCYdjP8akBA8Gn+CEesvbvZVcycXMuE/NCXLfF+fO/bS8B/88r1xVUIdRg9KJMOPcB2e7yxzr8Vk4onpS/8WfsQ0IGK2kKGLOsfCg5Wvhr1I54kH0UnDogrSettVxwnI2gcYHda1HAa4wnTUJBw3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l50XR8o4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l50XR8o4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC065C4CEE3;
	Thu,  3 Jul 2025 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555739;
	bh=u7A1yjJvemc4ziPpnCu0JMSrWjwL2YslPUmOgH7JQHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l50XR8o4wF+rvT0kVTJwHDVuDyd64dNrYuQYO5jj201uB7QTbGpFc01UN9kHmqbZY
	 CbWBrZk2Yu80FAjaQEZ4WdSp039ElmkduycEN2IkFrQikQzysY6mDN6HqrekiteDrj
	 WJIc4DMQQvPXL+GQX7A7eFtT3u4p0mPKlLYa1Noc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 107/139] HID: wacom: fix kobject reference count leak
Date: Thu,  3 Jul 2025 16:42:50 +0200
Message-ID: <20250703143945.359972613@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 85a720f4337f0ddf1603c8b75a8f1ffbbe022ef9 upstream.

When sysfs_create_files() fails in wacom_initialize_remotes() the error
is returned and the cleanup action will not have been registered yet.

As a result the kobject???s refcount is never dropped, so the
kobject can never be freed leading to a reference leak.

Fix this by calling kobject_put() before returning.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Acked-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2023,6 +2023,7 @@ static int wacom_initialize_remotes(stru
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
 		kfifo_free(&remote->remote_fifo);
+		kobject_put(remote->remote_dir);
 		return error;
 	}
 


