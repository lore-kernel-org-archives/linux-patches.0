Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CA31FC0FC;
	Wed,  5 Feb 2025 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766800; cv=none; b=FcIW4yU/raLPqyLZ3hinWFGQo3LDIC9VLC47NUyLekZ/jYwcjpz9F2B7Bc6ueotE1CJGY8xBG6Jyn92oxObL4CsQhBjWuI2nbTHPREoEPFINpw2stDnfVZBBkrHcTUaoqQrQAobfwQk0PV2A76SootGGMH4DyBp1PVIy6N5QmvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766800; c=relaxed/simple;
	bh=AKDRLVwBXAlNfulqasyB9sH5vnmy1wmOo33ZkFHxIZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLHpteNu3PC0rH2JvrL4xE6kCNgZH7VH4DM41Xhaywu8nOX64K2kL43rQ/ZYvjrhwJQLP2rmX5kitdFHvp1pDi4pTpqPpyrvsS3GA7kzcuO4QzsrbjA83qM/6kiOWo4q/7ijvXwaaQmQ/+W7PH1uNv7jrD3LgLSKQPIvxGVXH5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCKU8yBn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCKU8yBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762F9C4CED1;
	Wed,  5 Feb 2025 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766799;
	bh=AKDRLVwBXAlNfulqasyB9sH5vnmy1wmOo33ZkFHxIZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCKU8yBnWdOwZFxRmPiiYAj7hkqvY61OqDkh9BPLtOsYwlremAiWaGXeJsj2liP8I
	 rGHrFXVfjhdVz9GOyXu6jcVI7RZPEpG5NhzhqaeosNhJYi0m3Ftt1CA0Me1hN8qvY8
	 AQLCGQFdedlxOGTLFlAGMurJ44I88YehGo1xhJHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 310/623] libbpf: Fix return zero when elf_begin failed
Date: Wed,  5 Feb 2025 14:40:52 +0100
Message-ID: <20250205134508.085870582@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 5436a54332c19df0acbef2b87cbf9f7cba56f2dd ]

The error number of elf_begin is omitted when encapsulating the
btf_find_elf_sections function.

Fixes: c86f180ffc99 ("libbpf: Make btf_parse_elf process .BTF.base transparently")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250115100241.4171581-2-pulehui@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 12468ae0d573d..7e810fa468eaa 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1186,6 +1186,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
 
 	elf = elf_begin(fd, ELF_C_READ, NULL);
 	if (!elf) {
+		err = -LIBBPF_ERRNO__FORMAT;
 		pr_warn("failed to open %s as ELF file\n", path);
 		goto done;
 	}
-- 
2.39.5



