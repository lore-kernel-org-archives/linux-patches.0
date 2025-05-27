Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A793727A926;
	Tue, 27 May 2025 16:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364455; cv=none; b=EOyEenhhhr3omVMZDi86ieFst58cIKrXshdd3XKwOfGAAgWAtsykQ/tI/QKjdqGhrZjatfKHgb/Aw39AACXGFrTlIl51xq+QC/22YkVT9fyToSsEvZysUCpGJkvWdZLmEp3oMsG4IxqDetlHyjTaQg6jBspJP3gkscnWoRJQMsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364455; c=relaxed/simple;
	bh=gXXm2XM9gCH8Ljv19Igmk0a9adYUuYJyPX9bUMwbRw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGdqSAc6JQ8zrrggDEmUrBR3WTqYZ8TUoYFdIO0shtkNU2j+/Toq/JfeO7TFMHY0eO3HlP8uhQLsLCXJleGFbbRunM+mrb4jXOID/ysp55NWFfKH7kDLjXQeN40NOm518wUsFmUN4F/yKjjNnfrFU+qbFeGVFHRoHI4PqafphAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXX2sUR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXX2sUR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30400C4CEE9;
	Tue, 27 May 2025 16:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364455;
	bh=gXXm2XM9gCH8Ljv19Igmk0a9adYUuYJyPX9bUMwbRw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXX2sUR808xph1mquZlMrEjDXBDWS+65r4Gay4GCN1dB5VWgSDIS63vDskZrRyRiM
	 5503E4jyX0oqhLfap0FrXIvW3pJASgZSvQ+YeVFSD0axn14mU3BCcopbnl3VTTe6qQ
	 wQ4sKda9eCZ+JN8LZGmUinFFkLPVZOTR7BAN1k+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/626] mailbox: pcc: Use acpi_os_ioremap() instead of ioremap()
Date: Tue, 27 May 2025 18:19:15 +0200
Message-ID: <20250527162447.578876037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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



