Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD45E32B994;
	Mon, 27 Oct 2025 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592015; cv=none; b=DVGFrdnHU14eYXie7sReVQZw4bPBVYtSWMPk6lgyuwFLg8gGCNngSF9GyVfkY3oxdokUCnWRCki3uN90DbAv0sWucwpxd4ahbRGqNX192iq5gFqEVkuimC0718YZBCFdT38cOGOBAmMcBueQ3GYst9IpprR53aAfOTlyqUyFL3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592015; c=relaxed/simple;
	bh=ORK+ZW4BBQQqcjpuoIU9Ke9R193zZhbOizUOwZxsabQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRZ3ld3uX+uROQtwzsILWuzN1+kIV3gO6s7n+K2do46bn5QSAyg7Y46ZrRpDuSl3iAiqo7Wa+csGmw7QAGNboBqAbP1qGpHJHrYAL3sadkUKUkidnzhLkPlrHbsrYBaJYBeyZOlWfCIioECUreNLakjrKVvU+jX59cShjZHpdpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irbdmt/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irbdmt/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E98AC4CEF1;
	Mon, 27 Oct 2025 19:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592015;
	bh=ORK+ZW4BBQQqcjpuoIU9Ke9R193zZhbOizUOwZxsabQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irbdmt/qcZ8pXsutD3nebm/7rxixA4R+ajH6MlSYcWfIdQzYaJj/6ezwXYtjPyl6j
	 Be9G+IpGwXRx3J4h0FHn+LTyQ9rvWogIQs/YiX84kMU2WZIjYd/4qHGmkq9f9WX1qZ
	 7JN7xLia4H1L59aPauI7qplrzGFDzDXJtOXA3VGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Victoria Votokina <Victoria.Votokina@kaspersky.com>
Subject: [PATCH 5.15 085/123] most: usb: hdm_probe: Fix calling put_device() before device initialization
Date: Mon, 27 Oct 2025 19:36:05 +0100
Message-ID: <20251027183448.665494534@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


