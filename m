Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29F3376;
	Wed,  2 Oct 2024 13:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876030; cv=none; b=bHn8WBiz5g5WYEySOJBWRX/ZmEI8dRrcMC30XuYxYMJEcel+X2XdhyY4TlcW8Weg1Y1tVCHO3bTrpWsQugWbWWnAVnuqibGa1Nl6t1oat5u690I3BrFFUmdnZtGb+WX4p76zQVd3nmwV4AKhFCQcd3PLVnGYtAqtVPi1xIkghWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876030; c=relaxed/simple;
	bh=+9tckckYmBl+P7eNLqe61V3y8CrpF0mhLmTEmmWnOj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bt1qbD3rKY4DIWELa+z0cFtNdQSjkefyMCPz3pW6nAju68XNjvVbt1ep2lqDpIUxRu4tnptV4qhNqBuqeqV5rVM5L+IhlomwBxq1+JY+ULDFkwu/menD48V2GrD6PSJWiwQkCqycycZYajl5VWeavWIT7XyjhwwUyjfe0gF3dWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MItm5zGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MItm5zGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC98C4CECD;
	Wed,  2 Oct 2024 13:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876030;
	bh=+9tckckYmBl+P7eNLqe61V3y8CrpF0mhLmTEmmWnOj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MItm5zGaPp7yd6+lyZVwbuaX7VHCQ93JTIO8hRj2JmnXowzTKIWWSr6QEeZfFeULk
	 EU/g/nLCrZtCOHTccEav6QjUfqDPt89XEZ4h3HhGKlIl4hb2Ij1Cz7RruE6m+Aj42y
	 QonIKaOGqQGrPYkYr9xyDLzQN9LpK3PaFx5GKp2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <qmo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 305/695] bpftool: Fix handling enum64 in btf dump sorting
Date: Wed,  2 Oct 2024 14:55:03 +0200
Message-ID: <20241002125834.614803464@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit b0222d1d9e6f8551a056b89b0bff38f515f3c9b5 ]

Wrong function is used to access the first enum64 element. Substituting btf_enum(t)
with btf_enum64(t) for BTF_KIND_ENUM64.

Fixes: 94133cf24bb3 ("bpftool: Introduce btf c dump sorting")
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Quentin Monnet <qmo@kernel.org>
Link: https://lore.kernel.org/bpf/20240902171721.105253-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/btf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 6789c7a4d5ca1..3b57ba095ab61 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -561,9 +561,10 @@ static const char *btf_type_sort_name(const struct btf *btf, __u32 index, bool f
 	case BTF_KIND_ENUM64: {
 		int name_off = t->name_off;
 
-		/* Use name of the first element for anonymous enums if allowed */
-		if (!from_ref && !t->name_off && btf_vlen(t))
-			name_off = btf_enum(t)->name_off;
+		if (!from_ref && !name_off && btf_vlen(t))
+			name_off = btf_kind(t) == BTF_KIND_ENUM64 ?
+				btf_enum64(t)->name_off :
+				btf_enum(t)->name_off;
 
 		return btf__name_by_offset(btf, name_off);
 	}
-- 
2.43.0



