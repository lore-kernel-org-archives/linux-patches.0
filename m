Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033D834CFD6;
	Tue,  6 Jan 2026 17:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720021; cv=none; b=PMRw+HI6GTtFaXkLzlHoDdBOnsIsYfoSLNsMQkCykKpkvhtbNy3D0y2JU0JT2H5/+BC9WkNxAvZ9vBAKHyX2PEcBYHAMYXprG1o26kvrM7DqPeVWnyEqBwaqfrgaochehWKuLmurVNijLrXjj7LbJX2K5ZjrPrvv6t2sJrI4mow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720021; c=relaxed/simple;
	bh=dD3+Hs54T1oHQiGFq7qokp2Rpv1DcDqHYfE4rE1xNPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0FxnQniVEQT6UBj51BDts1oUi1sY4MkPmZOh0poZ+hp+rEHbVrGuj6Rs9am0fHshpbx2uAs3gDbFnfbU28tjDazp2s+Jld1YR86iU4tji7Sk5Ky5IDNMSaJtfZIpHiAAo+TeC9VdGMaoqAOk19pEaG6H3vOiI4n30BpdnBdePA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/KyXoZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/KyXoZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C603C116C6;
	Tue,  6 Jan 2026 17:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720020;
	bh=dD3+Hs54T1oHQiGFq7qokp2Rpv1DcDqHYfE4rE1xNPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/KyXoZxPj4Cnw1J5ptY7GT6TCAl7u4KomSFDl8W52dVcOB3dfqN8ulW4bmyNnyc/
	 8AuqLpIjKd6/4DnYxVOafntLN8jnkGxFsOAfIZtjPY4iQRgj6CSPPT9IC2tugXnbAK
	 ZvfFUL/ZrL/HS3DaEJVD9X56RZeyGV40w+vV00Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongxin Liu <yongxin.liu@windriver.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/567] x86/fpu: Fix FPU state core dump truncation on CPUs with no extended xfeatures
Date: Tue,  6 Jan 2026 17:58:13 +0100
Message-ID: <20260106170455.435476784@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Yongxin Liu <yongxin.liu@windriver.com>

[ Upstream commit c8161e5304abb26e6c0bec6efc947992500fa6c5 ]

Zero can be a valid value of num_records. For example, on Intel Atom x6425RE,
only x87 and SSE are supported (features 0, 1), and fpu_user_cfg.max_features
is 3. The for_each_extended_xfeature() loop only iterates feature 2, which is
not enabled, so num_records = 0. This is valid and should not cause core dump
failure.

The issue is that dump_xsave_layout_desc() returns 0 for both genuine errors
(dump_emit() failure) and valid cases (no extended features). Use negative
return values for errors and only abort on genuine failures.

Fixes: ba386777a30b ("x86/elf: Add a new FPU buffer layout info to x86 core files")
Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20251210000219.4094353-2-yongxin.liu@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 22abb5ee0cf2..aacb59c4a35c 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1879,7 +1879,7 @@ static int dump_xsave_layout_desc(struct coredump_params *cprm)
 		};
 
 		if (!dump_emit(cprm, &xc, sizeof(xc)))
-			return 0;
+			return -1;
 
 		num_records++;
 	}
@@ -1917,7 +1917,7 @@ int elf_coredump_extra_notes_write(struct coredump_params *cprm)
 		return 1;
 
 	num_records = dump_xsave_layout_desc(cprm);
-	if (!num_records)
+	if (num_records < 0)
 		return 1;
 
 	/* Total size should be equal to the number of records */
-- 
2.51.0



