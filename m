Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D9217C77;
	Mon, 14 Oct 2024 14:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916900; cv=none; b=NjPBTdSA2FMFSQ+6n2NBpWywuDTMGjqgkfwYqI15inxXSiXRm1hsf7uVNlKo/d61/Y4hP9ZTP/bS88L9M3U+yylGT2k5RHV3eihHes4dnVVD2pmx54vaaJP3QegdW9spKnSDR++QeUF7e1j9BmbB106sCrnb09rAcNFmwGRUS24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916900; c=relaxed/simple;
	bh=XOz05oBZMKZ6K/WSwksVjfZuuo5gHenuSecrZqEc0wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRjC4paidLm+j3kgCe+AH9yS0BSCNbQthO6EUDzAQpyfxsUH7u2f6RJKd4tJdZFXerWlBSMbfmPNUf0tpPmyHZVjM8wgy/TBGFKOXEBukt2oEdhpDmb/Txay7PlCg0dz46GlTXeP+U40fXzEPE4/U0sTMgtUo5/dN/sLYV+j6mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWmlwYhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWmlwYhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E54C4CEC3;
	Mon, 14 Oct 2024 14:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916900;
	bh=XOz05oBZMKZ6K/WSwksVjfZuuo5gHenuSecrZqEc0wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWmlwYhI/gwQWpUujUICDtHShFLTlsKEj3iQWJb50H/L4wqBj1iR3DDppNErkWjH6
	 KH2+t8p2tF//flW/lFFUdB/C5UXm6meam5e3j1UOvrr19BDYVMhuOdNrcG6d6RK2M+
	 0cUi40DIBgEU68AVQ8bcUcZHcU56f7CWyR2i7KT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Chen <philipchen@chromium.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/213] virtio_pmem: Check device status before requesting flush
Date: Mon, 14 Oct 2024 16:20:02 +0200
Message-ID: <20241014141046.714439621@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Philip Chen <philipchen@chromium.org>

[ Upstream commit e25fbcd97cf52c3c9824d44b5c56c19673c3dd50 ]

If a pmem device is in a bad status, the driver side could wait for
host ack forever in virtio_pmem_flush(), causing the system to hang.

So add a status check in the beginning of virtio_pmem_flush() to return
early if the device is not activated.

Signed-off-by: Philip Chen <philipchen@chromium.org>
Message-Id: <20240826215313.2673566-1-philipchen@chromium.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/nd_virtio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index 1f8c667c6f1ee..839f10ca56eac 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,15 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	/*
+	 * Don't bother to submit the request to the device if the device is
+	 * not activated.
+	 */
+	if (vdev->config->get_status(vdev) & VIRTIO_CONFIG_S_NEEDS_RESET) {
+		dev_info(&vdev->dev, "virtio pmem device needs a reset\n");
+		return -EIO;
+	}
+
 	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
-- 
2.43.0



