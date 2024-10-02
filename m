Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67CC1D097D;
	Wed,  2 Oct 2024 14:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878068; cv=none; b=XEywf9pv5yYpp2HGQnR601tULOpMrtfZEEd/6OuX6FRg9B46KgjqEn2ZaYQe/gND08beGkh2903Fn0/L6j8So7iMDru00By+nT53Ir7Czb6KZCvdKekUClgXfuHnKFbbGiX5gpSpzIuR7fx7M+ej93sDNZ7WTVcCwJA576JxSpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878068; c=relaxed/simple;
	bh=uWLX746XEwQrujuzlPazbKCzHFDz70QrLuDUob4iONI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lw+FNIRUYyQKHWVBqz28dG64tW3rU7G099Kz9azgpddOlzhyyywOkdrq/qw+6SKc+ryVjrWOFOKNjsuFOPFxPTGYRMRRP1s4AoCvHX0tPXfO4y/5vyqvtyLg/k3jhwR+fPvanEih4FJWSOS4gzId3T6SDe9dVe3+dm9wpsmd6Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OAtwtNf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OAtwtNf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717C1C4CEC5;
	Wed,  2 Oct 2024 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878067;
	bh=uWLX746XEwQrujuzlPazbKCzHFDz70QrLuDUob4iONI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAtwtNf4nhSCGbNCyefSlO3tUXhB5BXXzrliUtM1x5P7B1lbmCIb/uxLVPdp85Mgq
	 tM2Y8WyFOQ26YWxH5r+AvjiRNbhpZXrJSLmg8fHqHakKF9F9zhWUNUw/X+qdCoPHOC
	 Uk27xCfI4yxwcoLtYj0af8YrHzt9yS/OTA7dpdd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 290/634] bpf: Improve check_raw_mode_ok test for MEM_UNINIT-tagged types
Date: Wed,  2 Oct 2024 14:56:30 +0200
Message-ID: <20241002125822.557048721@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 18752d73c1898fd001569195ba4b0b8c43255f4a ]

When checking malformed helper function signatures, also take other argument
types into account aside from just ARG_PTR_TO_UNINIT_MEM.

This concerns (formerly) ARG_PTR_TO_{INT,LONG} given uninitialized memory can
be passed there, too.

The func proto sanity check goes back to commit 435faee1aae9 ("bpf, verifier:
add ARG_PTR_TO_RAW_STACK type"), and its purpose was to detect wrong func protos
which had more than just one MEM_UNINIT-tagged type as arguments.

The reason more than one is currently not supported is as we mark stack slots with
STACK_MISC in check_helper_call() in case of raw mode based on meta.access_size to
allow uninitialized stack memory to be passed to helpers when they just write into
the buffer.

Probing for base type as well as MEM_UNINIT tagging ensures that other types do not
get missed (as it used to be the case for ARG_PTR_TO_{INT,LONG}).

Fixes: 57c3bb725a3d ("bpf: Introduce ARG_PTR_TO_{INT,LONG} arg types")
Reported-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Link: https://lore.kernel.org/r/20240913191754.13290-4-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e924e520b23ae..c821713249c81 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8158,6 +8158,12 @@ static bool arg_type_is_mem_size(enum bpf_arg_type type)
 	       type == ARG_CONST_SIZE_OR_ZERO;
 }
 
+static bool arg_type_is_raw_mem(enum bpf_arg_type type)
+{
+	return base_type(type) == ARG_PTR_TO_MEM &&
+	       type & MEM_UNINIT;
+}
+
 static bool arg_type_is_release(enum bpf_arg_type type)
 {
 	return type & OBJ_RELEASE;
@@ -9200,15 +9206,15 @@ static bool check_raw_mode_ok(const struct bpf_func_proto *fn)
 {
 	int count = 0;
 
-	if (fn->arg1_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg1_type))
 		count++;
-	if (fn->arg2_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg2_type))
 		count++;
-	if (fn->arg3_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg3_type))
 		count++;
-	if (fn->arg4_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg4_type))
 		count++;
-	if (fn->arg5_type == ARG_PTR_TO_UNINIT_MEM)
+	if (arg_type_is_raw_mem(fn->arg5_type))
 		count++;
 
 	/* We only support one arg being in raw mode at the moment,
-- 
2.43.0



