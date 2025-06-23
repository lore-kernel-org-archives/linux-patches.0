Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D5E253358;
	Mon, 23 Jun 2025 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685634; cv=none; b=M2gyPv/zkDAu4iAL68fPHLn2ZzvxPxN+7tQt1HBbm3xOAqPbRoyrU7soguUxOiBnnSfWLlI9ZvO9sk6+PvvKxD/1rKfYtlBnXmmR64WoTnDCMhk0izPqNNPZbw85fxBTT6eEyfpTVkug7NU8i4oHQWIDK8aZCLCiCB2F7Hintog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685634; c=relaxed/simple;
	bh=qFbjKwAsHwK3QOcxP/8KlM6fjNRuEkQJO7dI0zPL1JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QnBMm2Ok0aC2xFmTEzweuyMBX0BE1PTZFfLwcACvcVUx4LKD+eGL/+YG7HvRst0HddtsPj8TpEWamAbrleBmZMZ68bmIS9FukiIPjscSumH+wHjgJLBRNQb/y6F3LY45WHZZlRCfFEaKkbNqPxQT8BQIrIPelzDWsNbnLCuKkNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMnJbyI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMnJbyI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B94DC4CEEA;
	Mon, 23 Jun 2025 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685633;
	bh=qFbjKwAsHwK3QOcxP/8KlM6fjNRuEkQJO7dI0zPL1JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMnJbyI0YCXkxyABmWsIOl6/Hv5QTOGqmEdRyW5mAVxA98HYzlzwrcid9zfBSKDDp
	 Wny7a24oho89L2tb0fwIx13L9Qjna5cR2vid+PpQA63ZljJeq2jkQxdZuJj7SrJPub
	 SoNjSO7zc7h/vubb9mDjRRFdBFwXBJcBqkpZetGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 048/411] libbpf: Use proper errno value in linker
Date: Mon, 23 Jun 2025 15:03:12 +0200
Message-ID: <20250623130634.439844981@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 358b1c0f56ebb6996fcec7dcdcf6bae5dcbc8b6c ]

Return values of the linker_append_sec_data() and the
linker_append_elf_relos() functions are propagated all the
way up to users of libbpf API. In some error cases these
functions return -1 which will be seen as -EPERM from user's
point of view. Instead, return a more reasonable -EINVAL.

Fixes: faf6ed321cf6 ("libbpf: Add BPF static linker APIs")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250430120820.2262053-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index fc91814a35e8e..3e06af5b5352e 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1181,7 +1181,7 @@ static int linker_append_sec_data(struct bpf_linker *linker, struct src_obj *obj
 		} else {
 			if (!secs_match(dst_sec, src_sec)) {
 				pr_warn("ELF sections %s are incompatible\n", src_sec->sec_name);
-				return -1;
+				return -EINVAL;
 			}
 
 			/* "license" and "version" sections are deduped */
@@ -2027,7 +2027,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 			}
 		} else if (!secs_match(dst_sec, src_sec)) {
 			pr_warn("sections %s are not compatible\n", src_sec->sec_name);
-			return -1;
+			return -EINVAL;
 		}
 
 		/* add_dst_sec() above could have invalidated linker->secs */
-- 
2.39.5



