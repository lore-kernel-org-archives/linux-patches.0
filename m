Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFF746EC9A;
	Tue, 21 Jul 2026 19:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662692; cv=none; b=tol8STfSy2bnPoQGoNKDXnilS2X2Xj504vGDrd8IO0Td9KmUB3tj+z9jtEnIFoEq36v4Bh3z1h8/TTZG5AZGVPQm6ASz1FQpZcdZH2pExEyoYKQpdsCLdvVY/Ij07vqGtxPHUfJ+y+W/yYCQG8IaKiwZxeOWwzBtNUWfs1n/zoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662692; c=relaxed/simple;
	bh=1tFysurjY0E2CDHCHLpUo/dqPYNOisAubBxhRUOrF4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEiAE7BeomuhXcBDfY1OXRg+4zs298GcDRfmxeY9SjYQS5EczgK4OPjLjONLzfh/mqQljAC5fOTAmJVp2TQsTcpRWDySv6cJGzQA0eewfgNndWXQmEDXYz0Nc4L35JDwTuC9U+mBePJGBCcjfab0U2fESjRvfJXN6xHP1ixJkGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SVhZxDQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SVhZxDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFCB1F00A3D;
	Tue, 21 Jul 2026 19:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662687;
	bh=xHilwL7gFsiqKW/+DYfxKNEAnvV9o0+cLhpp+GQE1Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SVhZxDQ/IH5pPU05pkB7ZSeKhB0iCMaBlnKlBk03MRKzEA+hNYG1Bpc5Ws6y1jYj
	 AsbFIFKXuY/13KEbNwHLsyBevKd4uYCqTVOiXuX7jLs7eJ1TbIGCTijB+pj99iUY/P
	 4zu1PsX3n0XzcH0qg7jQDW8FeVV7xFuEwrN8PV/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zygmunt Krynicki <me@zygoon.pl>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0538/1276] apparmor: aa_label_alloc use aa_label_free on alloc failure
Date: Tue, 21 Jul 2026 17:16:21 +0200
Message-ID: <20260721152458.161047838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zygmunt Krynicki <me@zygoon.pl>

[ Upstream commit 654fe7505dc6889724d4094fa64f89991afabfc3 ]

aa_label_alloc() allocates a secid before allocating or taking the label
proxy. If the later proxy step fails, the error path only freed the label
memory, leaking any resources initialized by aa_label_init().

Use aa_label_free() on the failure path so partially initialized labels
release their secid and other label resources before the backing memory is
freed.

Fixes: f1bd904175e81 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Zygmunt Krynicki <me@zygoon.pl>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index 3bcc45437b4472..04fe4d16952d1e 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -454,7 +454,7 @@ struct aa_label *aa_label_alloc(int size, struct aa_proxy *proxy, gfp_t gfp)
 	return new;
 
 fail:
-	kfree(new);
+	aa_label_free(new);
 
 	return NULL;
 }
-- 
2.53.0



