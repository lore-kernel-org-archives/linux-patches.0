Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6469B2139C9;
	Tue, 26 Aug 2025 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215676; cv=none; b=XpbN8cAPmx0j1jgGvA4qQk1U1J8EbY/TfsF2RYs0ipCrXVSsxTeQ3mnDmxEn42QDsXbGpqMADqyRQKOwtSAfa+hhT5uOets/tAvaNt8oJA1KHpjOK6HC3KmJ9d01O/2vN0L2PAFr4DgL+SyWippaB/cmwBRY8X+UBk6GttcMRTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215676; c=relaxed/simple;
	bh=/kf5xct5pyw/s188KBVOE4KDlxWeHtk8AB8Q952iUws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfpqyrJy4D6NbUNRUIZI+PpG96oSqN7n+Yzsgbg3xDNeMpxyQw+ue4WRQLJZWKB+7Q8P1jw2VY9Wr94L9wCo7PlTSWb8AFTE/CaewSfyb71wI4z4FclYV8QWigr7Gwh260rwx6t8OtGmbNSCrHvenBS8mcdldzCVyJle69fG5q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqD12r7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqD12r7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E165AC4CEF1;
	Tue, 26 Aug 2025 13:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215676;
	bh=/kf5xct5pyw/s188KBVOE4KDlxWeHtk8AB8Q952iUws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqD12r7Awof51eWptYC29W3p5vw1LOqtVTcPiOTKFu1SK1OSiomxfJBUBu7mwZ1xI
	 m0HSrRAgNk//jcxpJT9HKqqzxzYZRT4CuNlCnIKCCz6y5FYbF/JT1Rm52jq5xwtC34
	 TqPLmZbIbuUsrp/HPukMRUaTisSWtIG/ZlGKhoD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/644] Revert "vmci: Prevent the dispatching of uninitialized payloads"
Date: Tue, 26 Aug 2025 13:03:33 +0200
Message-ID: <20250826110949.542233978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 8f5d9bed6122b8d96508436e5ad2498bb797eb6b ]

This reverts commit bfb4cf9fb97e4063f0aa62e9e398025fb6625031.

While the code "looks" correct, the compiler has no way to know that
doing "fun" pointer math like this really isn't a write off the end of
the structure as there is no hint anywhere that the structure has data
at the end of it.

This causes the following build warning:

In function 'fortify_memset_chk',
    inlined from 'ctx_fire_notification.isra' at drivers/misc/vmw_vmci/vmci_context.c:254:3:
include/linux/fortify-string.h:480:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  480 |                         __write_overflow_field(p_size_field, size);
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

So revert it for now and it can come back in the future in a "sane" way
that either correctly makes the structure know that there is trailing
data, OR just the payload structure is properly referenced and zeroed
out.

Fixes: bfb4cf9fb97e ("vmci: Prevent the dispatching of uninitialized payloads")
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Link: https://lore.kernel.org/r/20250703171021.0aee1482@canb.auug.org.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_context.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
index a8df60b9301c..c0b5e339d5a1 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -251,8 +251,6 @@ static int ctx_fire_notification(u32 context_id, u32 priv_flags)
 		ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 						  VMCI_CONTEXT_RESOURCE_ID);
 		ev.msg.hdr.payload_size = sizeof(ev) - sizeof(ev.msg.hdr);
-		memset((char*)&ev.msg.hdr + sizeof(ev.msg.hdr), 0,
-			ev.msg.hdr.payload_size);
 		ev.msg.event_data.event = VMCI_EVENT_CTX_REMOVED;
 		ev.payload.context_id = context_id;
 
-- 
2.39.5



