Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AE315442C;
	Thu,  3 Jul 2025 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555269; cv=none; b=j7rC1AWeHRTyM/t0O5hxp0GjZL49099zfK95Nn8sEih+VzQuqKukEbzOqwJwMKwXbVugCKTyjVCu9Ti3YE4nFr9qnvsr+5JR/5qU6/PI4FddMm+x6nTyM6hysw/pB60VstPwfC1+8KbrNsDqmsLhRgZ6uk7G+vC0pYgsrCoamQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555269; c=relaxed/simple;
	bh=WivRzcDGzKCtrV+QKKV4v2jKbhQ6p33MMXyqCI8b8K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ini0rpbgkdCXSU2fdKevTTgjbcpgqlnlet3TaBxj6mZDQiOVrrTRmHOM/g3IHdpj/0XR3Lo8dvkaLGpwrgfAZ61UzJ0Al5PNnnVgsUBmeOx2pO7g3EOOGMFmcu0Wer/flBYk/8QX8a8uXRijR4Nr86wSKes3oLHaMWKUENr+FTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqBEJAt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqBEJAt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62016C4CEE3;
	Thu,  3 Jul 2025 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555268;
	bh=WivRzcDGzKCtrV+QKKV4v2jKbhQ6p33MMXyqCI8b8K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqBEJAt2H0/tDxVkguPARSsjT777xNLIJh0StX1ioolWbDAXG2xGFFc+fIC6yOUt1
	 AyMoPJ8RV8p2BkztXSY3XHKVVWp7T5rdqJ8PQeTukns87C7CE8DJ/oFsyRo5LxEKCo
	 AbS9JIdf7sjNgHKe5x3GQ/59m6ktaz0QfgdV7+yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.15 195/263] HID: wacom: fix memory leak on kobject creation failure
Date: Thu,  3 Jul 2025 16:41:55 +0200
Message-ID: <20250703144012.176856621@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

commit 5ae416c5b1e2e816aee7b3fc8347adf70afabb4c upstream.

During wacom_initialize_remotes() a fifo buffer is allocated
with kfifo_alloc() and later a cleanup action is registered
during devm_add_action_or_reset() to clean it up.

However if the code fails to create a kobject and register it
with sysfs the code simply returns -ENOMEM before the cleanup
action is registered leading to a memory leak.

Fix this by ensuring the fifo is freed when the kobject creation
and registration process fails.

Fixes: 83e6b40e2de6 ("HID: wacom: EKR: have the wacom resources dynamically allocated")
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2048,8 +2048,10 @@ static int wacom_initialize_remotes(stru
 
 	remote->remote_dir = kobject_create_and_add("wacom_remote",
 						    &wacom->hdev->dev.kobj);
-	if (!remote->remote_dir)
+	if (!remote->remote_dir) {
+		kfifo_free(&remote->remote_fifo);
 		return -ENOMEM;
+	}
 
 	error = sysfs_create_files(remote->remote_dir, remote_unpair_attrs);
 


