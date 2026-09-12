Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D5D2D23A6;
	Sat, 12 Sep 2026 13:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220073; cv=none; b=dmD6OJT5vda8us0urTkavZobVJBSowaS4isMUQEeSWDbpsJa8CmszTAORP41ROgs9TREH4hrfYRGmOe6YHinyC0gVxWT4wywXel/kc43D9L+2vG03z0TAFnrLTq1vP86gDNvhyWuFgu8cQYBgbfJKS3/JNnSbfnPE1GfzPZU0SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220073; c=relaxed/simple;
	bh=gDJGct4HX5AlOmKUQKTbjS6Bq9yLGtl5deuj+WMT+v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jNizoaKG7W2QFjeI/uVL7gOqAA4ZCOvmzRUy1q9z3j+mqSU8s7RfEOScMOZX00GPOPmNWp0tm6QaF2FLES+qjrixhn8NmYb4k9VR460r9M914rOiY+u9FnbbPAtG2YPVp1AU6TPjenqB6OMKxR9nmlVDox19DzBHwKnVxYeRuXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHPN6urG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHPN6urG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC3B1F000FF;
	Sat, 12 Sep 2026 13:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220069;
	bh=pI2s0To+atSXz7u4CS3L+9uY7lkIM/kxQpWni9FgB68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHPN6urGIOQiQgdBfaMIr+OZ9gpzWwcHdZapqtWSxH7W6C6xsi1CZB0/nvUvcvnZt
	 DbwjR7ppb2UGXAsET5lGVTkaRjUDB3wcYJ3XFERrI78BhJPciCGlCaC8U/iMpP2x4j
	 JxwV3/EXi+8fyWrgrJCdPiSJf+87i2JLDybLeAq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Anisse Astier <anisse@astier.eu>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 0101/1424] efivarfs: Rate limit statfs() handler
Date: Sat, 12 Sep 2026 08:42:13 +0200
Message-ID: <20260912065609.567751880@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit b2326338dc683e8c1067c0cbf7a47986c4190902 upstream.

Ravi reports that statfs() may be called by unprivileged users on the
efivarfs mount point, which may result in a flood of calls to the
QueryVariableInfo() runtime service. These calls are disproportionately
costly on x86 systems where the variable store is backed by SMM, as each
SMM entry requires a rendez-vous of all the CPUs.

So rate limit the calls to QueryVariableInfo() at twice per second, and
return the most recently obtained value for calls that are elided.

Cc: <stable@vger.kernel.org>
Reported-by: Ravi Bangoria <ravi.bangoria@amd.com>
Fixes: d86ff3333cb1 ("efivarfs: expose used and total size")
Reviewed-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/efivarfs/super.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -36,12 +36,30 @@ static int efivarfs_statfs(struct dentry
 	/* Some UEFI firmware does not implement QueryVariableInfo() */
 	storage_space = remaining_space = 0;
 	if (efi_rt_services_supported(EFI_RT_SUPPORTED_QUERY_VARIABLE_INFO)) {
-		status = efivar_query_variable_info(attr, &storage_space,
-						    &remaining_space,
-						    &max_variable_size);
-		if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
-			pr_warn_ratelimited("query_variable_info() failed: 0x%lx\n",
-					    status);
+		static DEFINE_RATELIMIT_STATE(_rs, 2 * HZ, 5);
+		static u64 storage, remaining;
+		static DEFINE_SPINLOCK(lock);
+
+		if (!__ratelimit(&_rs)) {
+			ratelimit_set_flags(&_rs, RATELIMIT_MSG_ON_RELEASE);
+
+			spin_lock(&lock);
+			storage_space = storage;
+			remaining_space = remaining;
+			spin_unlock(&lock);
+		} else {
+			status = efivar_query_variable_info(attr, &storage_space,
+							    &remaining_space,
+							    &max_variable_size);
+			if (status != EFI_SUCCESS && status != EFI_UNSUPPORTED)
+				pr_warn("query_variable_info() failed: 0x%lx\n",
+					status);
+
+			spin_lock(&lock);
+			storage = storage_space;
+			remaining = remaining_space;
+			spin_unlock(&lock);
+		}
 	}
 
 	/*


