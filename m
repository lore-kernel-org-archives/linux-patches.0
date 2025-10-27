Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5CD32145A;
	Mon, 27 Oct 2025 19:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592720; cv=none; b=YbyU/C2G7zjx5Y4RlGvL57PoT1lwx7emrzE4PyQ4bY+HQfoEVRD4dE0Jae3f2IsBniou3LU+eDRGgeJHfINKIj357dGN9pL61V7an1GtcOXri7UYQNdy0RRDcr4Oewo4eBrIPKNprN11RyAfHxS6L3PyhpGa24JZiXrtT8rRSew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592720; c=relaxed/simple;
	bh=tlVts2hGfllhqpJSElaLi6H0UNwu/aKXuyFem9puEUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE0FBtY9mqM46dl4o/BQOnMgn5E+R7VsxY5nYtsHstj+/l/Ifu6Z8olDPldDsujxBMOdGnzRhuy0xdpWuW9MVQMCLlYTo43JP6c57mYMFN3xpYOX3tXaOuKyQE4JhZbKg9PderQo5IJ/sHf9KwP6iVeKMSN7CfkzZMI77/4kLyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gwod3JGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gwod3JGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0381C4CEF1;
	Mon, 27 Oct 2025 19:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592720;
	bh=tlVts2hGfllhqpJSElaLi6H0UNwu/aKXuyFem9puEUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gwod3JGTNhgMMtabCKNw3+aFSmeyRt4AgDS3+isIU10ZacI3AQakUzxGQoG559YBq
	 yB4m4tr3DXNHGsK0UuppP27cXiPpuqPyNZa08mG8G6KYfW28wUra5pTiFBcfFzfGiI
	 u1/oMG05Lt+cWYC9wr6Fgia9BHqnqv5HeR4ZdceI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Victoria Votokina <Victoria.Votokina@kaspersky.com>
Subject: [PATCH 6.6 71/84] most: usb: hdm_probe: Fix calling put_device() before device initialization
Date: Mon, 27 Oct 2025 19:37:00 +0100
Message-ID: <20251027183440.701689123@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


