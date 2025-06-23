Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4274B2512FC;
	Mon, 23 Jun 2025 13:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684310; cv=none; b=OdgoEdGObumlrMmR8z0MHHwXd9BaKousMVOs/Zf6+wepb8NX850Au3Bu8yJu5C6vjRIcyZit/9KxvvReLGPWG9RdO/kaD6QRZox0DHM+cBjf45VxSDQkxnm/gdKi5sDiffw2gcqU/l1qjNfckstBz3tvUb+quAZSNHDSggf8pv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684310; c=relaxed/simple;
	bh=lYqawUaMkkjxYi7VvEq+m24b4mPxhtdlFIsdJOmGQNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XShZOHy5a2w4dP9r58UCwfXDRiRT11TaMZ1c2k2vCdq6444bitWIMfCr+lgvlwyVKEMvo6BKpQdYZ3PvL0AFosiVMDfJwZos69xlLgKcZpkXTM1KGryvPA2VU34l+TlEfO5ZByRAvEVlXa8Gog3lymORsKg73KkuFcUVe9HM6sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aVHTfMjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aVHTfMjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EE5C4CEEA;
	Mon, 23 Jun 2025 13:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684310;
	bh=lYqawUaMkkjxYi7VvEq+m24b4mPxhtdlFIsdJOmGQNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVHTfMjK6D0BsxGtcRLcEoLaWHrDIon87WstLobqp65yt7M6OkoLLjTGZD9hLYRoS
	 NlcI+xChBBGlurlxt70WrQsjpKgUvOQRbkAkji2ELVO7nwK4WfZbVoEWVFk70rEsO5
	 MSLlc+JHOhNUUCmXLaZZnXLv3sNlggV4epYTOkzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.15 020/592] powerpc64/ftrace: fix clobbered r15 during livepatching
Date: Mon, 23 Jun 2025 14:59:38 +0200
Message-ID: <20250623130700.709297527@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Bathini <hbathini@linux.ibm.com>

commit cb5b691f8273432297611863ac142e17119279e0 upstream.

While r15 is clobbered always with PPC_FTRACE_OUT_OF_LINE, it is
not restored in livepatch sequence leading to not so obvious fails
like below:

  BUG: Unable to handle kernel data access on write at 0xc0000000000f9078
  Faulting instruction address: 0xc0000000018ff958
  Oops: Kernel access of bad area, sig: 11 [#1]
  ...
  NIP:  c0000000018ff958 LR: c0000000018ff930 CTR: c0000000009c0790
  REGS: c00000005f2e7790 TRAP: 0300   Tainted: G              K      (6.14.0+)
  MSR:  8000000000009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 2822880b  XER: 20040000
  CFAR: c0000000008addc0 DAR: c0000000000f9078 DSISR: 0a000000 IRQMASK: 1
  GPR00: c0000000018f2584 c00000005f2e7a30 c00000000280a900 c000000017ffa488
  GPR04: 0000000000000008 0000000000000000 c0000000018f24fc 000000000000000d
  GPR08: fffffffffffe0000 000000000000000d 0000000000000000 0000000000008000
  GPR12: c0000000009c0790 c000000017ffa480 c00000005f2e7c78 c0000000000f9070
  GPR16: c00000005f2e7c90 0000000000000000 0000000000000000 0000000000000000
  GPR20: 0000000000000000 c00000005f3efa80 c00000005f2e7c60 c00000005f2e7c88
  GPR24: c00000005f2e7c60 0000000000000001 c0000000000f9078 0000000000000000
  GPR28: 00007fff97960000 c000000017ffa480 0000000000000000 c0000000000f9078
  ...
  Call Trace:
    check_heap_object+0x34/0x390 (unreliable)
  __mutex_unlock_slowpath.isra.0+0xe4/0x230
  seq_read_iter+0x430/0xa90
  proc_reg_read_iter+0xa4/0x200
  vfs_read+0x41c/0x510
  ksys_read+0xa4/0x190
  system_call_exception+0x1d0/0x440
  system_call_vectored_common+0x15c/0x2ec

Fix it by restoring r15 always.

Fixes: eec37961a56a ("powerpc64/ftrace: Move ftrace sequence out of line")
Reported-by: Viktor Malik <vmalik@redhat.com>
Closes: https://lore.kernel.org/lkml/1aec4a9a-a30b-43fd-b303-7a351caeccb7@redhat.com
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Tested-by: Viktor Malik <vmalik@redhat.com>
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250416191227.201146-1-hbathini@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/trace/ftrace_entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/trace/ftrace_entry.S
+++ b/arch/powerpc/kernel/trace/ftrace_entry.S
@@ -212,10 +212,10 @@
 	bne-	1f
 
 	mr	r3, r15
+1:	mtlr	r3
 	.if \allregs == 0
 	REST_GPR(15, r1)
 	.endif
-1:	mtlr	r3
 #endif
 
 	/* Restore gprs */


