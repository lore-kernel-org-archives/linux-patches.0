Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B10348C47;
	Fri,  4 Sep 2026 05:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500846; cv=none; b=cc0g1iCE+2oFSPHkdqOq5UNFpsk4AFgFeYaLOnQK6alZTGKyP5LtbuDs8Q/s9X4tZCFW5AO0ryrDglxVDOiMHfNrdDCBhWeUF9Tf1AoUyZQ4gVSU5rF1xH4zmhJQRvhv1FtitCF7ThCh6bs+drrvKvkDFW/tfKvld5rlhnwSDf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500846; c=relaxed/simple;
	bh=wQKraqDk3+cFXVV+AzlyusqrMknVFzLrP9jVl/nFA8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVa+zAjvcbf6Z40UltfY5tKarPZBigGvbpSO3+24MT+MP0hZt+7IQK9595tG3fDQS5zRaXj/tfUP66+5KapbQyv0LZqSyA0JzAsi5UZfiko4pPuMA8RpXrKYBIK8ubcHxcrK3iRWZKXkIecN4HlRiYLwhzfc5cXCSrH81j9GzVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXQciJEO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXQciJEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9CF1F00A3D;
	Fri,  4 Sep 2026 05:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500844;
	bh=udpgg3Yk8EOXDTPmSgdjq8taqGnqGanXOC+0Y3r2I0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qXQciJEO1SmF6/UmAryRjKp82gg83WLsMApGzD5J19r3b0K+R0TQF2IXsPapIQn91
	 naGg18BQD0YI3NdL2x/zPVJpvUaH/EaC9NvD9z96vKa+gZMrHxcAhGt+gU0YrGGWSl
	 VwqHrhJKVl/Rlkmd8VszyRGd2TUCWc3GdjEmNCaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Anisse Astier <anisse@astier.eu>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18 199/552] efivarfs: Rate limit statfs() handler
Date: Fri,  4 Sep 2026 06:55:56 +0200
Message-ID: <20260904045753.648028643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -89,12 +89,30 @@ static int efivarfs_statfs(struct dentry
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


