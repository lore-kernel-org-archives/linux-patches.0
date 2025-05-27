Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B8627FD49;
	Tue, 27 May 2025 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366729; cv=none; b=SE9Jfhde9Tc3ri7xyMTn69OilAFOdWEAGLasnnGH/mFBL6KJTB+dl9dNcU/zEvkvdzBMU2c3Cyglbe9XSGpYZ1JqHdDhPJOdoVgxYTaJmbVICtTAkVGsqm9b8FbOMpqccwNJv+0phUpFwlEldVDZjtBSb77OWJLetBImwz4DSwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366729; c=relaxed/simple;
	bh=0vrXONIaYjrE8duNa/jDTLhRT6KAL1TbmxXwpi58CZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcFRC1uy6mER+VSVkK9zWuJj2JNf82J6pLzOIr1m7NmSTZ/F7Yt755l7zeWY/ylm8l6J+s4BkmGprY2VSTO5SOYEGQ12BWXfR3dGZ40qn1rWpv8XSw4yJ1LkLdW0r6rC//F3FKUsjqdchPSY32iUoR+KP9yPRNP5Dnx8j4Xo160=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQAQza1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQAQza1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAE6C4CEE9;
	Tue, 27 May 2025 17:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366729;
	bh=0vrXONIaYjrE8duNa/jDTLhRT6KAL1TbmxXwpi58CZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQAQza1KfftnSwUNZJSxrWSZDVXMiT/2ZjCoUk+0mxcpbFbM6V15lkh6vQRwOuCoW
	 g5awHI7ptOUYlDjfqYkqFMlGult0yuEAFmmTMgd7ViIPpHtur2pwx3h1av+jlMrj8z
	 oeK3YvvmXi0eyCNelqwTJcctdXHBucEjBN1VC7qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 163/783] bpf: Return prog btf_id without capable check
Date: Tue, 27 May 2025 18:19:20 +0200
Message-ID: <20250527162519.806984840@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 07651ccda9ff10a8ca427670cdd06ce2c8e4269c ]

Return prog's btf_id from bpf_prog_get_info_by_fd regardless of capable
check. This patch enables scenario, when freplace program, running
from user namespace, requires to query target prog's btf.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20250317174039.161275-3-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 1c2caae0d8946..87f886ed33bc3 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4733,6 +4733,8 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	info.recursion_misses = stats.misses;
 
 	info.verified_insns = prog->aux->verified_insns;
+	if (prog->aux->btf)
+		info.btf_id = btf_obj_id(prog->aux->btf);
 
 	if (!bpf_capable()) {
 		info.jited_prog_len = 0;
@@ -4879,8 +4881,6 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 		}
 	}
 
-	if (prog->aux->btf)
-		info.btf_id = btf_obj_id(prog->aux->btf);
 	info.attach_btf_id = prog->aux->attach_btf_id;
 	if (attach_btf)
 		info.attach_btf_obj_id = btf_obj_id(attach_btf);
-- 
2.39.5



