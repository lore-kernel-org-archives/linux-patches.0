Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCD31397;
	Tue, 21 Jul 2026 15:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648095; cv=none; b=mUCFnRXO854GUaBbVk+ReFmSyehr1JEqEbMujGMM3kMh4knRwjTjXwj1hblz/SJtWDoiUBJTOMvBeGHmvyCj3n9QMJrj8F+Akf75qPgTqnPibSluFDDuDOEozJvIpcmUNmZu8Ab2ytxgvDSfL8k3nEFWAOxw1XvhIpr2j1x1GnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648095; c=relaxed/simple;
	bh=sGTLWpEproYniZC18Y2o0mDoNgi9vLynQfxEs5iszHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAzYzUNcUAKVfmvx5aA8Rr8qiVAYGcM1Kt9Zis2yX/APoCx2bXQ6U7Sjq4mYQ9lapFedvk79vH28cKE2SoSJ1e1B3ggRAKlMQn4XaYq76nN0HnDATGlFD+ABYSdJVt36AN3PZlRthzeg8/jxVCLsiKqDspmC/CydF3u0L/+9VUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHyyTtS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHyyTtS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CFB1F00A3A;
	Tue, 21 Jul 2026 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648094;
	bh=hNXY9AjVncQ0k+MqjtXrg3zfFSXQHwifMxSKHE41ewE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHyyTtS1DdGpys1W9ZXZEkrzNUpAJVXG/Mtna/8Qzxq7UceU0+JhTcVfDBfNYfz5X
	 9uHeH4M5gu/7Id8Xpq5KOYXQPt4ghvdMpHRhDwPi41zwqBlMgAHHD+7MiJIi0cyaNX
	 3Imco7DtHjB+rD7OtFU/uLI08Y78xRJEyOqQaIUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0069/2077] libbpf: Fix deduplication of typedef with base definitions
Date: Tue, 21 Jul 2026 16:55:42 +0200
Message-ID: <20260721152554.318359703@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 0831b110eb4591e4ad8c5fd0d8f0f3f9979a5ff5 ]

When deduplicating definitions for a module, typedef defined in the base
are not removed. This is because the hash used for base types differs
from the one used in the deduplication logic in btf_dedup_struct_type.

This was introduced by the referenced commit when moving the typedef
deduplication logic handling from btf_dedup_ref_type to
btf_dedup_struct_type, as this also changed the hash logic
(btf_hash_common to btf_hash_typedef).

This also impacts other types referencing those typedef (e.g. const). In
my test, the BTF section size of the openvswitch module went from 31KB
to 45KB.

Fixes: 3781413465df ("libbpf: Fix BTF dedup to support recursive typedef definitions").
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Reviewed-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/20260417083319.32716-1-atenart@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index ceb57b46a8782a..771aeaa0262b29 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -4578,12 +4578,14 @@ static int btf_dedup_prep(struct btf_dedup *d)
 		case BTF_KIND_RESTRICT:
 		case BTF_KIND_PTR:
 		case BTF_KIND_FWD:
-		case BTF_KIND_TYPEDEF:
 		case BTF_KIND_FUNC:
 		case BTF_KIND_FLOAT:
 		case BTF_KIND_TYPE_TAG:
 			h = btf_hash_common(t);
 			break;
+		case BTF_KIND_TYPEDEF:
+			h = btf_hash_typedef(t);
+			break;
 		case BTF_KIND_INT:
 		case BTF_KIND_DECL_TAG:
 			h = btf_hash_int_decl_tag(t);
-- 
2.53.0



