Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86799471261;
	Tue, 21 Jul 2026 18:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658350; cv=none; b=qGIy1+QVNn4hFxFfIKrB/jZEUPwUSKyVgsHicE3RObX8AzeJvFYvIx1cZkkOpCgj/CuLA43pSZ73g65oI+ZBe4BSo4wCEoXcwpH9sOWIPYZuD1Yi0YhNK8g7vJomZz8wu9QSyCvm0ICf2OKa7GgGfO4nN7WthHhhm8GYkvWSUk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658350; c=relaxed/simple;
	bh=n/HBmSyYgkBvqVjjfvOCW8up4XXdZ0ITOLXZT8GpsZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t78f+lzqzz7c/erMoxzwQMC6b4eNUViyNmkhpXc1I0FHE83GrZvADOx/2GBnw4Ty9eg2h34i1TyuBBhfA+CYHIz0GbYpmbUptULQp5nC0/ovN9hFy8tfYEzRRDEGlW8wbyeHCy7B9ib5Hsbdk6+na54euvQ2WlsoBia41c15CB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/to3aPy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/to3aPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D631F000E9;
	Tue, 21 Jul 2026 18:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658349;
	bh=5vW5wb8nRrKgPHNSQ5e8HKiQBRSJtjHTgI8Rd8+s7zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a/to3aPyLIBSNSk3DWzlritpkCwEOKC5UECfvJLnY35bzfvLW5Fxd+RUuAaf+QX/S
	 sDOPQI0wO62Qegy7OgopY/UYahVoXI8aU/92wuw7OpwwXZ+ck/FxBe0kVn2BeZsxOq
	 kE9jkDEo6Y6bYF5AwDpBAGJdyDmX3VrEtRHyARCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yong Wang <edragain@163.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1108/1611] net: ife: require ETH_HLEN to be pullable in ife_decode()
Date: Tue, 21 Jul 2026 17:20:24 +0200
Message-ID: <20260721152540.334895153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wang <edragain@163.com>

commit 9406f6012b7343661efb516a11c62d4db2b62f75 upstream.

ife decode may return after making only the outer IFE header and
metadata pullable. The caller then passes the decapsulated packet to
eth_type_trans(), which expects the inner Ethernet header to be
accessible from the linear data area.

With a malformed IFE frame, the inner Ethernet header may still be
shorter than ETH_HLEN in the linear area, which can lead to a crash in
the original code.

Fix this by extending the pull check in ife_decode() so that the inner
Ethernet header is also guaranteed to be pullable before returning.

Fixes: ef6980b6becb ("introduce IFE action")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yong Wang <edragain@163.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Link: https://patch.msgid.link/20260610183814.1648888-2-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ife/ife.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ife/ife.c
+++ b/net/ife/ife.c
@@ -79,7 +79,7 @@ void *ife_decode(struct sk_buff *skb, u1
 	if (unlikely(ifehdrln < 2))
 		return NULL;
 
-	if (unlikely(!pskb_may_pull(skb, total_pull)))
+	if (unlikely(!pskb_may_pull(skb, total_pull + ETH_HLEN)))
 		return NULL;
 
 	ifehdr = (struct ifeheadr *)(skb->data + skb->dev->hard_header_len);


