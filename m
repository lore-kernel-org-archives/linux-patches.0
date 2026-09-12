Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F782F617C;
	Sat, 12 Sep 2026 18:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238549; cv=none; b=YFGmG6NyrF8DT/XX7sAcz3hAeJkj1OCJHI481b/nuPdUJa/ruWJsfm064EGiIJ2RWtfWgjOM8PjEomH+qMqjITmhniVLlZUpO9PI0kVNaxdVmATDPBA3SRIFzS69PKiZDltVnLDdgC4SN2Cjpzcqn2Rl+G4UpO7Cw1+/vA81vQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238549; c=relaxed/simple;
	bh=J/qNusSRBpMZ7HuBBTFm7iVio5SW6TvSiBQvA9o68kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwqERQins9h90FXJWRtoiCY+hszrPK7TS5Q+/uFd9l0B70xae43X3q5oDcXNXBkDsqYua2Peu0iD8zsWnO6j6lld5vPGbmexurm1TdEYUsULBhAaBpykiGgqrdMgIk9Qh1Wfnjf2cX+Kr7IEtXdXwO5bparsMwsCNY0RXQJWGFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtLfMRGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtLfMRGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C831F000FF;
	Sat, 12 Sep 2026 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238547;
	bh=hT+JJcmnooYBt0f9BRUK939uDOCPrxEnPKQy0Te+Yao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtLfMRGhD9p7vtu+w7Tq1E1YEsQYqvMHa/71nGUOmR30HY9XUfqUZHCnTtiijkLyW
	 UVxA+p6l1cp9bBczeT5fA51/09C8Z57wy7tTFZOAh946IDFs4zSk6G27OItw38KbWD
	 pH6eyzu3j4rEsPQ2DMYlM2JKHaK5AtI4RwjHbjJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/935] bus: ti-sysc: Fix /chosen node reference leak
Date: Sat, 12 Sep 2026 08:57:57 +0200
Message-ID: <20260912065537.083553109@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12ab9bf160c97..c9fca3c4f4ad0 100644
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



