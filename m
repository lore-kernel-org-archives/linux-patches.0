Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C26C352017;
	Sat, 12 Sep 2026 15:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226974; cv=none; b=TvEwtC9S+SX7CW1Kz0v7lnjx9DG5sdFo2/WlBMQyGKUPZDeXJUVH7EKTRQQc/HFrpgb1womEaMsi3KHehFv5pfBcBm8jQ9Z3YWtZItIp3oVZB2rQXTrm8rEY+QvZ3vWOF475NnStF+zBYMwQV3f6Vf8LSl2LV75DgVKzOpza17g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226974; c=relaxed/simple;
	bh=40BfSrsEnr8cwvUkv4nl6xV4fiUWOrEGD2/AisKyCtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jtf1dh3UcXzG0r0M+R+I1QJkGKEjCaHtfCPTeaAuts1SAhOIFpZhGqfDyPHFCt70pJn6q8fINP3AhhgGh+4cdjKzFKzCeGMCqwtsxMeeq52KjzfyrdmHqoLpZ6DxU0UvDUHOzCkKOTvajf0O386j2WCmGMGlzrziAmZzvXLoNFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMTRdKmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMTRdKmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEDC1F000FF;
	Sat, 12 Sep 2026 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226973;
	bh=FpGgNTvVF08B/+zW3CwCo0dBjiID0GqndWmYUFk25Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMTRdKmFSrfmrpkm6UIK+d2vr0g73CwrZkc+XJxdq2G10Ik9tStymfG7yFhSt1i4N
	 Xb1po2XuE2NJiGnW1NrK9Hjc1l6B9tn1/XZ+e15DFyLsXu0Z45kOi9zYyvi7RFQrZ3
	 vuoV/MNdLKRCKuQCSKvOlCUDOzyE1UdUBE89E/nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Anisse Astier <anisse@astier.eu>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 0085/1191] efivarfs: Rate limit statfs() handler
Date: Sat, 12 Sep 2026 08:46:53 +0200
Message-ID: <20260912065550.086547486@linuxfoundation.org>
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


