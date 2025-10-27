Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0FE321F5E;
	Mon, 27 Oct 2025 19:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593531; cv=none; b=obQ+GIvy0iYKlTpgEHWMZwbGiX/Q2PsDF3E1FalGFQ4oVusxTW8Vjg1bE9iHSehvbymWJcuCGFzYNqSUuPIWBw71TRJrHObsj+5rG5pk1U5qvXwR8R4lOJC84nIA8l6JAL7xYPEertioMj5kxf6BzWe5ynbsSdyuqsHrcdRGWXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593531; c=relaxed/simple;
	bh=KiipNBFXrAqlacJOCmIWc97jg0gsK2+kleCRswb2Nqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nu3Eftd7gJK4gpUkVjo/HhIIUoRXYi0EMYG6pY+Wm4l0h628qyA/GBFs9QyzeO8zSvWM6cNhgiQdLTAKI2I2+RmbS5jiN9lDiDEqNp4JNrglpE8YV+Z1m2V9sYFlPBK198d5KG8JS0ePOa1DVjDgVHIVAVPRYdh4FgwboA4unbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V4Vxga0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V4Vxga0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237A1C4CEF1;
	Mon, 27 Oct 2025 19:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593531;
	bh=KiipNBFXrAqlacJOCmIWc97jg0gsK2+kleCRswb2Nqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V4Vxga0MuwgJ3dHQSSfn3BlZ9FpYqGAXOismIYVF5g4+4VQsFT6qGvAqELhKyhxCG
	 olCg50HypABKxn1m7PQrrBbJsknzov5P9Y18BGOA/BtoPCCKKJIuOEry0SGNJ9UU/X
	 iD8FiZaJac3SzkxuFhRUqRh0nD2doILaFd7KCa2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Victoria Votokina <Victoria.Votokina@kaspersky.com>
Subject: [PATCH 6.17 164/184] most: usb: hdm_probe: Fix calling put_device() before device initialization
Date: Mon, 27 Oct 2025 19:37:26 +0100
Message-ID: <20251027183519.341879508@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victoria Votokina <Victoria.Votokina@kaspersky.com>

commit a8cc9e5fcb0e2eef21513a4fec888f5712cb8162 upstream.

The early error path in hdm_probe() can jump to err_free_mdev before
&mdev->dev has been initialized with device_initialize(). Calling
put_device(&mdev->dev) there triggers a device core WARN and ends up
invoking kref_put(&kobj->kref, kobject_release) on an uninitialized
kobject.

In this path the private struct was only kmalloc'ed and the intended
release is effectively kfree(mdev) anyway, so free it directly instead
of calling put_device() on an uninitialized device.

This removes the WARNING and fixes the pre-initialization error path.

Fixes: 97a6f772f36b ("drivers: most: add USB adapter driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Victoria Votokina <Victoria.Votokina@kaspersky.com>
Link: https://patch.msgid.link/20251010105241.4087114-3-Victoria.Votokina@kaspersky.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/most/most_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/most/most_usb.c
+++ b/drivers/most/most_usb.c
@@ -1097,7 +1097,7 @@ err_free_cap:
 err_free_conf:
 	kfree(mdev->conf);
 err_free_mdev:
-	put_device(&mdev->dev);
+	kfree(mdev);
 	return ret;
 }
 


