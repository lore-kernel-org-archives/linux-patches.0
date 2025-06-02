Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF9C1EA65;
	Mon,  2 Jun 2025 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873227; cv=none; b=jndnMTgGYkLFvADYLwPui4FzaVeKKzpEfK8bDUBJf0mi1BM7yjb5ig6Fau6ei+QVztINmbUJPa8rNjPQbe8Qa6L4EHZff+yFwbAMhdIkDoOaN6hOBSFjEcfszZVtZsApgTn14LnZBrSNf61cnv+rlLoyc9O7ejKlz13u38ChGdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873227; c=relaxed/simple;
	bh=Vtj7RU7GLhQidvTXZpVHEZBBpc5A6sDvhz9zss4sOgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0awoyOcekJVddMlY5yvTvH4LtjL2K9JrFRux6pi9JTStbGFC/sq79UnNRzBOsGUR1ipvZtShTtH6Su+2AefvkWRYIYpnsuQbwwLCXCvLJzPsjbjEKRW/q5ihnpKsSqSqJ5vm2/JZ8jKUTNtUAX7RgxG5jmX80VXa0WtxrCpNMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+Vc8wcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+Vc8wcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D09BC4CEEB;
	Mon,  2 Jun 2025 14:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873227;
	bh=Vtj7RU7GLhQidvTXZpVHEZBBpc5A6sDvhz9zss4sOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+Vc8wcyHvL36kNy0RwUeOh9CRPJ7jyc3qVrEWw4oiujr7s+0MlKpQuPI6W+OCSRU
	 VM0VCbCfUJ+hA9fKDznEs618LfyqB7DDFIEVnZ0gTmMDcwXEpnFma2Ce2+k8nzUqpQ
	 FaHXXZIQT8SMz3d8PKpJu17vvb34IlQsC0jjvN6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/444] mailbox: pcc: Use acpi_os_ioremap() instead of ioremap()
Date: Mon,  2 Jun 2025 15:41:50 +0200
Message-ID: <20250602134342.797783729@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit d181acea5b864e91f38f5771b8961215ce5017ae ]

The Platform Communication Channel (PCC) mailbox driver currently uses
ioremap() to map channel shared memory regions. However it is preferred
to use acpi_os_ioremap(), which is mapping function specific to EFI/ACPI
defined memory regions. It ensures that the correct memory attributes
are applied when mapping ACPI-provided regions.

While at it, also add checks for handling any errors with the mapping.

Acked-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Huisong Li <lihuisong@huawei.com>
Tested-by: Adam Young <admiyo@os.amperecomputing.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index f8215a8f656a4..49254d99a8ad6 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -419,8 +419,12 @@ int pcc_mbox_ioremap(struct mbox_chan *chan)
 		return -1;
 	pchan_info = chan->con_priv;
 	pcc_mbox_chan = &pchan_info->chan;
-	pcc_mbox_chan->shmem = ioremap(pcc_mbox_chan->shmem_base_addr,
-				       pcc_mbox_chan->shmem_size);
+
+	pcc_mbox_chan->shmem = acpi_os_ioremap(pcc_mbox_chan->shmem_base_addr,
+					       pcc_mbox_chan->shmem_size);
+	if (!pcc_mbox_chan->shmem)
+		return -ENXIO;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pcc_mbox_ioremap);
-- 
2.39.5



