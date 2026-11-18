Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020447;
	b=5ZAkABz1f2Je/HrNkNMwhVMZz/o0HiMevGvsBohAZoqDJuCI5xdAPXr9JB7VZRlWafDl
	 RdZzc1oDQNijnaXoVc3qC6IzXeM1PK+gfvF+kA7asrM8pP5bOKfbolf6YRcfeDn4szGZ7
	 sfuKizRk7IFC4A3Q27aQ/vt4HvMfMpJPb+Pig/+Rv0EPQKreW7LSXoXnXa8PBUJSurtC6
	 egy0EcAOWp8A94oLmzF8hl3XNoIDODHVEeCNZFJnlP8y5wwfpNsyTWIRsREZqvuNfqtRZ
	 oNrxZQJfPQLc9f4Lrud8fOwMt1/Rm+LEX1TLptsATTt5kI09HSvlk1TSGPv0uxNitAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mVuSUEigH7R5j0OXB7caVT34EnVlBFvtjU/m9Vt8C4s=;
	b=mmYZDMqIaAxRnFTi05CB1MWzCURAcdroytBzVlGavjMpyBib5dmVtHL3aM8nA39iJeRn
	 alKYYxnWUvLhRAyy7Ov3gDvYn5g9hARJZwue+95poK8XlCaU8gCN+6txPhL6iGmuP4G26
	 WHJqRg1gmAfIn3f8CLvRN4um/3ER0hLdhWPFjqnA8zvGu4H8nmFMyArzSMI7YmDN48VOB
	 rO85JX+IY2S6nAwZOEvgAONy2VywymIq/6ZYWGEcJubTqc9z3kGCt0LPBAQwEjydMpjOA
	 UsLIw+ydRS/OEBVK/nxPCwwn7zjLLE3yecal9IdVLJUOKpGdRHCF7yZK8v4VwbGqmOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzPW6dfA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31F0606A325;
	Wed, 18 Nov 2026 16:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzPW6dfA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD57C1F000C4;
	Wed, 18 Nov 2026 16:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020447;
	bh=mVuSUEigH7R5j0OXB7caVT34EnVlBFvtjU/m9Vt8C4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzPW6dfAEAIaY0WSM9hNyChcVWOQM9D105DSS3+PTY1VDlYzTSrsvpZQIzOOnne7p
	 Vl1/18vE3ro/A700uGLDYusP69DnAjiJ5znTsuBTuzHstD1G5PSjjMXPfO41iPM7zh
	 Bre31wnYZKi6rD2oUWUsumZ/QY+3fqFSM+ttq7K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1954/2651] efi/runtime-wrappers: Dont park the worker after a recovered firmware fault
Date: Wed, 18 Nov 2026 15:53:14 +0100
Message-ID: <20261118150356.903933957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit b49be1e7478afdb4ec96aedeb17f906253326c48 ]

Commit 4b2c033b5bc9 ("efi/runtime-wrappers: retire the worker if a wedged
call ever returns") parks the efi_rts_wq worker instead of completing the
call if EFI runtime services have been disabled by the time the firmware
returns. The assumption is that this only happens if __efi_queue_work()
has given up waiting for the call.

However, arm64 also disables EFI runtime services when it recovers from a
synchronous exception taken by the firmware: efi_runtime_fixup_exception()
clears EFI_RUNTIME_SERVICES and unwinds the call so that it returns
EFI_ABORTED to efi_call_rts(), while the caller is still waiting for the
completion. The worker now parks without signalling it, so the caller is
stuck for the full EFI_RTS_TIMEOUT of 120 seconds, after which it reports
that the firmware is wedged, which is misleading.

x86 is not affected, as it signals the completion from its page fault
handler before parking the worker.

So record explicitly that the caller has given up on the call, and only
park the worker in that case.

Fixes: 4b2c033b5bc9 ("efi/runtime-wrappers: retire the worker if a wedged call ever returns")
Cc: Breno Leitao <leitao@debian.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 2344b9d1e81f8..8f4de91727d0b 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -126,6 +126,12 @@ struct efi_runtime_work efi_rts_work;
  */
 #define EFI_RTS_TIMEOUT		(120 * HZ)
 
+/*
+ * Set when __efi_queue_work() gives up waiting for a call that is wedged in
+ * firmware. EFI runtime services are disabled for good at that point.
+ */
+static bool efi_rts_abandoned;
+
 /*
  * efi_queue_work:	Queue EFI runtime service call and wait for completion
  * @_rts:		EFI runtime service function identifier
@@ -336,7 +342,12 @@ static void __nocfi efi_call_rts(struct work_struct *work)
 	efi_call_virt_check_flags(flags, efi_rts_work.caller);
 	arch_efi_call_virt_teardown();
 
-	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+	/*
+	 * EFI runtime services may also have been disabled because the
+	 * firmware faulted, but the caller is still waiting for us in that
+	 * case. Only park the worker if the caller has given up on it.
+	 */
+	if (READ_ONCE(efi_rts_abandoned))
 		efi_rts_park_worker();
 
 	efi_rts_work.status = status;
@@ -373,6 +384,7 @@ static efi_status_t __efi_queue_work(enum efi_rts_ids id,
 					 EFI_RTS_TIMEOUT)) {
 		pr_err("EFI runtime service %d wedged in firmware; disabling EFI runtime services\n",
 		       id);
+		WRITE_ONCE(efi_rts_abandoned, true);
 		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return EFI_ABORTED;
 	}
-- 
2.53.0



