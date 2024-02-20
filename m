Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81342151CDF;
	Tue, 20 Feb 2024 21:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462869; cv=none; b=DU18S47IJwYLKILBqYDcnWk2XJD9L8X1GC5P6Q/2AbDelLu8LggTPLdn2xXu6SwAHNY9e+FBQPVQ3XuZ9MgSyr9L0K1VnilvkX37a6G5PCn26NcErHc2zvYrVZWsDDdLePZODJtg6RJgoanW5KnYxgseSOocZybTqwvFbuGQ47c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462869; c=relaxed/simple;
	bh=Xx3NyURWlUovmXX+ouWS2Kz1NgT7OmOxLNibTczDMiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJ6rOrxDgNKuQmHk4XpbJ0GflfUrS/nR4mllG/g7pkba7+DH4kyZhb6jkhxFMLsZ7eQXU6ECebOM6by5RWUVEPad14IoEGwLi42ykKpSCFlN5n9KckQTvYilI+4WOoz0VFvLnNhhkTX3xwfSElM0sYwubPTX6QcfxJNV29ksGHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fzoZX644; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fzoZX644"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E8EC43390;
	Tue, 20 Feb 2024 21:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462869;
	bh=Xx3NyURWlUovmXX+ouWS2Kz1NgT7OmOxLNibTczDMiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fzoZX644VG4o7BTiI6chh7vVSzY4JvX3YfKJZjADNkEBLTA2b+HQXvNvoQ1psBoWz
	 KWzeVDdD4GawfzGHlfPTTlrBv+1da056Con33prPuxnlpGGHTugvwdbAiFBAnVkTt0
	 8WZ08qHI5xhPE9TxsLMwA+ZqWuj3mjC1rOtBjMO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Spoorthy <spoorthy@linux.ibm.com>,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/197] powerpc/kasan: Limit KASAN thread size increase to 32KB
Date: Tue, 20 Feb 2024 21:50:21 +0100
Message-ID: <20240220204842.938914265@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f1acb109505d983779bbb7e20a1ee6244d2b5736 ]

KASAN is seen to increase stack usage, to the point that it was reported
to lead to stack overflow on some 32-bit machines (see link).

To avoid overflows the stack size was doubled for KASAN builds in
commit 3e8635fb2e07 ("powerpc/kasan: Force thread size increase with
KASAN").

However with a 32KB stack size to begin with, the doubling leads to a
64KB stack, which causes build errors:
  arch/powerpc/kernel/switch.S:249: Error: operand out of range (0x000000000000fe50 is not between 0xffffffffffff8000 and 0x0000000000007fff)

Although the asm could be reworked, in practice a 32KB stack seems
sufficient even for KASAN builds - the additional usage seems to be in
the 2-3KB range for a 64-bit KASAN build.

So only increase the stack for KASAN if the stack size is < 32KB.

Fixes: 18f14afe2816 ("powerpc/64s: Increase default stack size to 32KB")
Reported-by: Spoorthy <spoorthy@linux.ibm.com>
Reported-by: Benjamin Gray <bgray@linux.ibm.com>
Reviewed-by: Benjamin Gray <bgray@linux.ibm.com>
Link: https://lore.kernel.org/linuxppc-dev/bug-207129-206035@https.bugzilla.kernel.org%2F/
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240212064244.3924505-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/thread_info.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index af58f1ed3952..c4b798aa6ce8 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -14,7 +14,7 @@
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_KASAN
+#if defined(CONFIG_KASAN) && CONFIG_THREAD_SHIFT < 15
 #define MIN_THREAD_SHIFT	(CONFIG_THREAD_SHIFT + 1)
 #else
 #define MIN_THREAD_SHIFT	CONFIG_THREAD_SHIFT
-- 
2.43.0



