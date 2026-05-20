Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A10B351C24;
	Wed, 20 May 2026 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294726; cv=none; b=qmFMvS1pB8AbQtoqe81zLR4QdJ1AI1a88j0tQUxHyZfjU5Yaw5J4uxDERTwsmRIFWOzSIEMS78IkxS4W3VABaqpihq+dfnnFZkUdz2lcBSMPpZqbOs5cmi3GFShMe1+4h52G7zi2ASLMjcLLQ8WpJWdawLxD91t+Ufq4Zu+7AFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294726; c=relaxed/simple;
	bh=xgDm1leygjkgUsddN9KOp4SKLx/FdzP6NEkNCWnAy98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBC9ppRsakEGIEZ80vDlHRF7yxiFea07fJ18Dt3rU9Jh+LgeVEeWZ0C8RElEdiSBIQt5k9nWflr9qn2MZzS0x36DOaiVvmJMYOlN+ZPihuYhARSQrIKWntSORE7abUmQmBxo6PvTA7Vy/hMZs5yy/ZCvKH6yAmYKgdC/HnIuVlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3ubk7ip; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3ubk7ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56651F000E9;
	Wed, 20 May 2026 16:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294724;
	bh=GJJb36VB5jEfFk0FyyHWrOysMQy4+UTTu2MrTStYv44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3ubk7ipNNllnDTclHrcGLpZFIwiXvaaTOWvfXBNddxSZc9L+NjAh/82mifkQRw7z
	 K0czV9h9HobOMAPf2bTbWGsVxjSBHtNQLldxmCsK5CSfznWIgoXDwu8NyaTFuv1qlM
	 aYCjge6FdQZ6UjoLDRG6zXS1C4zkWdxjdiQbCsmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Esau <aaron1esau@gmail.com>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0148/1146] bpf: Use copy_map_value_locked() in alloc_htab_elem() for BPF_F_LOCK
Date: Wed, 20 May 2026 18:06:38 +0200
Message-ID: <20260520162151.657221109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 07738bc566c38e0a8c82084e962890d1d59715c8 ]

When a BPF_F_LOCK update races with a concurrent delete, the freed
element can be immediately recycled by alloc_htab_elem(). The fast path
in htab_map_update_elem() performs a lockless lookup and then calls
copy_map_value_locked() under the element's spin_lock. If
alloc_htab_elem() recycles the same memory, it overwrites the value
with plain copy_map_value(), without taking the spin_lock, causing
torn writes.

Use copy_map_value_locked() when BPF_F_LOCK is set so the new element's
value is written under the embedded spin_lock, serializing against any
stale lock holders.

Fixes: 96049f3afd50 ("bpf: introduce BPF_F_LOCK flag")
Reported-by: Aaron Esau <aaron1esau@gmail.com>
Closes: https://lore.kernel.org/all/CADucPGRvSRpkneb94dPP08YkOHgNgBnskTK6myUag_Mkjimihg@mail.gmail.com/
Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Link: https://lore.kernel.org/r/20260401-bpf_map_torn_writes-v1-1-782d071c55e7@meta.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index bc6bc8bb871d4..f7ac1ec7be8bf 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1138,6 +1138,10 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 	} else if (fd_htab_map_needs_adjust(htab)) {
 		size = round_up(size, 8);
 		memcpy(htab_elem_value(l_new, key_size), value, size);
+	} else if (map_flags & BPF_F_LOCK) {
+		copy_map_value_locked(&htab->map,
+				      htab_elem_value(l_new, key_size),
+				      value, false);
 	} else {
 		copy_map_value(&htab->map, htab_elem_value(l_new, key_size), value);
 	}
-- 
2.53.0



