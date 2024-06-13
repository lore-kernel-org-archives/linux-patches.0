Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC60384;
	Thu, 13 Jun 2024 12:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282548; cv=none; b=aiBTXCDQYmuQTEOLS+YNboHuoIkpfS658wmvxhALLbMCMdJihj+T+bclM/gtNMbMbDj+RSVvfEKJavcaNLL7Hzq/RpnPQEqrasmHbh7LxTpu72d/jcK7EKyH/iKDO9bfeRPJ8Gub2brFNM7KjjflHTePUsHeBpnTEyObfW/nLrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282548; c=relaxed/simple;
	bh=BoqyVun0o6Z06ylw6GWFWEh8pnVGXRswUT9ONoVzb2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z8j0Cx5paT5+AxsF08xQImcQS3MNpCU6xPmjZ2LZspeow5KblhASNU4i4iXH4n8lKYaJ5t70lAp7ejez5y9L9Huxp43vhrASVR366RSahOTr8lk2PBVXeRdt9E+g76k5Dq2IpM61xI3AO9TgDT5YJvJmVgRuHFacxh4a6oOcK+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOI35RTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOI35RTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CBFC2BBFC;
	Thu, 13 Jun 2024 12:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282548;
	bh=BoqyVun0o6Z06ylw6GWFWEh8pnVGXRswUT9ONoVzb2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOI35RTdIzeFIH8cACVPxnvrzytoQBgGsjzYC8Yh2cPw+dyXdk8oT5KwqS2Kk57o9
	 Vxowpa3vFBaBYCx3Y6wEvOv1TxGgQChF7UmnaYsEUYOn6Sz6nK8HBh69qqOXrtp2KQ
	 Qn6Hu15Yk3TM8IGOrNIJy+E16MKMOB6hE/SOzcK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+a225ee3df7e7f9372dbe@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 313/402] dma-buf/sw-sync: dont enable IRQ from sync_print_obj()
Date: Thu, 13 Jun 2024 13:34:30 +0200
Message-ID: <20240613113314.350980309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



