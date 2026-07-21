Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D423B6BEB;
	Tue, 21 Jul 2026 21:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668617; cv=none; b=EkFpdQoShxNgAqhVEOxbSuPkyLM+qdX7sc8T+amd9BnX3eUi2cx3PEUUqVxNpj39N550lX6TblVdis+ZQxALbfNKo3eRupH2gF9Eu5YzToR0klaCv9Yttwopy85cNkqSx9C9h0s85VPAoRhpPkz5zMeuS2udZyMK65AILYpBqKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668617; c=relaxed/simple;
	bh=cqdjeFh6JJMJRvTit+4k+NuqnMJsLxTan6SBYHHJrXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PX1m4QSxlnYyfKKGlNhjljwwHpvTIU/eWKL7dGSwR4CwzkO8ACPC/W3SrnqxEkBLLahEraNlXiJrbbZNuap018gCVmij5QnDrdx01K5lXy0dNOpiexa2x38xk7ZFmPW6141Q2NDV47t9Hp9i0uxHwVZyKAQKUp8VMEP2+GuXERA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQTXALwB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQTXALwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6401F00A3A;
	Tue, 21 Jul 2026 21:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668615;
	bh=CZQOgbJSou5BEmkldHy9CJ2zPHtIMlUunfj0e/a77XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQTXALwBQIkgsVUDcgPkoAwuVxjtQvZcDPDhkPFfZE/pB084a0sj9Yq5sE35C520r
	 TLVLDE0wC2wDx7IH50W1GJtWhtGdB9PVAaxEm9V2r5VuSQn/oRcfcpv5oxrazTILNe
	 osUlb66E8XFRzHAgbUJT5qroIe1SkeH3sSbTFbBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0199/1067] efivarfs: fix statfs() on efivarfs
Date: Tue, 21 Jul 2026 17:13:20 +0200
Message-ID: <20260721152429.044577696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>

[ Upstream commit 79b83606abc778aa3cbee535b362ce905d0b9448 ]

Some firmware (notably U-Boot) provides GetVariable() and
GetNextVariableName() but not QueryVariableInfo().

With commit d86ff3333cb1 ("efivarfs: expose used and total size") the
statfs syscall was broken for such firmware.

If QueryVariableInfo() does not exist or returns EFI_UNSUPPORTED, just
report the file system size as 0 as statfs_simple() previously did.

Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
Link: https://lore.kernel.org/all/20230910045445.41632-1-heinrich.schuchardt@canonical.com/
Signed-off-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
[ardb: log warning on QueryVariableInfo() failure]
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/efivarfs/super.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 3fbced52fc6bb8..53d19ecc4385fa 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -33,10 +33,16 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	u64 storage_space, remaining_space, max_variable_size;
 	efi_status_t status;
 
-	status = efivar_query_variable_info(attr, &storage_space, &remaining_space,
-					    &max_variable_size);
-	if (status != EFI_SUCCESS)
-		return efi_status_to_err(status);
+	/* Some UEFI firmware does not implement QueryVariableInfo() */
+	storage_space = remaining_space = 0;
+	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
+		status = efivar_query_variable_info(attr, &storage_space,
+						    &remaining_space,
+						    &max_variable_size);
+		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
+			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",
+					    status);
+	}
 
 	/*
 	 * This is not a normal filesystem, so no point in pretending it has a block
-- 
2.53.0



