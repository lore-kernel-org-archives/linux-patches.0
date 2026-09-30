Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280493CFF66;
	Wed, 30 Sep 2026 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795644; cv=none; b=VypUKtCqmyqbcCI2URlQul2e8iGGIz0qQpvUhvynX0yFviU0PPFGELPneIShvW/2MN6FJbj5ml9MB5OexYj379DVp0xRE9sE3+i0XBQM2Ex7oPdI0FTCgIKWd6vd1VqZJNw7WF4/8Q9AHN/4MXA2wFj7xHlpGBpqIVYuxGf50aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795644; c=relaxed/simple;
	bh=hB7azbJDxniOB60aZbr2y8q2JsmjksSzmVH++cONcco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3KH9mk7OSaCUFkD43+dh2QCFBpBHYjgunhHxmmj5ZZDmgWKrTsDnNkPPGDZkZTS8aatpEfqeU+EAA5i9JMdpRa4MpicskMqtKrTZL/zTErmS8Rs9HMEetZ5sv9Ep8SSTcWuZA/M352TrcHrU0zaFojmEfxH/r7pUd1ZtUvwq+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Qkc4aMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Qkc4aMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EC01F000FF;
	Wed, 30 Sep 2026 19:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795643;
	bh=Fz1MUNW4s0yByK6N/cOTC40wOwJFs7nrZDG9no5uEAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Qkc4aMhQlJFCJmLFrAhWNlaI0lGrP+9D8WNY9SSNKFsaqs0aB3M6q3rJ6y++yCG5
	 9b9DrCOPR5/G9+WURP+dHcXh/31PQ8U1QzW6E3SGiwddwY78+AVqeWAT5kGuS24Div
	 m1vmqOa63bmp6t5U/eOGw/JGUgI66OH67SEFr0TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.6 0633/1193] vdpa: solidrun: Free IRQs after request failure
Date: Wed, 30 Sep 2026 17:21:57 +0200
Message-ID: <20260930152448.307219335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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


