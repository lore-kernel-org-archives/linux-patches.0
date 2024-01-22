Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FBD12AAC7;
	Tue, 23 Jan 2024 00:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968769; cv=none; b=TCZB8LMy6VxQv0TsjjnMidnaMtSwCrr2F717Hhvi421QSSR+FgdW2dMu2N281s/k1nabBGnGsWrmLK+oNxb38IIaO0Ll8S1fxlKFv4gUXWaaqZC6KrmjT2Ci7RkKmfDdRoXYUsYrCDU+mwj6434iv4jv/odvYPA0K1Gza+pyJes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968769; c=relaxed/simple;
	bh=iQtLvWsQaRq+ad83Z5GVSoic7OW4JfoezdjF0pHWDBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oiksa+nWjjTBo9Dq7rwySuSFc27iiFPFCUFEhUn0zdIqlz4EZuyRitJINLgVV0m20IpqIizxPToHJ5oOvI6VgUsDNJ1V8xczWAu8U0InCKPndlFTWiOLH9Etp/iQMyRAJVYAW4IPqn0/HcVwf7jZPygq00LjoZJorcBi3ezQpy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbJUOa5p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbJUOa5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC7DC433C7;
	Tue, 23 Jan 2024 00:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968768;
	bh=iQtLvWsQaRq+ad83Z5GVSoic7OW4JfoezdjF0pHWDBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbJUOa5pJ9bbOQAIfGmerUv361C8mLw6gkBY2np4epOAiEJaMaM7xrysOq/JaofM7
	 DAKSfu+DdKe/fbuQI4FPshYE7eNmIi5ZElzklnXMPB6ZPJYeFxSugoHjbNfoZPhz83
	 bUjWQzMvnX5bV9d8fbBJ0vxZsqOm8pieGI4QGTlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/194] x86/lib: Fix overflow when counting digits
Date: Mon, 22 Jan 2024 15:56:10 -0800
Message-ID: <20240122235720.936600853@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



