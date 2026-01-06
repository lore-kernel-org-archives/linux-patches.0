Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424033559CC;
	Tue,  6 Jan 2026 17:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720568; cv=none; b=WOD3EPS81gsp4PTd5mu3oUbDpv/HgYN1xl/WH868mHiqczqWjaFRSoSn/nQp/NV46QUwyFHlAd7JaCahSunKjFtBffBU6pDJ5JwzodIv43fNk9mUk5qonwpel1pboA8zlSmDXQNyM4DSEL+a3kBiZm1yS4SbcPBvEFuHJfZFfo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720568; c=relaxed/simple;
	bh=6je1NnD7zp3qczJgxtZB9dKELkuhQQfS9Yn0XW1wOUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elownaqM7U9neRGXLAJCz1HgoXXN/zPT9Jy8rIGtHn5lYiTXX2NwMADBMLv4UhIRo7YFc74/bH7CIbtht0VwLPRqtbqoxOcriDAcBxZH5wsV0OCNCWdbaZI2iFxQp7JOsYtGe+EhWRUBqjW/cJjflHIhrg8SdHuPKWbNtEeLHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2xk0UI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2xk0UI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6647C116C6;
	Tue,  6 Jan 2026 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720568;
	bh=6je1NnD7zp3qczJgxtZB9dKELkuhQQfS9Yn0XW1wOUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2xk0UI64P/kVbSd2v61BH5CkWjEOtvsqxp93fREpxj3N7J6ZvVDASAhexs82MygR
	 FzJMQkKPsuQ/AeXLhbyzVdg1BKaoN8VhlNikvJnDDRzSZw02XRm1+EdrA7kTFR/EAr
	 if/f3X+cYrNKE448ifZhM3lP0JPvXdCPQCgCPcjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.12 275/567] virtio: vdpa: Fix reference count leak in octep_sriov_enable()
Date: Tue,  6 Jan 2026 18:00:57 +0100
Message-ID: <20260106170501.499486223@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit b41ca62c0019de1321d75f2b2f274a28784a41ed upstream.

pci_get_device() will increase the reference count for the returned
pci_dev, and also decrease the reference count for the input parameter
from if it is not NULL.

If we break the loop in  with 'vf_pdev' not NULL. We
need to call pci_dev_put() to decrease the reference count.

Found via static anlaysis and this is similar to commit c508eb042d97
("perf/x86/intel/uncore: Fix reference count leak in sad_cfg_iio_topology()")

Fixes: 8b6c724cdab8 ("virtio: vdpa: vDPA driver for Marvell OCTEON DPU devices")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251027060737.33815-1-linmq006@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/octeon_ep/octep_vdpa_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vdpa/octeon_ep/octep_vdpa_main.c
+++ b/drivers/vdpa/octeon_ep/octep_vdpa_main.c
@@ -692,6 +692,7 @@ static int octep_sriov_enable(struct pci
 		octep_vdpa_assign_barspace(vf_pdev, pdev, index);
 		if (++index == num_vfs) {
 			done = true;
+			pci_dev_put(vf_pdev);
 			break;
 		}
 	}


