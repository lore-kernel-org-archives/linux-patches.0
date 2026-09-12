Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6147132D43C;
	Sat, 12 Sep 2026 16:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231748; cv=none; b=CCojgHgeu2OySTAJRbvxa6okUaWD204yolwP4Oi6033Ib/nzzzxyXg1bCh8ZXIHcri2ieDjPCkUdBZQ6SzXvz/gK5sxUH7o+w2BDAoLHsPjJ8kdXIrwtXnEe9PuQu/8mNE4jbrVKtar5N5RRWC6yIYzxxWKQA+XPOWEdzgTTryI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231748; c=relaxed/simple;
	bh=PAstUEQLcBP2la1FFyEVdptX2ZbIG3OMfMg9//rbHJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKHQ6fMHE6+hLhxzh7PEfYZy6+9M8LqgEGJ/ozQuGG38EMM0dEhBLv/d8ltqHByl9W6MF+sKwkqp00rVQvUjImdhqy7yYrgO/f3g/5Tu04fhZy4uzM4U0g5vRG8JKtHG62jsPnux6DYB2qkx3qexv+bpsNanz2lfXMc12qVuWrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjNHJpXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjNHJpXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1E91F000FF;
	Sat, 12 Sep 2026 16:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231747;
	bh=l+FBv6gSMk4ZYS3Dd0xKHVbzAs6qTuGzTcKO69S1L1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjNHJpXDf+v4ml0pg78y5PzqeCTMNTND1x0JPMn+g15gRi2kqE+DsAZUe3436GbTX
	 aSbyRus9NVrPEh02Q4W5G10aJnDGeqbBXwv1dxbMFCzlsxxsLsn4eNShZy4OCxxBtF
	 QyJ5/D4gvbh1wct6jdMhI4zFJWSj2NJuxM/YOLWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1020/1191] mailbox: pcc: Use acpi_os_ioremap() instead of ioremap()
Date: Sat, 12 Sep 2026 09:02:28 +0200
Message-ID: <20260912065611.100642251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 3360b088175d ("mailbox: pcc: Fix command timeout due to missed interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 2e3dff068b11d..1d4191cb91380 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -428,8 +428,12 @@ int pcc_mbox_ioremap(struct mbox_chan *chan)
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
2.53.0



