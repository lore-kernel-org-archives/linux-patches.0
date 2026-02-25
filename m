Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38B31E2834;
	Wed, 25 Feb 2026 01:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983662; cv=none; b=IWECxyuN3qbDS8xUJrmibHgtnfATaQ4w8ItCvJ9Br3/P03unLYjAsYaJe6U+TxxzA6LPlSGD0CosoyUSX27W1ow4juyfOba61NU89R92vBNABPLbtUqDatY+TFpBVzQPMSwuCvt2rUl9hY7AKopv5e1DSvaSOSarb98HS0ie1pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983662; c=relaxed/simple;
	bh=cpvQcPKQ7H54qct2ORcKp3tJNOn92m0Be6kw0tpIz34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgzJe4xt80XVKkBDmXeC7B8xQqxY4BMulLhdEb4M6OzCKJtIWblwVyUu4bpST2pvpp7PUoGBXg0U5MtyeoNGm2Oy/TcoQbJzVSGWkL6T1tmvS45Zt4m7ZyD4oTevg3BvP4HOLSxcxkx2kMJZofCxREH7mNPJQnOZ4+vBA9HoThI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQ+4c9HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQ+4c9HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B727C116D0;
	Wed, 25 Feb 2026 01:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983661;
	bh=cpvQcPKQ7H54qct2ORcKp3tJNOn92m0Be6kw0tpIz34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQ+4c9HRRt0ttOrzpLtS2b6QaPaePep8GlVhFyVZzcW/0KjfSOH3mMCJ8yPbK72zi
	 TNKBdd0OqzXzyoSe4UB/WbBkg8pnNoG5V5F2WcUfaBJvXqtaIH7m5Hlqtje0/Hd+rh
	 iUaz2286r7XcZ4VBA+yRJ1Chmb5ppYAmh8H/EZqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengmian Hu <huzhengmian@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 703/781] apparmor: avoid per-cpu hold underflow in aa_get_buffer
Date: Tue, 24 Feb 2026 17:23:32 -0800
Message-ID: <20260225012416.996711977@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengmian Hu <huzhengmian@gmail.com>

[ Upstream commit 640cf2f09575c9dc344b3f7be2498d31e3923ead ]

When aa_get_buffer() pulls from the per-cpu list it unconditionally
decrements cache->hold. If hold reaches 0 while count is still non-zero,
the unsigned decrement wraps to UINT_MAX. This keeps hold non-zero for a
very long time, so aa_put_buffer() never returns buffers to the global
list, which can starve other CPUs and force repeated kmalloc(aa_g_path_max)
allocations.

Guard the decrement so hold never underflows.
Fixes: ea9bae12d028 ("apparmor: cache buffers on percpu list if there is lock contention")

Signed-off-by: Zhengmian Hu <huzhengmian@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lsm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 8d5d9a966b719..9175fd677ef3d 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -2137,7 +2137,8 @@ char *aa_get_buffer(bool in_atomic)
 	if (!list_empty(&cache->head)) {
 		aa_buf = list_first_entry(&cache->head, union aa_buffer, list);
 		list_del(&aa_buf->list);
-		cache->hold--;
+		if (cache->hold)
+			cache->hold--;
 		cache->count--;
 		put_cpu_ptr(&aa_local_buffers);
 		return &aa_buf->buffer[0];
-- 
2.51.0



