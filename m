Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FBE51C44;
	Tue, 23 Jan 2024 01:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974048; cv=none; b=TQORyum3aVhnknBLWFIK+uEXVl+fOKEtnv+kpco6tCSCRBpmv0AhVl8G6WiZDK2KgM47E9O81mruioO0rl8OvxkvyCvuY3fccfjTYShbginiLZwhNbEJ3F0iYaGePblTloUfq9JHwTJy9ldZWkRnJhbwInm6itkxtCswnL25WlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974048; c=relaxed/simple;
	bh=wlDSfpqZsuysaByQVHdgj3Tb2DnkNjQyPvtwmYPfayw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlaYhvqaz5c1imirImagdIuOItVyPUd4IiOS5wsQ1zludpjjWUPeB2nNmj5aljL5uij85xwCKr6TrnRTNtgxDNNTa7Z8bAAtb1U/NviVC+NiYV83nQ5izp3sE/QZljp7xYiEJBO7IOCgJ80Jk7Xw6yNbhu97hNMwJi251o4OG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1ZUSdlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1ZUSdlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E86C43390;
	Tue, 23 Jan 2024 01:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974048;
	bh=wlDSfpqZsuysaByQVHdgj3Tb2DnkNjQyPvtwmYPfayw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1ZUSdlgqEiimWNsL6Zmg27HB5aZeXnQll1UVbxbXGyA330eJ7P978PAcUyELpmrm
	 ZQ9srnL/LGyIunOKDhZIDrb0qWYvX2bd3TzH7ZcmcCzduILFMIR58QKyF1flsgTqfJ
	 x3URzCRgptXhHD4aGxO5Toe5lwCaEarUz24iv7M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Andrei Matei <andreimatei1@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/374] bpf: Fix verification of indirect var-off stack access
Date: Mon, 22 Jan 2024 15:56:36 -0800
Message-ID: <20240122235749.500212645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit a833a17aeac73b33f79433d7cee68d5cafd71e4f ]

This patch fixes a bug around the verification of possibly-zero-sized
stack accesses. When the access was done through a var-offset stack
pointer, check_stack_access_within_bounds was incorrectly computing the
maximum-offset of a zero-sized read to be the same as the register's min
offset. Instead, we have to take in account the register's maximum
possible value. The patch also simplifies how the max offset is checked;
the check is now simpler than for min offset.

The bug was allowing accesses to erroneously pass the
check_stack_access_within_bounds() checks, only to later crash in
check_stack_range_initialized() when all the possibly-affected stack
slots are iterated (this time with a correct max offset).
check_stack_range_initialized() is relying on
check_stack_access_within_bounds() for its accesses to the
stack-tracking vector to be within bounds; in the case of zero-sized
accesses, we were essentially only verifying that the lowest possible
slot was within bounds. We would crash when the max-offset of the stack
pointer was >= 0 (which shouldn't pass verification, and hopefully is
not something anyone's code attempts to do in practice).

Thanks Hao for reporting!

Fixes: 01f810ace9ed3 ("bpf: Allow variable-offset stack access")
Reported-by: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231207041150.229139-2-andreimatei1@gmail.com

Closes: https://lore.kernel.org/bpf/CACkBjsZGEUaRCHsmaX=h-efVogsRfK1FPxmkgb0Os_frnHiNdw@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cc284371eea0..c2ecf349523d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4305,10 +4305,7 @@ static int check_stack_access_within_bounds(
 
 	if (tnum_is_const(reg->var_off)) {
 		min_off = reg->var_off.value + off;
-		if (access_size > 0)
-			max_off = min_off + access_size - 1;
-		else
-			max_off = min_off;
+		max_off = min_off + access_size;
 	} else {
 		if (reg->smax_value >= BPF_MAX_VAR_OFF ||
 		    reg->smin_value <= -BPF_MAX_VAR_OFF) {
@@ -4317,15 +4314,12 @@ static int check_stack_access_within_bounds(
 			return -EACCES;
 		}
 		min_off = reg->smin_value + off;
-		if (access_size > 0)
-			max_off = reg->smax_value + off + access_size - 1;
-		else
-			max_off = min_off;
+		max_off = reg->smax_value + off + access_size;
 	}
 
 	err = check_stack_slot_within_bounds(min_off, state, type);
-	if (!err)
-		err = check_stack_slot_within_bounds(max_off, state, type);
+	if (!err && max_off > 0)
+		err = -EINVAL; /* out of stack access into non-negative offsets */
 
 	if (err) {
 		if (tnum_is_const(reg->var_off)) {
-- 
2.43.0



