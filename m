Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604F23DD86A;
	Thu, 17 Sep 2026 18:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671037; cv=none; b=G023nzg0ZS/13fhnzuYJeSEK2ygkIpQeVt3I0ASLVkjAUY327W4CycrQsSrWzbgvpr5WULAcBFhR0gVSY6iSbFB7e4jzgAAlIrU4BOx/2hLh7VnANzvvfSKgA43BoXCZp1bH8hMSjuBNZOjSIntcV3Gb8wSzQOzecw3IkINtkqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671037; c=relaxed/simple;
	bh=0WxIOolRIRYN3SpaHsKMwH5E8lKJltFoW2dfnKgiD0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siUqeqdqTcJ6E9k+vrjK9nFnPCRN6IA4zRYSYPq8A3B64fDg3JG3dDr5ofLxNempBCTZmUYTgH7YwIsB29U5aTRL60Tf5ib0O4OM4hXJhPJPor8lqXvGFwNczS5qCy1D+ZZrlH3sWDuKKDK60bb17h8vaktUtoAM3VqLbT8J+rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VA6c3QFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VA6c3QFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789F11F000FF;
	Thu, 17 Sep 2026 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671036;
	bh=D0DQYKy2gfXpv9Gkx1BRX5S1ZsnU6Bj72pyCAvqxC+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VA6c3QFwnA3gvUW0oi29vipuZxk1aUxoVK3QrLqVCPjUxfStLnopdW6uYjP+0o0gI
	 fYCH8uxJ57I1LIiSqQNyJuE1I20kMgVVP7UhqfL25SutAr2gPioCHwURy0G+ZxFN1n
	 RVs7EYKLE9WQc4Biwi8FjVRJ21PrJ6vexuqzUPKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.12 0849/1102] vdpa: solidrun: Free IRQs after request failure
Date: Thu, 17 Sep 2026 16:13:12 +0100
Message-ID: <20260917151601.850220385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiong Weimin <xiongweimin@kylinos.cn>

commit e847542ab0545c73354849126150206c29d83929 upstream.

Unwind IRQs already requested by snet_request_irqs() before returning a
VQ IRQ request error so a later DRIVER_OK retry starts from a clean
state. The IRQs are requested and freed while the PCI device remains
bound, so the driver cannot wait for devres cleanup at detach time.

Fixes: 51a8f9d7f587 ("virtio: vdpa: new SolidNET DPU driver.")
Cc: stable@vger.kernel.org # v6.3+
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <178589471328.1556376.15570536900532373521@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/solidrun/snet_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/vdpa/solidrun/snet_main.c
+++ b/drivers/vdpa/solidrun/snet_main.c
@@ -418,11 +418,15 @@ static int snet_request_irqs(struct pci_
 				       snet->vqs[i]->irq_name, snet->vqs[i]);
 		if (ret) {
 			SNET_ERR(pdev, "Failed to request IRQ\n");
-			return ret;
+			goto err_free_irqs;
 		}
 		snet->vqs[i]->irq = irq;
 	}
 	return 0;
+
+err_free_irqs:
+	snet_free_irqs(snet);
+	return ret;
 }
 
 static void snet_set_status(struct vdpa_device *vdev, u8 status)


