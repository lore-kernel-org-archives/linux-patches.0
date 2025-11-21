Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F48A190477;
	Fri, 21 Nov 2025 13:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731555; cv=none; b=ZkgOkdmzZgpI9ayiCwQPzeGxqL6o0b7UvhWlozP4aBQ0wuhRMBb7stlqmUNj65jakEFDiKzQwzc8tyh8wb4oJ3Rrzae0SAAnIUqcawQ51grVSZngnS5lX5Xusf/y/obWcYVePmTm91BNXR9tVP6N26YyFOFNGgCU0E1VBM0errs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731555; c=relaxed/simple;
	bh=n7k00I3nzAs1usam1SzcjExMLn9nPHDCsdVZHg/klEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaT92aKQQ7OlGzqvvbgJlZGGNEcebXsJbwYniIECG9i3ACIB40xFuIeSMVw2z2dQ8tZsZ2UF+pe/1GtdWmhvYzy1VZry5TPUif69dzIyZi3eOoScCtoW1bMFAI5QrHxEI6Ew1rWPdpLRD9qAlZgn6xHUGC16w2hXoDwrWZu4OSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNfYRa5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNfYRa5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF9DC4CEF1;
	Fri, 21 Nov 2025 13:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731554;
	bh=n7k00I3nzAs1usam1SzcjExMLn9nPHDCsdVZHg/klEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNfYRa5qut9m86U9yBk6epO0+utYNZcNRiPJ69C/DiM/FxxhGUWZTomc2dyc0IArB
	 BIoXD1wrFJ1hr01h6Io46bszWWtqVngaD9RcyKXezQQuOAfgE3KBCIsxoGaxTZiPWy
	 h6gu1rfXa1vmDa0bTcbUM/UopR0s6BwiE6jUC64I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.17 227/247] pmdomain: imx: Fix reference count leak in imx_gpc_remove
Date: Fri, 21 Nov 2025 14:12:54 +0100
Message-ID: <20251121130202.882101241@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit bbde14682eba21d86f5f3d6fe2d371b1f97f1e61 upstream.

of_get_child_by_name() returns a node pointer with refcount incremented, we
should use of_node_put() on it when not needed anymore. Add the missing
of_node_put() to avoid refcount leak.

Fixes: 721cabf6c660 ("soc: imx: move PGC handling to a new GPC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/gpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pmdomain/imx/gpc.c
+++ b/drivers/pmdomain/imx/gpc.c
@@ -537,6 +537,8 @@ static void imx_gpc_remove(struct platfo
 			return;
 		}
 	}
+
+	of_node_put(pgc_node);
 }
 
 static struct platform_driver imx_gpc_driver = {


