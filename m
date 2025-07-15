Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9E62E7BDA;
	Tue, 15 Jul 2025 13:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586391; cv=none; b=dr5VtThOzhv49ygaHWLDmdygUKmq9omC8h7HS8ySWdyg5vXQO/JOC2rWLv3o3MxZb65gVGpuw0+YV3y7ADKjB9rQGAn+KUoN1Oz2WEGGmkGB3wg+DdQ5ZLQvqVYOF3PdAlkYY9Z8kq7tbbT5yOWNID4xK/5YaSI3cHCMgh/p158=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586391; c=relaxed/simple;
	bh=PWepeBMXzG2phsk2drzjU62zdAR+wmKE6QXZNLHa4Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/3Mm/f7pzS/m82dkExdC/FsQ8Y8eqtZOgEI8QxbZGIKwNV9Lp2B0shP4OBsn4F656DyTFPN9IgXcVnIILptF8mBSkRaRO8O3BifYKKiOreV9Cjt0IjZ0pvTdOtWrSi0Bv8GgtAoj+KBDxj2BAdc1QhoHsVY/SElshnRvyAH6MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7Uj6Li4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7Uj6Li4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C64C4CEE3;
	Tue, 15 Jul 2025 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586390;
	bh=PWepeBMXzG2phsk2drzjU62zdAR+wmKE6QXZNLHa4Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7Uj6Li4k2nf5uX+DtG5tOHw5NQv2x4nTGxhYPQQYbjEBBxKMp58rL35f2ddRJAjt
	 +T2U2i8aOooW5HEu8qz78qssUYy747+uUwge/SHdKniqGTUTk/35JGqerdyjWgNSot
	 2GoMsnOW2LfOVqBN2Bmuj9TXAYcfIvqSUhlBkjO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.4 048/148] HID: wacom: fix kobject reference count leak
Date: Tue, 15 Jul 2025 15:12:50 +0200
Message-ID: <20250715130802.243135283@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2031,6 +2031,7 @@ static int wacom_initialize_remotes(stru
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
 		kfifo_free(&remote->remote_fifo);
+		kobject_put(remote->remote_dir);
 		return error;
 	}
 


