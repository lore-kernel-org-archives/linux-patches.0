Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0491DDCE;
	Tue, 16 Jul 2024 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145301; cv=none; b=o4F5BfDkwkX/9SoijFmXxrVKKt9ewmiAKMZLj1kMJEzD01R+TsfH1CgxvltdandIcBIOl8SujagjcU6PaElsZrY9rYVdc/O8HPn1kN4sh3JoF8hmf4tTLl1OK2k2BEizQdgV/qpT1BMAA4fzzVMNBFo83bj3cxmO7RVrU6nTJ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145301; c=relaxed/simple;
	bh=B/EExZtQCbl7s2eGdBrSgzhN+PPJJEdzqdW3eiGHL4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvWX85b1hTAodBxavA8zqx4/qUS3eCCONHNYe61PiRRg1RMwJiNgfWR/hRap1arpT1vPCbrdWHfZxIx/JE3sm7C8u4Aq4BSIe0wMRakM0IQALuzA82UC3p7IOp2ySH73mNTWd3ZAQH+NOYjlpX+5UcN/8bZt8YQp/8MI8bLKOAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KyH/a+tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KyH/a+tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1BA3C116B1;
	Tue, 16 Jul 2024 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145301;
	bh=B/EExZtQCbl7s2eGdBrSgzhN+PPJJEdzqdW3eiGHL4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyH/a+tj/LgwhKEcaj7T9pJC841D9gIYdP1Eu5vMMtNbEtbAyWGlUAu+sPI0a7QD4
	 oS+1hRkUSR49JkMGM7FFR571z7FUAwNUhbySZXR9zQqOim++XdEwLOA46aOH8T5ycB
	 dnsMirdXErX0+dxLDG/B/QxSyrb6cKDwEsUqxln8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 20/96] bpf: Reduce smap->elem_size
Date: Tue, 16 Jul 2024 17:31:31 +0200
Message-ID: <20240716152747.293221643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 552d42a356ebf78df9d2f4b73e077d2459966fac ]

'struct bpf_local_storage_elem' has an unused 56 byte padding at the
end due to struct's cache-line alignment requirement. This padding
space is overlapped by storage value contents, so if we use sizeof()
to calculate the total size, we overinflate it by 56 bytes. Use
offsetof() instead to calculate more exact memory use.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221221013036.3427431-1-martin.lau@linux.dev
Stable-dep-of: af253aef183a ("bpf: fix order of args in call to bpf_map_kvcalloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_local_storage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index b1090a2b02b34..f8dd7c516e320 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -580,8 +580,8 @@ static struct bpf_local_storage_map *__bpf_local_storage_map_alloc(union bpf_att
 		raw_spin_lock_init(&smap->buckets[i].lock);
 	}
 
-	smap->elem_size =
-		sizeof(struct bpf_local_storage_elem) + attr->value_size;
+	smap->elem_size = offsetof(struct bpf_local_storage_elem,
+				   sdata.data[attr->value_size]);
 
 	return smap;
 }
-- 
2.43.0



