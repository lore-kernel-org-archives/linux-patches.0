Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26A81C295
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+PCPePj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6CCC433C9;
	Wed,  4 Oct 2023 18:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444588;
	bh=S/s6/qsiSHqLKqDtW8n8csBI1agpzXyic78wVC+PKB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+PCPePjJrcTZt+GU0f6PHzvwaVkNNMUsUXBhcuVBNzytd/ftx3gU02pyNxK8X1dv
	 ZvDvpRTVwMlAu1Z8xRUJuE/dAnbfpcE2PZe/1KGeE+5tYiKfMeCJuoJiVgZ8VeMP4/
	 AeMLilUZ7bnrTkXJD2RYXl6PcrN3ajStF7sIn/4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Liao <liaoyu15@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH 6.5 275/321] ACPI: NFIT: Fix incorrect calculation of idt size
Date: Wed,  4 Oct 2023 19:57:00 +0200
Message-ID: <20231004175242.029379469@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Liao <liaoyu15@huawei.com>

commit 33908660e814203e996f6e775d033c5c32fcf9a7 upstream.

acpi_nfit_interleave's field 'line_offset' is switched to flexible array [1],
but sizeof_idt() still calculates the size in the form of 1-element array.

Therefore, fix incorrect calculation in sizeof_idt().

[1] https://lore.kernel.org/lkml/2652195.BddDVKsqQX@kreacher/

Fixes: 2a5ab99847bd ("ACPICA: struct acpi_nfit_interleave: Replace 1-element array with flexible array")
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://lore.kernel.org/r/20230826071654.564372-1-liaoyu15@huawei.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index f0e6738ae3c9..f96bf32cd368 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -855,7 +855,7 @@ static size_t sizeof_idt(struct acpi_nfit_interleave *idt)
 {
 	if (idt->header.length < sizeof(*idt))
 		return 0;
-	return sizeof(*idt) + sizeof(u32) * (idt->line_count - 1);
+	return sizeof(*idt) + sizeof(u32) * idt->line_count;
 }
 
 static bool add_idt(struct acpi_nfit_desc *acpi_desc,
-- 
2.42.0



