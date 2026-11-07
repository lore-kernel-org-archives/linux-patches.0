Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065546;
	b=xsymIA61+TEjcGTn/uQnYh9973NsfYd857RyBBLA9Tl8NlXQBYI85XSfGZBAPoobVkJQ
	 NOuPr5UDtmkKC2IGUyKEXd7uje33gLfci/4E5Y0rrCM6NVK/EZ8gl9SH0szCNsBsdk8ne
	 ArPN+kTEO1X08xk5UALT7IuHqF/0ssvmfBgKWA3EyBhHXnOGR9j80/bcK3NXUjCLKUf4r
	 WJa8oMQEjuiGSw1AIm2AUvJYr51oS+A6lvq21EnOeVk7EFxcZeB2/ENhb1WG32jmM2FhK
	 aMrNirWr0fsVdKIjN8FCU9PHhXNZMWN/XizKC9BCcwH8WVgaPFxDgbAolUzloAqW13g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=15BJqjh36gzHqyqMOIPiNkknpTHcGzX0k+Pu1Im5OLs=;
	b=ydPRHkpgMPeImy883l6ldGcSERdk69T/d8U6SLc+fui4dADZK3cDJTZeZpDvRYIT4jsP
	 16QwP2UVdid7kEP9d32VSZXPQTCBBiyUX4GgW4y/NK/Nb3eaYjMGKDEQMAirb7uA0Jx2H
	 hoaRYZ1dtT5NniQCnVyOa1uqojoWctpCScLRrSJ1Lq+c/1gMAVFF3uGz1IpotrOZ4SjvY
	 rmWM9t8/bknvR5QnOfkqXiO5UeJsEc2xfRv9AUEi2vF2xn9wVCpbviLAM0iu7B9M8oGG8
	 mH0hEunwNijQA11UJ9Vt6XJM8lwpt2AcbXi8Q/yTVShWdVKYF8CJ8isSdqfUUXZ9cIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rE6NNrRj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647AD606A330;
	Sat,  7 Nov 2026 15:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rE6NNrRj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEFA1F0089F;
	Sat,  7 Nov 2026 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065546;
	bh=15BJqjh36gzHqyqMOIPiNkknpTHcGzX0k+Pu1Im5OLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rE6NNrRj/N7MotD7981u3yLcLRpUXTbKtN/dAbEIsg+MthornWa585v/lV8jYF4y1
	 zhCpaiaKLOfzCQrmLTVrAOCcC86uSyibQ8QIVL7T4zYvYGwWPdHf3AkMuuu2KM0hJR
	 Kt+CITp35NlIdlwSsAG9Pzv1EyaWcUIB1QYaz6C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1221/1257] irqchip/irq-msi-lib: Free wired MSI descriptors
Date: Sat,  7 Nov 2026 08:58:37 -0500
Message-ID: <20261107135013.077964377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 1c16bc2b1122f78f9d51c5785f7a78b36d44972b ]

msi_device_domain_alloc_wired() allocates a descriptor for each
interrupt, but wired MSI domains do not set MSI_FLAG_FREE_MSI_DESCS.
msi_device_domain_free_wired() releases the IRQ without freeing its
descriptor, eventually exhausting the domain. Failed allocations also
leave descriptors behind.

Set MSI_FLAG_FREE_MSI_DESCS for wired MSI domains so both paths
release the descriptors.

Fixes: 64a855324311 ("irqchip/irq-msi-lib: Prepare for DOMAIN_BUS_WIRED_TO_MSI")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261025122058.2180685-1-thnkslprpt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-msi-lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-msi-lib.c b/drivers/irqchip/irq-msi-lib.c
index 45e0ed3134ce1..a1e12aa820e7d 100644
--- a/drivers/irqchip/irq-msi-lib.c
+++ b/drivers/irqchip/irq-msi-lib.c
@@ -75,6 +75,7 @@ bool msi_lib_init_dev_msi_info(struct device *dev, struct irq_domain *domain,
 		info->flags = MSI_FLAG_ALLOC_SIMPLE_MSI_DESCS | MSI_FLAG_FREE_MSI_DESCS;
 		fallthrough;
 	case DOMAIN_BUS_WIRED_TO_MSI:
+		info->flags |= MSI_FLAG_FREE_MSI_DESCS;
 		/* Remove PCI specific flags */
 		required_flags &= ~MSI_FLAG_PCI_MSI_MASK_PARENT;
 		break;
-- 
2.53.0



