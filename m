Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C202DE6F1;
	Thu,  3 Jul 2025 15:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556116; cv=none; b=L+SEq/bnXzKJciOmVzPJuiIQJkky2fTJfIMInnX0xzIWXyJhcmDs7CLXIGaF5AtZr0pXs4jc4QbHjLLtBytch/15XSGMPW0QV9rt91dOB58J137u1OCDnSZjL4yTWa6Uovfg5HxbDIUpjadtmnlEdOPQEY492++0ulxLNoFU/5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556116; c=relaxed/simple;
	bh=rlwGl8MYN6JYZXnnPFuRfGTYY3Md4mPs2uH8e0iCgnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oo2cUvEpxZcg3vr/Miqc/NRd2vcpVhBS6l3gVWJQZiPE7WHPNRqvhxQS6jJJ8Ihm+5Frxk5XBt075X84fLCL+IkaAfG41KEp6gPICCb9JsTaWnpiUmsSG3Y5Idz5NtzjJKcZn7ksWoQ0WSeijqa2anm4Dif0RHE0xiGshBLlngo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwxGkaku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwxGkaku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C52C4CEE3;
	Thu,  3 Jul 2025 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556116;
	bh=rlwGl8MYN6JYZXnnPFuRfGTYY3Md4mPs2uH8e0iCgnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwxGkakuceUBSJNghc41No0EZEBtTPP99gcprNCSntLv8+73KibBcau6ZuUfbmXvJ
	 lJQzaE4bo4jdq01Ngo1qaMjgopiQY6DxTSEr6M2tEFaTE5ptO5WbzqBfgcVGEM8GHx
	 5LODhytKPGK/NTX1ti0fcjelO1Y8wBRp1A1pFadM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/132] libbpf: Fix null pointer dereference in btf_dump__free on allocation failure
Date: Thu,  3 Jul 2025 16:42:48 +0200
Message-ID: <20250703143942.512388297@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Chen <chenyuan@kylinos.cn>

[ Upstream commit aa485e8789d56a4573f7c8d000a182b749eaa64d ]

When btf_dump__new() fails to allocate memory for the internal hashmap
(btf_dump->type_names), it returns an error code. However, the cleanup
function btf_dump__free() does not check if btf_dump->type_names is NULL
before attempting to free it. This leads to a null pointer dereference
when btf_dump__free() is called on a btf_dump object.

Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
Signed-off-by: Yuan Chen <chenyuan@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250618011933.11423-1-chenyuan_fl@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index cfdee656789b2..72334cc14d737 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -224,6 +224,9 @@ static void btf_dump_free_names(struct hashmap *map)
 	size_t bkt;
 	struct hashmap_entry *cur;
 
+	if (!map)
+		return;
+
 	hashmap__for_each_entry(map, cur, bkt)
 		free((void *)cur->key);
 
-- 
2.39.5



