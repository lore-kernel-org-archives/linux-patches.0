Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A937F8B2;
	Sat, 12 Sep 2026 09:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204494; cv=none; b=Bzb4AjsQJMmq4jiRz2tZFxseI8PugbQjx9nos9XEijybeTR+t+CnwVdIwMQE94LpVCaXu3qLDxJMOvV2bXzjsKlFkT21OYBt/kkZtjxy+ssGWBZGwsDUqA3uoiftICbL1+2BNiWj8JN81zoE4F0aozkDdnKvhSsImBA2EnLlm4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204494; c=relaxed/simple;
	bh=DdVs/7vYon0PWpMI08cEbj+Gqo1yrwPB+tIr+PsIeSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NETYcL43fIYth2Ju1AqU2b82aU/f9hU1rIIwgpbVcC7FfIY5gO0BIN1ziubmO9nlC4UoyAPX8pEbZbehVU44kdxsvke4/uOiLRfTmgr+6jvq9aKJIKwyZn0rHgK5q0PfaJ6fowIuAVZoNmfheHcFGXyX+vZwFluLJd3QxsDjHhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lqv7+HZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lqv7+HZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F154F1F000FF;
	Sat, 12 Sep 2026 09:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204493;
	bh=0JRH2v4hnMfdAkxk4W7oSgmJ70Yi6GmeSn22hYTtQ88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lqv7+HZAeBKxcI8en1gu2aC4Mx0rNPPry57EShdXzHukcbTx0kAizyHw3cqCwCURE
	 1dQG7p6MNtsa7FJdCC4NnWFUwfF+V3CC/p4FHU/7btwbCifoIuWQlbUjDcV465xoQl
	 RVwZAcyQxxFdjqN6DXj4Zpsabe24jzAKwIMm1pno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufeng Wang <wangyufeng@kylinos.cn>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1624/1815] vhost/net: fix clear_user start address in VHOST_GET_FEATURES_ARRAY
Date: Sat, 12 Sep 2026 08:56:14 +0200
Message-ID: <20260912065727.114349216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yufeng Wang <wangyufeng@kylinos.cn>

[ Upstream commit 92a7b138f2453bf067628de0c5ec563cc8ad16d5 ]

The clear_user() call in VHOST_GET_FEATURES_ARRAY incorrectly starts
at argp, which is the beginning of the features array, overwriting the
data just written by copy_to_user(). It should start after the copied
elements at argp + copied * sizeof(u64) to only zero the trailing
unused space.

Use size_mul() for both the offset and length calculations so the
arithmetic stays consistent with the surrounding code and remains
overflow-safe.

Fixes: 333c515d1896 ("vhost-net: allow configuring extended features")
Signed-off-by: Yufeng Wang <wangyufeng@kylinos.cn>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260626070438.59149-1-r4o5m6e8o@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6949b704166d5..38d9c184082d0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1777,7 +1777,8 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 
 		/* Zero the trailing space provided by user-space, if any */
-		if (clear_user(argp, size_mul(count - copied, sizeof(u64))))
+		if (clear_user(argp + size_mul(copied, sizeof(u64)),
+			       size_mul(count - copied, sizeof(u64))))
 			return -EFAULT;
 		return 0;
 	case VHOST_SET_FEATURES_ARRAY:
-- 
2.53.0



