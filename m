Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49BE230996;
	Thu,  3 Jul 2025 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554308; cv=none; b=CR3PKhhEY5Rgyrscj7cR9hUg6vdq7t4axHBSSTqPoxc7vI6Om+KjBXISaY8Wodpc2qnPTY5kHyMPA4GtToogEmuFzQF4bssF7DG/6YTPU56bIC2AMzqc99zvLM0oJSNtQ5++qGYuyYHsntFsNaxtseQPtkX+FuPvbRrQIa3LCvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554308; c=relaxed/simple;
	bh=+SF6pYroZAxd8A+qrfmywkV9wYedt2Lg2hNOlbPKHEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQRILPy80ynjh85zyitK4Gzevsfb0r7x0GsNEeri92nKf8l9jr7M/Qs1NAKPc6I75VP14qkm221rYarDNKPACn13eFnGF/l8wwPIyhyrID67EnPcDGkfmiX8gl/VzvpucvWbgnzT1aUii9dqH+f9m6GSX0rBqJYVsTYSeAsnfv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2t8QNse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2t8QNse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14711C4CEE3;
	Thu,  3 Jul 2025 14:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554308;
	bh=+SF6pYroZAxd8A+qrfmywkV9wYedt2Lg2hNOlbPKHEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2t8QNseKRnktHEKTUjmMb7RHPtdKMOEV1PTODBExftS5H2NkKWiwYyisx+HvzGRH
	 N0mAd6JuyejwuOrJhSOzvXjAaWMN3oXi7yP83f/YO/c6zJqK++gcQhAaA9s0zjpMuF
	 f6Pw6WdYa0EETJTkJpro31CVYvr4YIrsmFI6HdF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 145/218] HID: wacom: fix kobject reference count leak
Date: Thu,  3 Jul 2025 16:41:33 +0200
Message-ID: <20250703144001.920982943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2032,6 +2032,7 @@ static int wacom_initialize_remotes(stru
 		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
 		kfifo_free(&remote->remote_fifo);
+		kobject_put(remote->remote_dir);
 		return error;
 	}
 


