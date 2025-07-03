Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B5117332C;
	Thu,  3 Jul 2025 15:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555654; cv=none; b=hF9WZaygs1683+iuZ+7y4w7PsQrLNUr5mE6culQH/CpP5vhZDLPoLYW1/NQoIKWxyq/oZ/PNx5jXIcgPTCYYrZykIPDbGas+5i08kYJBWjTnBclcdlQMNVxtWCNnpXqnCtMpm9gWM3Z5eMsjYwhOefzZ1tO/e+2FXL85PAneMDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555654; c=relaxed/simple;
	bh=MUxlDOAmzHbat28gNfvtU5Xm3JwPuKQJqh+I9lXMsxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuXWc2cpm6IfPlCsCInoiCFcuYXVIdIXPQiv0uWe/ZEK879tKgz/PRRVN1j2JeP/wVHmGrJiK3AgjwQKiSYRIHqDKcIPeesITspXewFQevOVnVX4VIgclg4IsP1OV1aJ8iJ1ZA7sjGNvoJmJSdWIu3o6/OIWCdr60X9NDY6qa10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJt4+M4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJt4+M4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E224C4CEE3;
	Thu,  3 Jul 2025 15:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555654;
	bh=MUxlDOAmzHbat28gNfvtU5Xm3JwPuKQJqh+I9lXMsxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJt4+M4qNb9NWW4boov3MoS10RV0+x9ywBsHLgG56A8tSQJH7y5hHY1efSF1Bk484
	 2GDQ8GnOQlPCqWf+mVm9isOYgK+diz8bSjs/ZJN8J9qo7QO7bPFaX28djmcwgs6HCa
	 ZKIvxMM5MD++zMMCZDtSHekAa2rCd65ZkV6fOMwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/139] libbpf: Fix null pointer dereference in btf_dump__free on allocation failure
Date: Thu,  3 Jul 2025 16:42:24 +0200
Message-ID: <20250703143944.329215152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ebf56d21d08ee..cf4db51b99eb5 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -225,6 +225,9 @@ static void btf_dump_free_names(struct hashmap *map)
 	size_t bkt;
 	struct hashmap_entry *cur;
 
+	if (!map)
+		return;
+
 	hashmap__for_each_entry(map, cur, bkt)
 		free((void *)cur->pkey);
 
-- 
2.39.5



