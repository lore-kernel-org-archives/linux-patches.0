Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF5A3382CB;
	Sat, 12 Sep 2026 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222753; cv=none; b=XAlN27C7j8qEF42INQrwdakHMzAFarhmHqXNfPdInf51xUo92gx0wZGbQ854CYvM2tGc/lOske7jIrLSbj2NeUJOkuD/zrAMgLigcfdajegq0NePeMl3mxWwfxubh797lc/20S5TRRvFK+oocflayEdA3QHddkjZq4qvk3fbYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222753; c=relaxed/simple;
	bh=Q8xV7s5K1yTYU3w9BmbQ0wHo/rIW6GAbkgyGItHIiTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYwh9Dz6L/z2ShCExmRtyNjqrlkna7IFdRyWQnu5r4uPuwsvmFt8O53ypgqq/oUJizShZgexliV3PM2dfMxpwJl+csW6aIJpvOx0ROdzvvjO+75PnWRgsi4wld1idWLWouxZv6obVWik+NKnuDR6vsKPNpl3zoBMcgrA+M7odWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EB2xEOrO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EB2xEOrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17771F000FF;
	Sat, 12 Sep 2026 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222752;
	bh=ATc3ZbJKP76NOZHdMQwhGmy5RNPdjOyxggsa6/G0Qbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EB2xEOrObAVISlnpQIDmonYFPlEiIIGUMgl3uT++c3txWpmrIMZm6JYFgg5ZnPvSs
	 P+fwkS2F6gvDTGCStci71eD4SQsjYZxzWboATPrryyUxqgQRgjukZEOQmN5HB2tNJ6
	 PnZoaM1tE7IzZ8h3Iaa3KMDolXzQTB07+iRHcxlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0650/1424] bus: ti-sysc: Fix /chosen node reference leak
Date: Sat, 12 Sep 2026 08:51:22 +0200
Message-ID: <20260912065621.845672512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index b6a7d0d3f153b..527a7690e19c3 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -672,6 +672,7 @@ static struct device_node *stdout_path;
 
 static void sysc_init_stdout_path(struct sysc *ddata)
 {
+	struct device_node *chosen;
 	struct device_node *np = NULL;
 	const char *uart;
 
@@ -681,15 +682,18 @@ static void sysc_init_stdout_path(struct sysc *ddata)
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



