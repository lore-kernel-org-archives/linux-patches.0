Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E113815E7;
	Sat, 12 Sep 2026 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241191; cv=none; b=NP2ScgibeLnqr3eWXoyrRqKcNF4gHAbnBkGgWxXzfnvTPtH5y+Pg6QJO/yyVQE0INNETBp8VzFFfJxlDcUkAAScCQqbLY50KwizLrGInKVgiAcl1qi0G3Hrsm/tL1YqCPqnNCYi6m/gDHAc9Ny4vU1yieYYt1w2jgiEMaJ4ZtWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241191; c=relaxed/simple;
	bh=cjpvvOKWQUtecvBk0tFbZCjETK8jlzQVOlZpQPowxgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ3TDFDsWmD1EX7Rdq1KJYAiCdlR137Qte1o6D9jR2FVICGLPYjS+QTTq6U5N33khuM1Mhs+cZC464HDdAigum0S8RBjzCW4WzE6kvzkAVXE2OYuXRhlCv9UyGAQWyO9VaLAoGcrjeZNtw6HNONROnIObVgqlm57MaM0W14+Boo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8xcQ+t5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8xcQ+t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72F51F000FF;
	Sat, 12 Sep 2026 19:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241190;
	bh=AsxCSt0b1gHKPfCUYQcsnpRlWvpegZndX4e2wrF7RlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8xcQ+t57hgQ7NLjY7duuLNeBkmfKJm1d2AdqO/kRxdc0/kYVby74XeYb5tw2HwoC
	 LT3MDA335IAXCc8hq6dg763K2rOHgRCA74q/hBvpwLVGy3OVQvOTer5SaMTvwpdyuu
	 yE5xL84reVWDEgpHkNWiiU6lx/+CaIuu1rsfIWr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Tyler Hicks <code@tyhicks.com>
Subject: [PATCH 5.10 058/798] ecryptfs: fix tag 11 packet exact-fit size check
Date: Sat, 12 Sep 2026 08:54:46 +0200
Message-ID: <20260912065518.292402903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

commit 8b2ec0f56f55477f547d332526c9ae2a8fabc0a5 upstream.

parse_tag_11_packet() rejects a packet when the already-consumed tag and
length bytes plus the packet body exceed the caller supplied maximum
packet size.  The check currently adds one extra byte, even though
*packet_size already includes the tag byte before the length is parsed.

Remove the extra byte so a tag 11 packet that exactly fits the available
buffer is accepted while oversized packets are still rejected.

Fixes: 237fead61998 ("[PATCH] ecryptfs: fs/Makefile and fs/Kconfig")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ecryptfs/keystore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1575,7 +1575,7 @@ parse_tag_11_packet(unsigned char *data,
 	}
 	(*packet_size) += length_size;
 	(*tag_11_contents_size) = (body_size - 14);
-	if (unlikely((*packet_size) + body_size + 1 > max_packet_size)) {
+	if (unlikely((*packet_size) + body_size > max_packet_size)) {
 		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out;


