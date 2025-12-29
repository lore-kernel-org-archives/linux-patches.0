Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D3A31283B;
	Mon, 29 Dec 2025 16:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025977; cv=none; b=TlhvQWSS+ByYWfaZB1yp5/5IkyOiH1RLVt9eQOsRolKRjVxkfAdo+hEbOO1Dvd3rVie7fKgMWf4yz7dTWEJ6XQpiJeLS2e1vioNAyp4RkK7rIz2tExtuM/sQDgjek/F/CgUM8X1wy8YS5y+1+sDhnQWFQgFpF/JuB6TLzV3MR3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025977; c=relaxed/simple;
	bh=F061evHtvTkmfJGOFvItxyeJBH/o3kFXhb8iS2unBCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5WvTnwyiCnvrsdaqEy9Koot+CkesjzD8T/GCzVpUwcSDuJtJ7u5w0ZncPcSrv929g8u3dMuRuJQSWJ+JQWtiLR5ik5i5e9NQQ5j4Qh+tOqIdyn8LHCtgVz1eq8rbLq20CAWClgpj5Z6lTYUnaJX/q2Oxg/pV8KeGxOOwYmj4qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2rt6iRRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2rt6iRRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23544C4CEF7;
	Mon, 29 Dec 2025 16:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025976;
	bh=F061evHtvTkmfJGOFvItxyeJBH/o3kFXhb8iS2unBCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2rt6iRRNrLQ+VED4iebnCV8bHtipwknuuhSNvErEC/BW0K2c/hGqEC3rjV25OUJ8c
	 +6zCeuB4tIkvf4n4SOgt2NC5LIO3kQQykFStdHZW/K4/bP0UDVhvHjotwG12OUdYVx
	 KpWCY1wId2EMxGBB439eWEXdligMEiuXmLNGJR4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.18 403/430] virtio: vdpa: Fix reference count leak in octep_sriov_enable()
Date: Mon, 29 Dec 2025 17:13:25 +0100
Message-ID: <20251229160739.144016714@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -736,6 +736,7 @@ static int octep_sriov_enable(struct pci
 		octep_vdpa_assign_barspace(vf_pdev, pdev, index);
 		if (++index == num_vfs) {
 			done = true;
+			pci_dev_put(vf_pdev);
 			break;
 		}
 	}


