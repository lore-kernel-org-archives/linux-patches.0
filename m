Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ACA3148BB;
	Wed, 20 May 2026 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302836; cv=none; b=E7iLOWQ4CvG0Wy41/WQurSnV5QcBEgEO61SR+nwtshxuwTZ1+6Q0O9QBXaM+84hts5fh0GDroqpvBgOpksldB4Ne9JFurlauIBy5MGRabmK2RwuxvXOtggxr5akxM4ylhW7rBQgsEg+OonxdAJaH3cQ/ApafjFgERxOKbYYrKxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302836; c=relaxed/simple;
	bh=wDeVkJuLlRBikpresgs2Qcwe+57jxnoyaYIV68NpUJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtMCY8v1kvWxDQl9dY0Eg5eqYEpCWHE1W81zoT1wdz/9Z/5gzzs53gWflEn4vDXxcWqtYsC/zl8lohC3wfV7nTg+Fo8mtxamvOAlfMuIeKUvQ40KhSc5uqRPNUbehRcc/iG8GOVUFw55b3PwCgP6cj1miLo4fHYJw749ZA+GfTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDMZglPi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDMZglPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328911F000E9;
	Wed, 20 May 2026 18:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302835;
	bh=1g3DA7xA93FwbubqwHp9E3Jn35rIa+dpikdsZ5llJYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDMZglPi8P0OIJzHAqfaMogglKDtyFy7tbmSEM0spFpO2uoW/PZgMpLiMSXQa8k4l
	 YYtJYms4G1kQIOr4tnI+z6ccwP4vCKcV5u5ST9wZGgC62utInSj53Z1HCPoFwoUunm
	 qmNliXWIBH4z2No484Zm2fUPH3+JlrtSwlrzqwr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wood <thepacketgeek@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 417/508] net: netconsole: move newline trimming to function
Date: Wed, 20 May 2026 18:24:00 +0200
Message-ID: <20260520162107.642354068@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Matthew Wood <thepacketgeek@gmail.com>

[ Upstream commit ae001dc67907618423fd15bbab2014308c00ad0b ]

Move newline trimming logic from `dev_name_store()` to a new function
(trim_newline()) for shared use in netconsole.c

Signed-off-by: Matthew Wood <thepacketgeek@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 92ceb7bff62c ("netconsole: propagate device name truncation in dev_name_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netconsole.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 9c2e71b9c0324..2045872de5328 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -272,6 +272,16 @@ static struct netconsole_target *to_target(struct config_item *item)
 		NULL;
 }
 
+/* Get rid of possible trailing newline, returning the new length */
+static void trim_newline(char *s, size_t maxlen)
+{
+	size_t len;
+
+	len = strnlen(s, maxlen);
+	if (s[len - 1] == '\n')
+		s[len - 1] = '\0';
+}
+
 /*
  * Attribute operations for netconsole_target.
  */
@@ -466,7 +476,6 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
 		size_t count)
 {
 	struct netconsole_target *nt = to_target(item);
-	size_t len;
 
 	mutex_lock(&dynamic_netconsole_mutex);
 	if (nt->enabled) {
@@ -477,11 +486,7 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
 	}
 
 	strscpy(nt->np.dev_name, buf, IFNAMSIZ);
-
-	/* Get rid of possible trailing newline from echo(1) */
-	len = strnlen(nt->np.dev_name, IFNAMSIZ);
-	if (nt->np.dev_name[len - 1] == '\n')
-		nt->np.dev_name[len - 1] = '\0';
+	trim_newline(nt->np.dev_name, IFNAMSIZ);
 
 	mutex_unlock(&dynamic_netconsole_mutex);
 	return strnlen(buf, count);
-- 
2.53.0



