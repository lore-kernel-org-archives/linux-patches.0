Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2FA14010;
	Tue, 23 Jan 2024 00:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968258; cv=none; b=Gbp2JzjADhJA1gH+VOdl+PY7M2LyaIILTDJj87hcDuRCJ3ziQ+So2EPRe318PwfitO8tfFtMYJmXQ3MzNPreTBgq0vVUQwcix7VyavnVw4nWYkY0YbYjXrEwI0A8IXudq77ZGHWxZH7+h0LC/Bis+4LC+E3OzixslHRGJ2bFwbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968258; c=relaxed/simple;
	bh=ADpL+Of5mkNa8NmULMnfqNRmeVZ8VPmm1tefyXcLTys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jETcMuEtLqkHyl17VqIGRYTmkkAGy6IC23Db5GwxXxDJSOujD4+vO0Q5u9pD2lIbyyygGGejsnPNRw4F9oRogmyjWKSQNpZQ6QLEgG1RQtVrJFOGMJ8oNsZJeTNZ7VALkoy/yanXEMCfHHPyjA4wgrOhU8cW6KuQ1kQHdtbHZ3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qf5+J5vQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qf5+J5vQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDB2C433F1;
	Tue, 23 Jan 2024 00:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968258;
	bh=ADpL+Of5mkNa8NmULMnfqNRmeVZ8VPmm1tefyXcLTys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qf5+J5vQYyX3srhzGQ3JApvWQMbv0Kmo6thDTX+MvbePrTPk3ebwU30yMYrInXdNi
	 rTbGE04yxpZg66NrTNrqSKJ+1fmsMo6qjVQaEZy9k7/cegDk1KnTyrKP8KFVQe/a/P
	 tecNMvN+8zPcx/IYWGoL6ukt3kws8TFj9ImlzjzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/148] x86/lib: Fix overflow when counting digits
Date: Mon, 22 Jan 2024 15:56:23 -0800
Message-ID: <20240122235713.508799482@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit a24d61c609813963aacc9f6ec8343f4fcaac7243 ]

tl;dr: The num_digits() function has a theoretical overflow issue.
But it doesn't affect any actual in-tree users.  Fix it by using
a larger type for one of the local variables.

Long version:

There is an overflow in variable m in function num_digits when val
is >= 1410065408 which leads to the digit calculation loop to
iterate more times than required. This results in either more
digits being counted or in some cases (for example where val is
1932683193) the value of m eventually overflows to zero and the
while loop spins forever).

Currently the function num_digits is currently only being used for
small values of val in the SMP boot stage for digit counting on the
number of cpus and NUMA nodes, so the overflow is never encountered.
However it is useful to fix the overflow issue in case the function
is used for other purposes in the future. (The issue was discovered
while investigating the digit counting performance in various
kernel helper functions rather than any real-world use-case).

The simplest fix is to make m a long long, the overhead in
multiplication speed for a long long is very minor for small values
of val less than 10000 on modern processors. The alternative
fix is to replace the multiplication with a constant division
by 10 loop (this compiles down to an multiplication and shift)
without needing to make m a long long, but this is slightly slower
than the fix in this commit when measured on a range of x86
processors).

[ dhansen: subject and changelog tweaks ]

Fixes: 646e29a1789a ("x86: Improve the printout of the SMP bootup CPU table")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20231102174901.2590325-1-colin.i.king%40gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/misc.c b/arch/x86/lib/misc.c
index a018ec4fba53..c97be9a1430a 100644
--- a/arch/x86/lib/misc.c
+++ b/arch/x86/lib/misc.c
@@ -6,7 +6,7 @@
  */
 int num_digits(int val)
 {
-	int m = 10;
+	long long m = 10;
 	int d = 1;
 
 	if (val < 0) {
-- 
2.43.0



