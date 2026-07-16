Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA01400997;
	Thu, 16 Jul 2026 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212102; cv=none; b=h3RI3PzmULm9r+JHv2ilQELyNeEE+b3d+TSR/wJ7E+0rRWQsTXCAO2haCgWVeqdTmTfF41O9XO3po6bMjP2OD88VXTBGewV7TFmuafpDulFnJIweNeywftbriXd6frK0KQl3YDD9OZ5lrvEGVTpSeikPx/F45OkeuRqnDE44Fto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212102; c=relaxed/simple;
	bh=MZi84VM70agXaTGHhZtgtOr/U1k7fQQu8o8ESTYfiF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R39hhtQ8SrGi76ZMdY1PB5dgw5tfI0HhhT5bZrJx6x0X+DzgjzTt4HsB0mA5BUMEF/Xoo3v1851ANm9ZDuM8m1HA409gHyawSsgPYM8Kh50JtmwmZZMirs4FtAZ+7IbSBZt53153g3+5a6PjGb4ELHl7gX3Gc8lx80WBQhee8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lc6Xysnf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lc6Xysnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F091F000E9;
	Thu, 16 Jul 2026 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212099;
	bh=IktfxFxSDyykz7z7jwr+islU5ZMzq/lnFwoDI+vffhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lc6XysnfDWEhS3eU2dpancnJYS+i3597WKPFfRjJ6cdqONIXstAizFTRiOEbOWqKv
	 Prlw+bRJGcFpdUFqSojZvyJqFro0smS8rXSbUvNZp3mksgYUEaPYXbCsxKai2c2qGP
	 bx1K90TJSacdYjtU26lE+Yuvi1JhgncRm3/fF/3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.12 200/349] tools/mm/slabinfo: Fix trace disable logic inversion
Date: Thu, 16 Jul 2026 15:32:14 +0200
Message-ID: <20260716133037.846662755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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


