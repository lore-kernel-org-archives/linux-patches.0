Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C73C19E7F9;
	Tue, 27 May 2025 16:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364700; cv=none; b=nv6Z0uZ/6edt6qz9fp25HoaVZctNNoGBGNDeL+MRFHULHvj9XnOpbDqv7E5ayp2YrmJnY100OXbw1sX3utTit/EGnWKiQFgP0/xrnSmlW8bZ0hzx1NYULvj/8oLin8cI7rp2zchk7xRVuNuvUUHWg1oyXQ4w1Yu0x/Q6cXE4/as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364700; c=relaxed/simple;
	bh=Xt2w5lttwsqP4l7r0XgELTwn1MJGZFaiJIJQErXh0Mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAZZHgt8FOrTU+uWzZ1cl2JRM3U+W6WwsAezdpHf2kK0o6+mzqGqPWxFpWgEJzOKYUWk5dFz5aWL35J/OEByVjH88PdK327tGD3L1TsIRKKFtwQydVVqLGUmQCbt5BIHzTa0DnYocktarNmVAsqgACrGVOfWNeHwGM3LZRJ8zhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WuX/GoLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WuX/GoLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E67EC4CEE9;
	Tue, 27 May 2025 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364699;
	bh=Xt2w5lttwsqP4l7r0XgELTwn1MJGZFaiJIJQErXh0Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WuX/GoLHqHJb+i9YA/8Nbj6+Y3GtRlxiGxA139zhCHiMZO7v2efkdsZp/7Lh+oK79
	 n75iuiwyv9rYBfWLI0dh4kj8yxiqp+JQYmHoc9ypr4vOaPJNUYnC8qqkRScwa5CXdb
	 ok7m9FFtymsXd3xAaYmQvbyR2USbrpZnsOaeMpgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/626] bpf: Return prog btf_id without capable check
Date: Tue, 27 May 2025 18:20:31 +0200
Message-ID: <20250527162450.641777909@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 977c084577565..fc048d3c0e69f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4606,6 +4606,8 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	info.recursion_misses = stats.misses;
 
 	info.verified_insns = prog->aux->verified_insns;
+	if (prog->aux->btf)
+		info.btf_id = btf_obj_id(prog->aux->btf);
 
 	if (!bpf_capable()) {
 		info.jited_prog_len = 0;
@@ -4752,8 +4754,6 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 		}
 	}
 
-	if (prog->aux->btf)
-		info.btf_id = btf_obj_id(prog->aux->btf);
 	info.attach_btf_id = prog->aux->attach_btf_id;
 	if (attach_btf)
 		info.attach_btf_obj_id = btf_obj_id(attach_btf);
-- 
2.39.5



