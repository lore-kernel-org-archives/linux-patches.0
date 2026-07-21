Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C169E434E3B;
	Tue, 21 Jul 2026 20:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665194; cv=none; b=ZVCxRUyx5QZ8rqf8Kl4uZ7/eo7SibXG9HmYbv7flOkzulJvYQPiObNLzcaDmc/9sNdkUT02FHpw5+8g5SLMteLt73SisCqaj8BAtU4r0/ySTZCB1qDjywHY/8eYRSipkCEya/QvBC0B5f0cwkfZiFDCBSl6m2ZfR3VZsROe2wIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665194; c=relaxed/simple;
	bh=N9PFLM/LUlCJyb2YDSZE0/BUbUQp45Lu6FZiruKqSMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3JEAQHkmdUw7S0Z0Yp3DYvaJv/Pk+dsKslTR35gz3CXG204uasKRSYX/XFDJ4Yt2hxoIfKn6n+41yjWZqlZGeSKXMApg91XzJmOk+jCZE5pQMI7y3Mj9dZObxQXdoWz0gwOYsAAm4G7RQ7NrnNsF6n3Jdnk3t+vXrYTlFcCgyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8955pE/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8955pE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3245C1F000E9;
	Tue, 21 Jul 2026 20:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665193;
	bh=HY153/5hpMoHbDZrcI4ku8vI1vAIrxD4KMLajhAdiDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8955pE/D1CsHgFF/kNqLIwTbYUWMFtGm0I0G9brU421zpEzNYp8foXCsdItk2cAx
	 diZNbNjwrKjGYt4j/5V74EcCxqYc1+hBMfuThUYcC1j2lK/jNyUq09KmIdLiavktTs
	 Bi76JBGMwrdZ04vofLAbtG3lwzG/uo+WP6pXBh+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.6 0211/1266] tools/mm/slabinfo: Fix trace disable logic inversion
Date: Tue, 21 Jul 2026 17:10:48 +0200
Message-ID: <20260721152446.537887164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Wang <wangxuewen@kylinos.cn>

commit 235ab68d67eadbef1fdbfb771f21f5bacc77a2ae upstream.

The disable trace path in slab_debug() had a logic error where it would
set trace=1 instead of trace=0. This made trace functionality permanently
enabled once turned on for any slab cache.

Fixes: a87615b8f9e2 ("SLUB: slabinfo upgrade")
Cc: stable@vger.kernel.org
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
WARNING: From:/Signed-off-by: email address mismatch: 'From: wangxuewen <18810879172@163.com>' != 'Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>'
Link: https://patch.msgid.link/20260518062159.80664-2-wangxuewen@kylinos.cn
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/mm/slabinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -795,7 +795,7 @@ static void slab_debug(struct slabinfo *
 			fprintf(stderr, "%s can only enable trace for one slab at a time\n", s->name);
 	}
 	if (!tracing && s->trace)
-		set_obj(s, "trace", 1);
+		set_obj(s, "trace", 0);
 }
 
 static void totals(void)


