Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12664414;
	Thu,  3 Jul 2025 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554983; cv=none; b=jkffmeZvjOiA8Yy3PR79ov8UEDx1LL3nxRU0u7aMgAlFA4Rkr3PzukfMpqrMy7OPIWxm5GBFDRoqQBhNhabR5HRYJADAnOZa5hsPHZngTOr+XBDqdLQZv4HgOD+gYNW4FiJXG6mFvF6Rj2UjExFowWaL/WNEtApkaCo5u+OgcxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554983; c=relaxed/simple;
	bh=mnWUtI51LSJBbGo0pDyym5AfaFxbwvF39c4JelBs01M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzJgNeBKyWGxzGTkOolMKpuhUdvBu2Zl9pInTDD9GSFKeCV8sNWAUWTJKfkrGjXJ1rNF7kV5k2iuVdu9dKmHJ4Y9jAkHkeyZ4oMDxpdSUczwuq35VLmsrUBxQ1TRCObSPsCLF4eNIL0bLIjJOeupR9j6SAeUfKcfqQhRZDhlYUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qj7BHjXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qj7BHjXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300B9C4CEE3;
	Thu,  3 Jul 2025 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554982;
	bh=mnWUtI51LSJBbGo0pDyym5AfaFxbwvF39c4JelBs01M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qj7BHjXn2XnkYbyNtm2N3a5i7uBU7Pjp+rIetBKQNfX2rBeS0s7nqwwPkai5b1qcU
	 pexqGuBxpWF7TWVERVNMigSJpyLlDYrV1pM9rPzUT0ghCLT2+sjyBCLaZ2ZehfU/+3
	 2V5Uf4hZpX+3CTgKlGqdjb33g16ATpx0n6Z0UXYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 140/263] libbpf: Fix null pointer dereference in btf_dump__free on allocation failure
Date: Thu,  3 Jul 2025 16:41:00 +0200
Message-ID: <20250703144009.972688773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 460c3e57fadb6..0381f209920a6 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -226,6 +226,9 @@ static void btf_dump_free_names(struct hashmap *map)
 	size_t bkt;
 	struct hashmap_entry *cur;
 
+	if (!map)
+		return;
+
 	hashmap__for_each_entry(map, cur, bkt)
 		free((void *)cur->pkey);
 
-- 
2.39.5



