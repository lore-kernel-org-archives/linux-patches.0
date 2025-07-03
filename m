Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376822E7F1A;
	Thu,  3 Jul 2025 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554239; cv=none; b=l2cC9UPxAra0l5QRleJ3I3dx0pE+ZYnV6cRM2DNY4xEOSGb9g5Iy7gs2dyFZZAtWDL2k52IEw1xCHLwdD0sbgTuKa1LckExUF9CWsvvAA5SMFusVDLRXkR4RxszbAKCWs6VbwxLpY3ZuGeTxlY4ZEQZp7ttW8fLLsmvYIT4qx3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554239; c=relaxed/simple;
	bh=EVljRyWrTiaVZQRNt7nT2eMllNxc75Gfdp/3pxgIwW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PexAy3/jtPLzVYI0dtX3g88cyNYVV2McQFim4KEHYJ2jzPqqIeZB8kR28dklDoLaV7qYwjJT591exc9g4pvVp2wIhnMP9PmZi/sbrzEVCoMA4QQKabYLLny0zXPYVpYGBNeHkrC5MdyndIh46WYPWEONKAet6PMP+bDymUlVWew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtiP/9HO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtiP/9HO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41D7C4CEE3;
	Thu,  3 Jul 2025 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554239;
	bh=EVljRyWrTiaVZQRNt7nT2eMllNxc75Gfdp/3pxgIwW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtiP/9HO8mNq9A83QYqegIH9jvJBh62KmmnsVFQIhUttIs3pi0vlYWgBDHjjs19gQ
	 YIH1/7Va0f8+X3s6WaTpi+44dYzIF0FHVCDpMflayFIxL1J59yadI2T+PlT2J8tTql
	 7Nc5J7i28g3tJchUpza7RRaF/pN/fr7oPqbCtdQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Chen <chenyuan@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/218] libbpf: Fix null pointer dereference in btf_dump__free on allocation failure
Date: Thu,  3 Jul 2025 16:40:43 +0200
Message-ID: <20250703143959.736430006@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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
index 46cce18c83086..12306b5de3efb 100644
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



