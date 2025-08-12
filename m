Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198D4221FAC;
	Tue, 12 Aug 2025 17:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020897; cv=none; b=fpe3ghl/TpRk/itkpDnUsQq2pIjzFV1y4KLzR3LoBVABcaLmEyB9+ugl7EvA3KeXElAndeY+FCI4PcvSB3H7iSMrQChy05pVxYV8lg31Gt1DFzFdPwUuLmR3Mk/PVWKc8ykVaX2/Q3/Gh7kab6GX37kDPBcdfXYf/d0g4ClowaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020897; c=relaxed/simple;
	bh=1nQHgsA1I79OY84Ma2AHcmF4LB3qhKmB9CdBuWp5A+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6ZpRiaw9XqdzjALcr0UbFwD8hqnM5nhD109RkZbwFkTkTw1oxgyeg7NZAMhzjvjfh2mLjweDYmpBZaTrNqB72VDeuN7Ir1XTNmLv2i6QdJaaLzqGHchNMe+SgeKTXsuEHbZAQ+O2v9qD9fEV1J1cKkqTjbINhQ0hRwb0qWu0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dj1SshLr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dj1SshLr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B35FC4CEF0;
	Tue, 12 Aug 2025 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020897;
	bh=1nQHgsA1I79OY84Ma2AHcmF4LB3qhKmB9CdBuWp5A+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj1SshLrxRvuOdPaJU50tO4rBUVuY5OZKC1isMiiiw5YOG0yvX7K5i4krC+j8K6kF
	 ehop8q4INeOfh+zuDTrYDy6h5F6wGB3YBxU7bisEKCqkb1SPzMjR9t9GukmoCAi4zg
	 bVpbHrENE+QRacVLqgjacLLxpiFF/+njErOZdcD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/262] Revert "vmci: Prevent the dispatching of uninitialized payloads"
Date: Tue, 12 Aug 2025 19:26:58 +0200
Message-ID: <20250812172954.251028433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d566103caa27..f22b44827e92 100644
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



