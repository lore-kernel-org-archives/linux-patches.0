Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B851018454F;
	Tue, 30 Jul 2024 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356960; cv=none; b=SB9QN/w9W1DsULmmkmTF5QsainiemHxApR6cS/zeqEe/MUIbwQtvHWyphvtRduxkWPu+/bWUxX3nprMJ/BYpr5uZh05Scf6Rk55Z3V44z7+GO1VAb59esesDjpgizi4VnIPRLxu+MoVEViiNJlgLgnT/+/nu7ykWDASKje/uOz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356960; c=relaxed/simple;
	bh=4UXT8R5b45Yt311HmvdRTkbASedqAFbRSc4eC8MAVy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cy/J7Y8AVmqZcIimHKxZ7+a4XzDPWkmzyB5a0O+nK3gDq8mdZ+D4S12C4nsL29aAbXOENHJeLqBE38EzcjTY/JhfHJS3JBDDC1ei8x/II4T+L+MgxbkrokLaqyD+M63BmSftiKkT8h382RoqOmGFU297HLY3Yy81w5ac3i5w5Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RChsa0q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RChsa0q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299C6C4AF0A;
	Tue, 30 Jul 2024 16:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356960;
	bh=4UXT8R5b45Yt311HmvdRTkbASedqAFbRSc4eC8MAVy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RChsa0q42Tv98MP1Rmq5XWxmcGiS2arDy4lX/lMKSTl5JFoulizJlaajY7ot8HErX
	 Vsq20nWcScrN0UHHrvZgQE4LU/WU7OCywV6yXyWr+svM70UVZI66nhZyYmT0QPfmF3
	 JUz23ruVtMW+7GqhDLTwdDbRJ8crPsFHcCGBr9dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 205/809] libbpf: Skip base btf sanity checks
Date: Tue, 30 Jul 2024 17:41:21 +0200
Message-ID: <20240730151732.705229832@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit c73a9683cb21012b6c0f14217974837151c527a8 ]

When upgrading to libbpf 1.3 we noticed a big performance hit while
loading programs using CORE on non base-BTF symbols. This was tracked
down to the new BTF sanity check logic. The issue is the base BTF
definitions are checked first for the base BTF and then again for every
module BTF.

Loading 5 dummy programs (using libbpf-rs) that are using CORE on a
non-base BTF symbol on my system:
- Before this fix: 3s.
- With this fix: 0.1s.

Fix this by only checking the types starting at the BTF start id. This
should ensure the base BTF is still checked as expected but only once
(btf->start_id == 1 when creating the base BTF), and then only
additional types are checked for each module BTF.

Fixes: 3903802bb99a ("libbpf: Add basic BTF sanity validation")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/20240624090908.171231-1-atenart@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 2d0840ef599af..142060bbce0a0 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -598,7 +598,7 @@ static int btf_sanity_check(const struct btf *btf)
 	__u32 i, n = btf__type_cnt(btf);
 	int err;
 
-	for (i = 1; i < n; i++) {
+	for (i = btf->start_id; i < n; i++) {
 		t = btf_type_by_id(btf, i);
 		err = btf_validate_type(btf, t, i);
 		if (err)
-- 
2.43.0



