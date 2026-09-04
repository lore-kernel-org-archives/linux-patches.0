Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612C223BD1B;
	Fri,  4 Sep 2026 05:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499039; cv=none; b=Yb1t/knocf2YMiZ3wKu1n5jQsmqAZJ14NkoCQPINEEpjj6kTu7azdbl0tFAenKn8x7U9Y6MqOUhgyMnIjgbIfSmLj2JrEmKe3vElunRjvflRSc+Hy0+Lm5JMp0zVyos+HXRIVN8iJVYxt+c66TWdTvBntcudmGdSik1PLnGOWwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499039; c=relaxed/simple;
	bh=YZiOrBrmZ9SFmwL3o9SLys9xH8MKFTDoeuw468j3iw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSF6+nz5wbySDOBWkbxYbK0AOG0zBBhy+oR0WhXME89+xoiTxSusNbsPexbyMvrpL7nHBNe4seI5YwTayk5UdVBDxJ8rBtQSJQouF9/c6OSy1gLr97HAApCq2hLtA8TqLQ4BMv1IP0nMZS0ysdGZQvk7EIItQ6bwcv+5bs9esIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GN8Uv+8H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GN8Uv+8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D871F00A3D;
	Fri,  4 Sep 2026 05:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499038;
	bh=/dsm1Wcn0RBx/6Dq7Osl+cR5LT8nLjQnUuTGIeJI1Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GN8Uv+8H2s0F5PTyjIu82wnxJd4b6u/k4xI/FlmIibacIq78iaNfIzz5cHekFkpC7
	 FqtlW5fMMf7kaG+7Fxify8N8sLDOzdnBja7XxOeYIvhhxiDbvnDGTKQxR2Merk/j9p
	 Hm/KnDlCXQflUq1DFfWsnc3f6u3mWWqZy8MS7ihQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Anisse Astier <anisse@astier.eu>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 7.2 277/713] efivarfs: Rate limit statfs() handler
Date: Fri,  4 Sep 2026 06:54:05 +0200
Message-ID: <20260904045810.049231616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


