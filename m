Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7232144C4;
	Thu, 12 Dec 2024 16:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019225; cv=none; b=GMzZuWNRZqQ13ES9G9psEPBNLozgzmGoNFerhHoYI9WGRUWshRnWv4TdTNoqD5G3zmA679hIjDw8nNH0nRFw7hdwnCKQjkGnAeH7501RQ/hnbnrQMr2B4tV5gOUo9gK6ug2ostxN0JcnkhsScMO0Bu5dV5+jM1IMhZ/Ymfi8WtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019225; c=relaxed/simple;
	bh=zxLclcoFlJsZmB70hz4Yu8d/C3rmlpB4tET+sKtnfw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ty17UhDYzrQoLKT1E1BmikZc8EhCU+aOAqhs8tjGTfZS2/2TMyxdTei7h+mmRdjXmSR0dUVcwWReP0smZ4Ieky1sH3kUxfO/WeZzNnzyIrL59XurTzfaV4ArbGdzSQh81UqhIvXwcLKfai3XvK5gdLgPfDTINrUp+/4XRvDD1do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BZQrdYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BZQrdYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F19C4CECE;
	Thu, 12 Dec 2024 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019224;
	bh=zxLclcoFlJsZmB70hz4Yu8d/C3rmlpB4tET+sKtnfw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BZQrdYQdiVUmtcdQ+RQcHaKtuESr0sroZMLsXwYHB8qzGtTOxqv+VYUTkO8N/YBk
	 GjMTN4FGNk/mai9HE9q8uGkbO3COf8sFP1RqV9NGJmuBEqFqrbTbkzK/D9db62+sLm
	 COH2lH5B/86I8rBBWk5jbTw06o3s5rMp+SmQLXQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/772] libbpf: never interpret subprogs in .text as entry programs
Date: Thu, 12 Dec 2024 15:51:36 +0100
Message-ID: <20241212144356.173851285@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit db089c9158c1d535a36dfc010e5db37fccea2561 ]

Libbpf pre-1.0 had a legacy logic of allowing singular non-annotated
(i.e., not having explicit SEC() annotation) function to be treated as
sole entry BPF program (unless there were other explicit entry
programs).

This behavior was dropped during libbpf 1.0 transition period (unless
LIBBPF_STRICT_SEC_NAME flag was unset in libbpf_mode). When 1.0 was
released and all the legacy behavior was removed, the bug slipped
through leaving this legacy behavior around.

Fix this for good, as it actually causes very confusing behavior if BPF
object file only has subprograms, but no entry programs.

Fixes: bd054102a8c7 ("libbpf: enforce strict libbpf 1.0 behaviors")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20241010211731.4121837-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d8b5304eac8cd..a0fb50718daef 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3896,7 +3896,7 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 
 static bool prog_is_subprog(const struct bpf_object *obj, const struct bpf_program *prog)
 {
-	return prog->sec_idx == obj->efile.text_shndx && obj->nr_programs > 1;
+	return prog->sec_idx == obj->efile.text_shndx;
 }
 
 struct bpf_program *
-- 
2.43.0



