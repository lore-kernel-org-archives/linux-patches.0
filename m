Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C21F18658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A35C433C7;
	Wed, 20 Sep 2023 11:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210636;
	bh=YwYgdfW/Q8ZaoP0KXcerIq9JqwxS5gG2iQtp5M5DcUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qnf3yTj3SHLositNJGUcgxdLpEi+yavqdJLD5OtypeR16Fi6a9+LFwUxR5hrpxByY
	 54osanaxrhXoCvXdXEWrHB7J6WbtSU/198L70wnMUl7N1ucLjZGo9HNQlBIW6wE/yz
	 Mq9EQGnGpRGkCUXk5HxlMGVDf3HALXpiWbQz90Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 148/211] efivarfs: fix statfs() on efivarfs
Date: Wed, 20 Sep 2023 13:29:52 +0200
Message-ID: <20230920112850.448575957@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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
index e028fafa04f38..996271473609a 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -32,10 +32,16 @@ static int efivarfs_statfs(struct dentry *dentry, struct kstatfs *buf)
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
2.40.1



