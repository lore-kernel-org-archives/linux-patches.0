Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EB2376BED;
	Tue, 16 Dec 2025 12:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888082; cv=none; b=j+KiLckfllltgHynXzJ/XQ8nz6HDtd0jZGvB9q0P9QssVfyvc/JEd2hyy+MtbbZQbvm5QIJuyU0Vgha9fdtUoMUtyonTTo2m4qIAGzMfAKYrX2nYkYbNJZ8OEZt3gQ6fVKPYldh+hXTiQ5wIPn7uE5RG2J9N8aSaNW4Rw3SbgOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888082; c=relaxed/simple;
	bh=qGVSBLFwLpAwowDFSAKonXo4CgaeAAFbC6o0qA2Y26o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OA+2fMGDaiQ0FscfXKCIQ/PgqaUXZ1t0mMvJa3NVnN8UhVW/5QipkvYSkxpm7kzNRVZWqyDJ1IwJPw5O46vRsz8RxJM2M10SI3qv4w3BmG8bQiyYuPiyK5YhSeJS1VCyaI3NwEgw3154UVwPnoJ5GdAtFieUd1ZCrWhXo6rFUfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+cvsPI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+cvsPI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD76C4CEF1;
	Tue, 16 Dec 2025 12:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888082;
	bh=qGVSBLFwLpAwowDFSAKonXo4CgaeAAFbC6o0qA2Y26o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+cvsPI54aytJNgbYbTQq+JLUnD/rcAKGtyRZXbQ9znDfI762H7TBQgkPDeeRQ4Gr
	 lv/V82rLesCOKolOxuOU0Q6/QK6gNVQlo1jLAGnEyt8Z7+hRnatJnRb8lg7XcX470R
	 9KMTRYGZiosoF9amvYrdH7ouEgwNJoYIol2YXJWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 427/614] RDMA/irdma: Do not set IBK_LOCAL_DMA_LKEY for GEN3+
Date: Tue, 16 Dec 2025 12:13:14 +0100
Message-ID: <20251216111416.844187425@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit eef3ad030b08c0f100cb18de7f604442a1adb8c7 ]

The GEN3 hardware does not appear to support IBK_LOCAL_DMA_LKEY. Attempts
to use it will result in an AE.

Fixes: eb31dfc2b41a ("RDMA/irdma: Restrict Memory Window and CQE Timestamping to GEN3")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-8-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 8c44c3fcf9731..afccd9f08b8a5 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -27,7 +27,8 @@ static int irdma_query_device(struct ib_device *ibdev,
 			irdma_fw_minor_ver(&rf->sc_dev);
 	props->device_cap_flags = IB_DEVICE_MEM_WINDOW |
 				  IB_DEVICE_MEM_MGT_EXTENSIONS;
-	props->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
+	if (hw_attrs->uk_attrs.hw_rev < IRDMA_GEN_3)
+		props->kernel_cap_flags = IBK_LOCAL_DMA_LKEY;
 	props->vendor_id = pcidev->vendor;
 	props->vendor_part_id = pcidev->device;
 
-- 
2.51.0



