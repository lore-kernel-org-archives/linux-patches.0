Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1362EBDE9;
	Sat, 12 Sep 2026 07:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197600; cv=none; b=lBHBf32JgPJqPk6btUE4FgaZuY85dhQhaubePblkfC6ldoAoB0yD00+1kSLeZRL1dmBA9mMgI7wkpJCk/Yma6lkUJKJNzP647XEykgXGJAU8TRzBJGMEo8yl/zNMz/CvKfLRb0A6iupLL/9DJmuZ1X7ljmCA9XK2zfIdlpcxn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197600; c=relaxed/simple;
	bh=9/R7ggZxI4lnI8gFK+j52S69udAVwGFlT0k1mw2Tv7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frLa8bH9D6TQHqemgiY8qT0X9o5Tb5OVjfSCWnAPd+amwHCffhwIdyKhYKqkpFJnKym7fQE9iwlbYSULDNzDQGFYX4my4XjIc029iOtZ+F6rfd7jg/zJfZHoMMbIhZmAFTqoayPJdWvw0hYGxL4jx+n0rTZdmvBe7KCbQ1TxFzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiA2Jn59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiA2Jn59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C9B1F000FF;
	Sat, 12 Sep 2026 07:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197599;
	bh=UcW/VmJzd1Jag/JS2w6dlcPNOErub0G9gLvQVfS55QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiA2Jn59JwSQiVCpNehKtSYVpsAKoquPvNHTwPWkpV6iDeRoI661Ww8MQfc1GHtVR
	 WVo2ZWfXuvNyQpNtZai2/tjX5mwRmqGubvFCV2jW7vnkrtY7t45/Ue9q1cqem2Huve
	 pwt9XRQrdBN1By36pJ1OL3fBnahIurKCg3c27Ic8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0208/1815] bus: ti-sysc: Fix /chosen node reference leak
Date: Sat, 12 Sep 2026 08:32:38 +0200
Message-ID: <20260912065653.881192871@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a5b9507de37c3..e118b900c9ac8 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -682,6 +682,7 @@ static struct device_node *stdout_path;
 
 static void sysc_init_stdout_path(struct sysc *ddata)
 {
+	struct device_node *chosen;
 	struct device_node *np = NULL;
 	const char *uart;
 
@@ -691,15 +692,18 @@ static void sysc_init_stdout_path(struct sysc *ddata)
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



