Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46CB82F25F4;
	Wed, 21 Jan 2026 18:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020468; cv=none; b=K0FJ/wWQn7ZfhVz9TVF28Dl1yS72AmrA7KSTiR4RvCitGoRxDaLyWVIVaHK3ray8UfnRNV6rG8VOcyRImH9u4LWSxgWN4kPrgWWNeB5nrH62idNBheGro6IdMT3uSF/8jIDlz7EUy5t8xhfuQNnQeT3pq8kpc5uEdXwlUdSe8hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020468; c=relaxed/simple;
	bh=IcurVtLvMj4myKpSiNb1B3UzJjYvL+yG47+Za60o0rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=leiE+u1VPyi/geuR5PbhIFqclI2KcIS9ppElC9YZhZxKrhKg2rBLFgG3gOGaeXUSZYgt+OSJKtSGIib2yAXAU2euQDeIadoWpJWDomy+yrgHB7chXMwY11ER9J6hnRtgqam2NHcakJJddahyBwYLyjwg5JlaSFT05Qwv4BTOJ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvFEPx5s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvFEPx5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845C5C4CEF1;
	Wed, 21 Jan 2026 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020467;
	bh=IcurVtLvMj4myKpSiNb1B3UzJjYvL+yG47+Za60o0rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvFEPx5sOmVe6UqXYx9sCrUXywGuzF/0k41mZ8NTBx7tl3naFC4FsL6iojYno3wIm
	 RDemWNevkOCIttXRXtmXGZeuDTpzeuLT6hXMX6GN/I/KkIoMd9oxvtOrVaWNQryUBw
	 DYN4ickyytoYZBnyiJKMfgzMyuKMWmgml1anFBnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Qiang Ma <maqianga@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 166/198] LoongArch: KVM: Fix kvm_device leak in kvm_pch_pic_destroy()
Date: Wed, 21 Jan 2026 19:16:34 +0100
Message-ID: <20260121181424.521402468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiang Ma <maqianga@uniontech.com>

commit 1cf342a7c3adc5877837b53bbceb5cc9eff60bbf upstream.

In kvm_ioctl_create_device(), kvm_device has allocated memory,
kvm_device->destroy() seems to be supposed to free its kvm_device
struct, but kvm_pch_pic_destroy() is not currently doing this, that
would lead to a memory leak.

So, fix it.

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/pch_pic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -475,6 +475,7 @@ static void kvm_pch_pic_destroy(struct k
 	/* unregister pch pic device and free it's memory */
 	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &s->device);
 	kfree(s);
+	kfree(dev);
 }
 
 static struct kvm_device_ops kvm_pch_pic_dev_ops = {


