Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51E71ACEDA;
	Mon, 23 Jun 2025 21:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712874; cv=none; b=UZraIcf3pxE/I8fYMoZl0tUsyjcxdJLz2Jz65nv0HTDfmfS37dndHIPK1ym7h1QSdov3ZdTJEtmglRcGkoUgMsmhHnMnXAhbqJStkYCd/hIbPQ9mxVS/TfDt81RnYdoPOEMnSdiyOfRQHhlLO7eU7QO4MrZx1tluQmiJEB8SU9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712874; c=relaxed/simple;
	bh=xDtnv/gZqkWAmSXqIxfvmEZE0yqmbaVLW8rOpJ+9cKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8HNm6k6ftQg4vxy04Lk+jZJhLJz54a3whYmC1/7b9vZLQcimuELCgIxkHhjnEs7jbT769EyMXC73GbAsgleQQLG1Xa1ZOoQeh+/HCDBXqqt2jbJqaQdNuJuKxPDwoJJ1V1vF+q8z9u76cPZQ8xqT7tLc8xyfAjg8/PcQgFxZao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouWUSgqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouWUSgqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0BFC4CEEA;
	Mon, 23 Jun 2025 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712873;
	bh=xDtnv/gZqkWAmSXqIxfvmEZE0yqmbaVLW8rOpJ+9cKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouWUSgqW914Cwq4Qjkgdll3mgLV8V2tBdP4MfQpA/KGQ5ggKALtXEyvqHiHRJbDJ+
	 9PPtGGyyG1QV+zwqy6sVkDpF45hYUGH0urWjvAP/IBzU/OqAbSwUbVXllJjYVQo8eA
	 qJ2V+ZqHfz5rJmCt3g05GAUdCOjFOYGThTztD9iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 016/414] s390/pci: Prevent self deletion in disable_slot()
Date: Mon, 23 Jun 2025 15:02:33 +0200
Message-ID: <20250623130642.433721986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 47c397844869ad0e6738afb5879c7492f4691122 upstream.

As disable_slot() takes a struct zpci_dev from the Configured to the
Standby state. In Standby there is still a hotplug slot so this is not
usually a case of sysfs self deletion. This is important because self
deletion gets very hairy in terms of locking (see for example
recover_store() in arch/s390/pci/pci_sysfs.c).

Because the pci_dev_put() is not within the critical section of the
zdev->state_lock however, disable_slot() can turn into a case of self
deletion if zPCI device event handling slips between the mutex_unlock()
and the pci_dev_put(). If the latter is the last put and
zpci_release_device() is called this then tries to remove the hotplug
slot via zpci_exit_slot() which will try to remove the hotplug slot
directory the disable_slot() is part of i.e. self deletion.

Prevent this by widening the zdev->state_lock critical section to
include the pci_dev_put() which is then guaranteed to happen with the
struct zpci_dev still in Standby state ensuring it will not lead to
a zpci_release_device() call as at least the zPCI event handling code
still holds a reference.

Cc: stable@vger.kernel.org
Fixes: a46044a92add ("s390/pci: fix zpci_zdev_put() on reserve")
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/hotplug/s390_pci_hpc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/hotplug/s390_pci_hpc.c
+++ b/drivers/pci/hotplug/s390_pci_hpc.c
@@ -65,9 +65,9 @@ static int disable_slot(struct hotplug_s
 
 	rc = zpci_deconfigure_device(zdev);
 out:
-	mutex_unlock(&zdev->state_lock);
 	if (pdev)
 		pci_dev_put(pdev);
+	mutex_unlock(&zdev->state_lock);
 	return rc;
 }
 


