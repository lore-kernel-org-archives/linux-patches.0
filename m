Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C1C1EB5E1;
	Wed, 25 Feb 2026 01:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982929; cv=none; b=Yy6itCiEAlAcJNN12BU98wfR5tscbSw0NWQxFmgcboeOTPpHwB9GcZnRDPR0CCQNzjsbYsuePvqxDpjN9QVn849iIA2SeVX246IxZXhAkt3VXBMK3PhN/uHsje7+eMmxv+4kebuMnupx/76Mbrgu6QFI7M5/OPlVKKB1EmmgyQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982929; c=relaxed/simple;
	bh=gdh1BRCvt/JQWDVhIPjwweDcT0avgYWykmdYqfFbwOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C93YwwWtxKZM1KmYwzLyV2J/d6Dc4SSDjDUs9UPUGbLqaxfY0Xi6JYwumf4Di/5DwQxpH4bbfPS+VoKLINnZ2osV9GjMzNiCqZPe8UNiPVGfaDpq5QB4MPVfU+A47ofHr31Uu7n19aPHw8vI6njRpnTm45OL/QvNaadSH0F/4UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRY5n/8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRY5n/8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D03C116D0;
	Wed, 25 Feb 2026 01:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982929;
	bh=gdh1BRCvt/JQWDVhIPjwweDcT0avgYWykmdYqfFbwOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRY5n/8FviqHtiPcD7vwSK+rOQH92Jo0UGAW1nZP0dD8i3cRBnVyCyAyAAYgm/04m
	 sYvAwVNgt5pWHk1Al4UssOXDftjQd7RHZVtp0apqxzz/KU2vuG9DKtFaN0IgoweriK
	 zog44rQMFlVqh72aBx4M+34hdDeT7/wBjlAGeJVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Rathor <mrathor@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 106/781] x86/hyperv: Fix smp_ops build failure on UP kernels
Date: Tue, 24 Feb 2026 17:13:35 -0800
Message-ID: <20260225012402.285552840@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit ac059ae422d7d05ed9d62970a30fa3b95870b967 ]

CI testing found this build failure:

  arch/x86/hyperv/hv_crash.c:631:9: error: ‘smp_ops’ undeclared (first use in this function)

And I bisected it back to the initial commit that enabled this feature:

  77c860d2dbb72d1f3c6a2e882a07d19eca399db5 is the first bad commit
  commit 77c860d2dbb72d1f3c6a2e882a07d19eca399db5 (HEAD)
  Author: Mukesh Rathor <mrathor@linux.microsoft.com>
  Date:   Mon Oct 6 15:42:08 2025 -0700

  x86/hyperv: Enable build of hypervisor crashdump collection files

Hyperv should probably be limited to SMP kernels, as nobody
appears to be testing it on UP kernels.

Until then, fix the smp_ops assumption. Build tested only.

Fixes: 77c860d2dbb72 ("x86/hyperv: Enable build of hypervisor crashdump collection files")
Cc: Mukesh Rathor <mrathor@linux.microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_crash.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/hyperv/hv_crash.c b/arch/x86/hyperv/hv_crash.c
index c0e22921ace1a..a78e4fed57203 100644
--- a/arch/x86/hyperv/hv_crash.c
+++ b/arch/x86/hyperv/hv_crash.c
@@ -628,7 +628,9 @@ void hv_root_crash_init(void)
 	if (rc)
 		goto err_out;
 
+#ifdef CONFIG_SMP
 	smp_ops.crash_stop_other_cpus = hv_crash_stop_other_cpus;
+#endif
 
 	crash_kexec_post_notifiers = true;
 	hv_crash_enabled = true;
-- 
2.51.0



