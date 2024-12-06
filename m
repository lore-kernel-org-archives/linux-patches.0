Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D226148832;
	Fri,  6 Dec 2024 14:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496850; cv=none; b=SCMdh7uoOsYvnwmpQP1/dT5FpoVUJYQL3gxDF5Sl3uSGXK8hDL2GGBjpVVx02ABQ3EDznzqeh+pn1lqNZYtP2QvmcQjUKjclHJR+muRVREKLEBPpkgD7x/EAq7+BCl44FA4aRTZCHD5fAFYQgt9DT3d2r9h/EZmpvdP3/Ru1cOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496850; c=relaxed/simple;
	bh=QQysrNJQnj1saOTOBMSnJXnrYK+OxL5/49znArfW1+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mflDb0oZOIRtoZWldG5kcmphHSgBcoWguzqsyi00CMCpfT4WgMZzjjaKxXpJeeZZRjmDKvTYk5oa+YLfOjZaSslNhBLoWVj8Qcu/rXJafmBd8B38tPQUHzmXH/kPnMnbltsSrdW6h4QtteLzitLWSDKU9Bd0UbimrSFLlQGNax0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cf66d/zS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cf66d/zS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29498C4CEDC;
	Fri,  6 Dec 2024 14:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496849;
	bh=QQysrNJQnj1saOTOBMSnJXnrYK+OxL5/49znArfW1+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cf66d/zSsvQ6qg7jdlD49fJCt88uiriBeuhtZb8fnCmZNkJsMoc61SuMYD12Fx+3C
	 a+zvzjqQzcDifWBN+ux7SqWoMpRy9Xb6X7k0s+O12KC9bbD5r8U/WOsiJOPFF9ndwB
	 SypswXZcXPMmlOlbxip1EcwJdZpG6FGqOwVv0N2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/676] tpm: fix signed/unsigned bug when checking event logs
Date: Fri,  6 Dec 2024 15:29:03 +0100
Message-ID: <20241206143658.198529213@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Gregory Price <gourry@gourry.net>

[ Upstream commit e6d654e9f5a97742cfe794b1c4bb5d3fb2d25e98 ]

A prior bugfix that fixes a signed/unsigned error causes
another signed unsigned error.

A situation where log_tbl->size is invalid can cause the
size passed to memblock_reserve to become negative.

log_size from the main event log is an unsigned int, and
the code reduces to the following

u64 value = (int)unsigned_value;

This results in sign extension, and the value sent to
memblock_reserve becomes effectively negative.

Fixes: be59d57f9806 ("efi/tpm: Fix sanity check of unsigned tbl_size being less than zero")
Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/tpm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/tpm.c b/drivers/firmware/efi/tpm.c
index e8d69bd548f3f..9c3613e6af158 100644
--- a/drivers/firmware/efi/tpm.c
+++ b/drivers/firmware/efi/tpm.c
@@ -40,7 +40,8 @@ int __init efi_tpm_eventlog_init(void)
 {
 	struct linux_efi_tpm_eventlog *log_tbl;
 	struct efi_tcg2_final_events_table *final_tbl;
-	int tbl_size;
+	unsigned int tbl_size;
+	int final_tbl_size;
 	int ret = 0;
 
 	if (efi.tpm_log == EFI_INVALID_TABLE_ADDR) {
@@ -80,26 +81,26 @@ int __init efi_tpm_eventlog_init(void)
 		goto out;
 	}
 
-	tbl_size = 0;
+	final_tbl_size = 0;
 	if (final_tbl->nr_events != 0) {
 		void *events = (void *)efi.tpm_final_log
 				+ sizeof(final_tbl->version)
 				+ sizeof(final_tbl->nr_events);
 
-		tbl_size = tpm2_calc_event_log_size(events,
-						    final_tbl->nr_events,
-						    log_tbl->log);
+		final_tbl_size = tpm2_calc_event_log_size(events,
+							  final_tbl->nr_events,
+							  log_tbl->log);
 	}
 
-	if (tbl_size < 0) {
+	if (final_tbl_size < 0) {
 		pr_err(FW_BUG "Failed to parse event in TPM Final Events Log\n");
 		ret = -EINVAL;
 		goto out_calc;
 	}
 
 	memblock_reserve(efi.tpm_final_log,
-			 tbl_size + sizeof(*final_tbl));
-	efi_tpm_final_log_size = tbl_size;
+			 final_tbl_size + sizeof(*final_tbl));
+	efi_tpm_final_log_size = final_tbl_size;
 
 out_calc:
 	early_memunmap(final_tbl, sizeof(*final_tbl));
-- 
2.43.0



