Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA47630FC0C;
	Mon, 13 Oct 2025 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368959; cv=none; b=n5eMx8Etol0xyshu2MGRPk3sV/fBcEOtu5qWwX62TctzPBwSjxbTX/lOJLMcxaKlXwuw0w8QdELFca5CJFhXikK+VEZH+hjI2CUY7dXJivRgEJ/ICgCk79/nxOtCiP4oC/IfUwd3QCNfCNq49z8uHNjcwcs9f9d8Mux96o0PLIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368959; c=relaxed/simple;
	bh=zMYobK/ABnSR1/oHInTfxeAlOG2JT2sWWD37e+Qj48k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOHiQE62mK7o2AwTIFBdkVL8xvUqFjnltIyz8dVsmyOeOdltk/ZYRRLvIAEhpXfeWIdoruNNcVcJQkOQ5t2gcoN4SHlHeR0zeoHM8TvRKbCXlFBuATVjy3DKYIsruRYjMaYhI8b1pYRi0qs4nssQGgT1gP5/C0MtdQLC9sSAIN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfKA5iXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfKA5iXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A12AC4CEE7;
	Mon, 13 Oct 2025 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368958;
	bh=zMYobK/ABnSR1/oHInTfxeAlOG2JT2sWWD37e+Qj48k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfKA5iXPRBl8tHcLNQfRqQyh9TSsvlHOTauUK4D6TtqPiP5VZwxZ8XgKzX31+uK6y
	 xBH2yr1g8BGcmBNTf5i1fllaBtsi/8jJ0P+YzfeHGDctvbJlg45/Gcba1VnfsgZUrq
	 tKhazIhkEhTUXK9mxstkd0KFPIQazUyrF1S+DXP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 078/563] selftests/futex: Fix some futex_numa_mpol subtests
Date: Mon, 13 Oct 2025 16:38:59 +0200
Message-ID: <20251013144414.116532219@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit d8e2f919997b14665e4509ef9a5278f291598d6e ]

The "Memory out of range" subtest of futex_numa_mpol assumes that memory
access outside of the mmap'ed area is invalid. That may not be the case
depending on the actual memory layout of the test application. When that
subtest was run on an x86-64 system with latest upstream kernel, the test
passed as an error was returned from futex_wake(). On another PowerPC system,
the same subtest failed because futex_wake() returned 0.

  Bail out! futex2_wake(64, 0x86) should fail, but didn't

Looking further into the passed subtest on x86-64, it was found that an
-EINVAL was returned instead of -EFAULT. The -EINVAL error was returned
because the node value test with FLAGS_NUMA set failed with a node value
of 0x7f7f. IOW, the futex memory was accessible and futex_wake() failed
because the supposed node number wasn't valid. If that memory location
happens to have a very small value (e.g. 0), the test will pass and no
error will be returned.

Since this subtest is non-deterministic, drop it unless a guard page beyond
the mmap region is explicitly set.

The other problematic test is the "Memory too small" test. The futex_wake()
function returns the -EINVAL error code because the given futex address isn't
8-byte aligned, not because only 4 of the 8 bytes are valid and the other
4 bytes are not. So change the name of this subtest to "Mis-aligned futex" to
reflect the reality.

  [ bp: Massage commit message. ]

Fixes: 3163369407ba ("selftests/futex: Add futex_numa_mpol")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/20250827130011.677600-3-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/functional/futex_numa_mpol.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/futex_numa_mpol.c b/tools/testing/selftests/futex/functional/futex_numa_mpol.c
index a9ecfb2d3932a..802c15c821906 100644
--- a/tools/testing/selftests/futex/functional/futex_numa_mpol.c
+++ b/tools/testing/selftests/futex/functional/futex_numa_mpol.c
@@ -182,12 +182,10 @@ int main(int argc, char *argv[])
 	if (futex_numa->numa == FUTEX_NO_NODE)
 		ksft_exit_fail_msg("NUMA node is left uninitialized\n");
 
-	ksft_print_msg("Memory too small\n");
+	/* FUTEX2_NUMA futex must be 8-byte aligned */
+	ksft_print_msg("Mis-aligned futex\n");
 	test_futex(futex_ptr + mem_size - 4, 1);
 
-	ksft_print_msg("Memory out of range\n");
-	test_futex(futex_ptr + mem_size, 1);
-
 	futex_numa->numa = FUTEX_NO_NODE;
 	mprotect(futex_ptr, mem_size, PROT_READ);
 	ksft_print_msg("Memory, RO\n");
-- 
2.51.0



