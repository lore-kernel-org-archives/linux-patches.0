Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9C8399CEC;
	Sat, 12 Sep 2026 20:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243289; cv=none; b=VmGUxROLcDLirG5QXtdoXTVTdFwFc0BQRw1OOmBaWS8I4cuwaBZ6Mn+GAe24u6p1HFVJ7+bdeptZep3hvnpoW/KzyO8l9NxzdiGQ6jX8mq7zGuLBH3/SFvnYWYkS9GBWe2IwVVLG2zbkZ03mD3AqQ+QDDa9aKlH6gfDLMeVwRNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243289; c=relaxed/simple;
	bh=MfPyq4C5gIc63WmNp0lruinSaRCpWQRB00UoxJhTP20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hrc5vXbC5/a9kNz5B7Nb0ncYFiFcFC7q+IbsKdq0bARdjxX6hg6NZFamCSx9KKJs2YT7zKmbIR1UbzjAYxgnJJ/L9JrApiyjfN51+YvU2f6VdEOvf73q8fhyVkxvRqWQX+4G8GtwmxQWQTC3TT5YlGnPcPnnCC6ue/66+/riUKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWxAbD6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWxAbD6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8958C1F000FF;
	Sat, 12 Sep 2026 20:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243288;
	bh=coQ5B3xBXuXJhbcD6dMHHiY0JhJT/BrUARo5jc+CjNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWxAbD6wrsJCcFrp3gMneF49g4ikLDjBdpROkSajo9Exff8MoDVEpNPWyl6VBz8Ld
	 0MpTsJB8L9M7c9Y76JdrLLcCDiZ1/OHW7Q60oC3e17O7pYTlN/UcRQD3Ku6OSQ0CHT
	 4S85f5JhSFfDgcNAsPWziPCGjvUMcolujSk0uZzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bijan Tabatabai <btabatabai@wisc.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 704/798] x86/pkeys: Fix pkey_alloc() return value when pkeys are not supported
Date: Sat, 12 Sep 2026 09:05:32 +0200
Message-ID: <20260912065533.226995190@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bijan Tabatabai <btabatabai@wisc.edu>

[ Upstream commit dee87e09b0dd63da9b1e1876167ccae37842dfd0 ]

The man page for pkey_alloc(2) specifies that it should return -1 with
the errno set to ENOSPC when pkeys are not supported [1]. However, on
x86 pkey_alloc() sets errno to EINVAL when called for the first time
on a CPU that does not support pkeys.

The root cause of this is the x86 implementation of mm_pkey_alloc() not
directly checking if pkeys are supported. It only checks if all the
pkeys have been allocated by comparing the allocation map against
all_pkeys_mask. When OSPKE is not enabled, init_new_context() skips the
initialization of the allocation map, leaving it as 0, while
all_pkeys_mask is 1. mm_pkey_alloc() interprets this as there being a
pkey available and it returns pkey 0. Then, pkey_alloc() fails with
-EINVAL from arch_set_user_pkey_access() instead of returning -ENOSPC.
Subsequent calls to pkey_alloc() do return -ENOSPC because pkey 0 is
left marked as allocated.

Change mm_pkey_alloc() to directly check if OSPKE is enabled, and
return -1 if it is not, which causes pkey_alloc() to return -ENOSPC. The
arm64 and powerpc implementations of mm_pkey_alloc() already do this
check.

[1] https://man7.org/linux/man-pages/man2/pkey_alloc.2.html

[ dhansen: use arch_pkeys_enabled() to follow arm ]

Fixes: e8c24d3a23a4 ("x86/pkeys: Allocation/free syscalls")
Signed-off-by: Bijan Tabatabai <btabatabai@wisc.edu>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://patch.msgid.link/20260716220604.26452-1-bijan311@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/pkeys.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index 2ff9b98812b76..9d23980461f54 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -94,6 +94,9 @@ int mm_pkey_alloc(struct mm_struct *mm)
 	u16 all_pkeys_mask = ((1U << arch_max_pkey()) - 1);
 	int ret;
 
+	if (!arch_pkeys_enabled())
+		return -1;
+
 	/*
 	 * Are we out of pkeys?  We must handle this specially
 	 * because ffz() behavior is undefined if there are no
-- 
2.53.0



