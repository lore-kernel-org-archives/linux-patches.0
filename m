Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708AC29B781;
	Fri,  4 Sep 2026 06:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502249; cv=none; b=P8J5WmMhtkkPe+OrE3TgprLIjF6k0uGnaPfE/sxTppbIXbq9+e9r/wjo8u2gM1pGipry2gG32GoxahuDt1H1xz8GLlyWEjGorEv7etenlVWTBvNX6rKKeDYJraMcxPzJ2izhdxYPoN1qv93CUcdFqUhptg2LkK8Np0QmqD0UzB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502249; c=relaxed/simple;
	bh=AKTYo5qKXUDVwTwTkn1R1+zRuzBdnPj/mHOxxDFQdsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1PuFoQ8RTSbwoqXBsrSugIf7la4CIxvOwJ9MuWnhyJVDCYmTYeXjssDkmG3V/mmQXqgE4Us8PW9ENZbhZDlh5nAwVa4bdbL7k+QFIo+DQblFBdsHwwbZcvSMrBq9BJfSYyiz85Rnn4SG0UPA1VjdkAf4Qcthz9JhSn9A9xWeSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5TToNo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5TToNo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84C81F00A3E;
	Fri,  4 Sep 2026 06:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502248;
	bh=Sd+J9eNhsBaWDB5bwJbxu+1YeypJzfV1B2XNGOpsAjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5TToNo83KH4wv45H4Wb+DBNTw9WtKMF3+0YdAsGi7m42sgQd08lVCzozywn6RZFJ
	 M1mdtHpEVLxp1aqCm73Derwu9XIO7ih04Gw/ndnV2W967ehPzHADxsOAfJwh+LoeXP
	 IRybsYQu2vcHfABna7SAjeribf9qymChu9ohlu2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Anisse Astier <anisse@astier.eu>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.12 142/403] efivarfs: Rate limit statfs() handler
Date: Fri,  4 Sep 2026 06:59:05 +0200
Message-ID: <20260904045738.073825501@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -71,12 +71,30 @@ static int efivarfs_statfs(struct dentry
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


