Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA048386441;
	Sat, 12 Sep 2026 19:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242386; cv=none; b=QbWwoJGbFgPBd+VYi+LZp9db6pwyatS+popJSXlFNnWSfZ3AccnHo+qGEUZPpv/05pWLjhPko6bWMyVNCbVWXRi+6+FpsLtwYKols2f+BsE26V58aIGoJx/WARiMKQFgJm4eVJWCeCOMuKt31Z1jAQ1WsDErcKHKoLiSSORn44I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242386; c=relaxed/simple;
	bh=sQThyr+PUyG5EHUymxN+Juv1Ih+Ao+xpH/w6cDIrHVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PebO9cY+uYo90SOJuT0l00P6D5kzrVB40Ap07VmoxK1S4kGMtYy1CpbC6iBIU0tyWFK0R3U+rNZ/85Spbe07EscztnAVUbDsuLI5a6w5wtT89yJrV3tgfAOHIoY8GNqtMATe99jFG+7BbpXiMvZkCUTlVASkuWy6eYN2gTRVz34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLJ4Y00t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLJ4Y00t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A241F000FF;
	Sat, 12 Sep 2026 19:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242385;
	bh=CVhSfM8NIKrI/9yCDvBsUi9g0hGU1Feq2VMmupl59P8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLJ4Y00tuurMK0nkdcgdP4QPuUzWQjwt+LQGmXVsgWtLGEBbApbU2aqQBHtWMdLux
	 KkK4mx2VbJMDOMKGnncatgfvTaEtIs95/No10jgYorCg+qA78lgLvsexu37UwW67WQ
	 ImTk34/r2u8RiGGljfzFzKNsBK9OkWnJsInaeK/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 378/798] bus: ti-sysc: Fix /chosen node reference leak
Date: Sat, 12 Sep 2026 09:00:06 +0200
Message-ID: <20260912065525.821038399@linuxfoundation.org>
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

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 6342de0aed216b6df460b492ddb532b3e0ed16f1 ]

sysc_init_stdout_path() gets the /chosen node with
of_find_node_by_path() to read stdout-path. The function then overwrites
the local node pointer with the stdout-path lookup result, or exits on
error, without dropping the /chosen reference.

Keep the /chosen node in a separate variable and put it after the
stdout-path value has been used for the lookup. The successful stdout
node lookup remains referenced by the cached stdout_path pointer.

Fixes: 3bb37c8e6e6a ("bus: ti-sysc: Handle stdout-path for debug console")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260615200540.770205-1-dbgh9129@gmail.com
Signed-off-by: Kevin Hilman (TI) <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index fe5b0997aee6e..132867f2190f6 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -692,6 +692,7 @@ static struct device_node *stdout_path;
 
 static void sysc_init_stdout_path(struct sysc *ddata)
 {
+	struct device_node *chosen;
 	struct device_node *np = NULL;
 	const char *uart;
 
@@ -701,15 +702,18 @@ static void sysc_init_stdout_path(struct sysc *ddata)
 	if (stdout_path)
 		return;
 
-	np = of_find_node_by_path("/chosen");
-	if (!np)
+	chosen = of_find_node_by_path("/chosen");
+	if (!chosen)
 		goto err;
 
-	uart = of_get_property(np, "stdout-path", NULL);
-	if (!uart)
+	uart = of_get_property(chosen, "stdout-path", NULL);
+	if (!uart) {
+		of_node_put(chosen);
 		goto err;
+	}
 
 	np = of_find_node_by_path(uart);
+	of_node_put(chosen);
 	if (!np)
 		goto err;
 
-- 
2.53.0



