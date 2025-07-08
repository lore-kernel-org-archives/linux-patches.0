Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFE42E0B4B;
	Tue,  8 Jul 2025 16:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993923; cv=none; b=mIvt/E08JxiC/thoxvvnt4Swk2EAjqMtsh9oa1EEayImFnDMQMxxEZNPsS4Pd7kkqTDri3DAAoja8RraYv7uBF6WoZhT0eYo7Vdw9ra6cgHdPfq9P36dpkAGEqzQcptoG94tenvYH+x8IF88OjPB6Bd18dfxuyt0+jMKPWYt+D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993923; c=relaxed/simple;
	bh=UBYC3Reqam3qbJwvAaO4zu/Bzb4F21e/OHsKEQ7izS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGx+XS+66kWTzUpyxjWWmvG8Gnoyd33YChQlt+bt5Iut+Cv3s8HOwGrKkG6ymaxog+Obf/4DYy1zAljTgoQ9kFzrpCjJOM5ZjOqeLDJyIPefSZceBVpw+iKAXZiOiO45FzO65OqZvvxiNLj0noPbL4woVQrVf2QxAEmhzVWDG2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLVYsSep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLVYsSep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533F6C4CEED;
	Tue,  8 Jul 2025 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993923;
	bh=UBYC3Reqam3qbJwvAaO4zu/Bzb4F21e/OHsKEQ7izS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLVYsSepQACqc2Zc172nqqtsCLLNjx8mdcXgD2q9hq+TCTu5Gz07WgKKqOMY0Csys
	 SAbdtjMZpuUXuP6vYebvsTclX1QcIoxHc2Sy5b2fBxj7oQTpIrPzrk5Ea0UJ5YoVqW
	 13Z/25Fx/Kp0rEX2dGgCnkcKlrZ2s8bCMV65XkVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/160] libbpf: Fix null pointer dereference in btf_dump__free on allocation failure
Date: Tue,  8 Jul 2025 18:21:41 +0200
Message-ID: <20250708162233.330762961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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
index c2bf996fcba82..d62b2d2e8aacb 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -220,6 +220,9 @@ static void btf_dump_free_names(struct hashmap *map)
 	size_t bkt;
 	struct hashmap_entry *cur;
 
+	if (!map)
+		return;
+
 	hashmap__for_each_entry(map, cur, bkt)
 		free((void *)cur->key);
 
-- 
2.39.5



