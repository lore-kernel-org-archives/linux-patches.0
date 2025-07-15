Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17B92E339B;
	Tue, 15 Jul 2025 13:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586578; cv=none; b=O9fdj+BqEetnYFYK0zF9R7yET+4IOSauBbBA4T2WynadHeEYWrk5uAWG22fMNle74Pzrh4RSuIPzs+/TsJfDt1/QWcsyyvl/fGC1RvSbqy8aXcvHgwfxKOWHQlIDKC9EUwJSA2LkHuhNbK3h86RQ8/mGq36I7Ou9Rr8W7wM4EPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586578; c=relaxed/simple;
	bh=hIAcD5wfmAGWRMfkeEHurxwhk/KrLmzRSqYP7v7FL+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMc7pnZFvFb+yJoWTc/6oAPq3gQ2mpW0DAzMlTHbdVN8WmbdRC8bdaf3+FddSrIbtPkDzJenMj1wDTRFJYxKsBeGuFvhcgh2g524TBnYrYVWV8Ddyc+Ssd54h2qvR401rxVmx169Z53NVtqDC+1cHwkfO2UPFY5L4G9qpWgGYAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucMoniK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucMoniK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AE4C4CEE3;
	Tue, 15 Jul 2025 13:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586578;
	bh=hIAcD5wfmAGWRMfkeEHurxwhk/KrLmzRSqYP7v7FL+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucMoniK3YX++owF/LAkBs65gmh7Obqg+BKpra/sKM2ZEzU7+J7rsD6BGNAIwqkSAD
	 e93pVOc0dlw16cEjcG+BtxrnhVOQikIQl0KKZSsoX95jFZ8DnBjcDVBYPSK6No+XCV
	 ScABvbigRgOr7mQLO6KKwkfE4Sc8TI6OYjE++l/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aijay Adams <aijay@meta.com>,
	JP Kobryn <inwardvessel@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 119/148] x86/mce: Make sure CMCI banks are cleared during shutdown on Intel
Date: Tue, 15 Jul 2025 15:14:01 +0200
Message-ID: <20250715130805.066673256@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JP Kobryn <inwardvessel@gmail.com>

commit 30ad231a5029bfa16e46ce868497b1a5cdd3c24d upstream.

CMCI banks are not cleared during shutdown on Intel CPUs. As a side effect,
when a kexec is performed, CPUs coming back online are unable to
rediscover/claim these occupied banks which breaks MCE reporting.

Clear the CPU ownership during shutdown via cmci_clear() so the banks can
be reclaimed and MCE reporting will become functional once more.

  [ bp: Massage commit message. ]

Reported-by: Aijay Adams <aijay@meta.com>
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/20250627174935.95194-1-inwardvessel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -516,4 +516,5 @@ void mce_intel_feature_init(struct cpuin
 void mce_intel_feature_clear(struct cpuinfo_x86 *c)
 {
 	intel_clear_lmce();
+	cmci_clear();
 }


