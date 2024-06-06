Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAF31C95F4;
	Thu,  6 Jun 2024 14:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683736; cv=none; b=GWkMnb0OF4D9RLvgT9jH3LS1D8vGh1YJ8L7p11UpLJB6wzZVYpC9OfAyixF4d3PUruodG6HF0eLxsOJNhxP0BQ94p3HXWQQUwJsqJYp2tT39kwHqzfAGIoB6XA8/63/mhGxImRLxojB3X+A4cxtOb9hhHHKTkJfbHnRvb6kUyGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683736; c=relaxed/simple;
	bh=kpxP5lbT5Y0jtJr1WEpCL2vmsQle7FbjVNGviuMqerM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GiUbFzcmwPQKMQrq5962bdmEFXthKy40x49ZzqQxdvKLNIhabTDZtT4PpIJ8i63oTzyMjfFNGrnOW7i9T2b/vwlwRxLiA7pmXSR1EgL6kOr2DC97g4hXQ7fT781D32Xs+AORS8N5nFuOBsvh3SGcKksrZvs50jsr1NlnU2SIHCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfIeat6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfIeat6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B517CC32782;
	Thu,  6 Jun 2024 14:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683735;
	bh=kpxP5lbT5Y0jtJr1WEpCL2vmsQle7FbjVNGviuMqerM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfIeat6ZJioPmfr+GwsPjySmw0gX0vCiwyZu0Va/1OEsSggLjdiJYvi+mcoo/IfUj
	 3RlPiFrMhJgJJOkhTOiugEPxSa+ArC8ITG/CrWmLE37zIrqK5YySTgHOYiEBL83XzP
	 GGSAouN9zDwlEdZXHF871Wl5Jc3wRPKtlsp63DD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+a225ee3df7e7f9372dbe@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 691/744] dma-buf/sw-sync: dont enable IRQ from sync_print_obj()
Date: Thu,  6 Jun 2024 16:06:03 +0200
Message-ID: <20240606131754.647302068@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit b794918961516f667b0c745aebdfebbb8a98df39 ]

Since commit a6aa8fca4d79 ("dma-buf/sw-sync: Reduce irqsave/irqrestore from
known context") by error replaced spin_unlock_irqrestore() with
spin_unlock_irq() for both sync_debugfs_show() and sync_print_obj() despite
sync_print_obj() is called from sync_debugfs_show(), lockdep complains
inconsistent lock state warning.

Use plain spin_{lock,unlock}() for sync_print_obj(), for
sync_debugfs_show() is already using spin_{lock,unlock}_irq().

Reported-by: syzbot <syzbot+a225ee3df7e7f9372dbe@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=a225ee3df7e7f9372dbe
Fixes: a6aa8fca4d79 ("dma-buf/sw-sync: Reduce irqsave/irqrestore from known context")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c2e46020-aaa6-4e06-bf73-f05823f913f0@I-love.SAKURA.ne.jp
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/sync_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/sync_debug.c b/drivers/dma-buf/sync_debug.c
index 101394f16930f..237bce21d1e72 100644
--- a/drivers/dma-buf/sync_debug.c
+++ b/drivers/dma-buf/sync_debug.c
@@ -110,12 +110,12 @@ static void sync_print_obj(struct seq_file *s, struct sync_timeline *obj)
 
 	seq_printf(s, "%s: %d\n", obj->name, obj->value);
 
-	spin_lock_irq(&obj->lock);
+	spin_lock(&obj->lock); /* Caller already disabled IRQ. */
 	list_for_each(pos, &obj->pt_list) {
 		struct sync_pt *pt = container_of(pos, struct sync_pt, link);
 		sync_print_fence(s, &pt->base, false);
 	}
-	spin_unlock_irq(&obj->lock);
+	spin_unlock(&obj->lock);
 }
 
 static void sync_print_sync_file(struct seq_file *s,
-- 
2.43.0



