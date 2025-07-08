Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978062E542F;
	Tue,  8 Jul 2025 16:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993964; cv=none; b=dOJ9XxB47v2U4pzJksE8fvSPvYA3sOpVh4trx9fgVOVIcv3ErBQZDI83aRXxRzh7ta26CDsewKlHloXYO5ehBlEa7TP6c5aYO/nxQQ4FZejtc0VeVMmE2KBRk9Ok+5A7sWcwUzgokpMMgv7qtBMc39J08TGZfdpkPWocO5zRfVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993964; c=relaxed/simple;
	bh=MBRfG6kKDCLYc3DVaafTKwa9aRTpgOkcHkRVQlfBMRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECeaNOKtsKsRSXc20dZX98hpGJb0cQnqe1rsTh+yciL0tgAVyARDKgbCc8XnnUcD75WBEPNRT4+e9R2jtkwwoKVklwrNX1WUIyL2+p8wHU7CcO2P0ecpF4zMmI8W06qpknst7Yn4FJnejuRVMQ7xIcGWorzfW8RKihmnwQ0rEX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iy9V4of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iy9V4of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC73C4CEF0;
	Tue,  8 Jul 2025 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993964;
	bh=MBRfG6kKDCLYc3DVaafTKwa9aRTpgOkcHkRVQlfBMRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iy9V4ofHRYe/hbfjQKO3slQFZcGt+elt8vgqcx8xBoBkqVUm+hKve9Y3ry54+P6X
	 WlpiuDfkWcUHsBvlj6bk9KDtcp5PirtukYv8M6E5ZRpJjqAP6bPRflqYCqIKFH/CYm
	 u4XA/QSBiXpAP2SdtWrsq/LTQ7TQ2FfxhTiRIm/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping Cheng <ping.cheng@wacom.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 079/160] HID: wacom: fix kobject reference count leak
Date: Tue,  8 Jul 2025 18:21:56 +0200
Message-ID: <20250708162233.729243340@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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
 


