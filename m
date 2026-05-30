Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48762FDC5E;
	Sat, 30 May 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162029; cv=none; b=ka/sAAcgXabVASJW2yAV9oy6K5AVu35nx7Lv+gXU6PNjExh4il/LipipsKJ7rfmo9YbCySqrtiMpG0l9qz3VDJbf8ac4uAirrvVUCu3hSDV+u+i+kXkpeNUS5C/ocNE83rfs8F8iq0s6sV9BhSZNTnH8rKsUIiTdCacRJIxR6Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162029; c=relaxed/simple;
	bh=TGV8OV72sAIKlAp/p3jOo0nIuvoR+yidRFlyH74hT1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msv8TcHbDRd18/92LjVxQMEm+WEuBEB2OMo42XDQLi/4sySHoh+OmoNDI1jINvGERyRdEO4ZCzqIbAwnU+pfWxlgs20cmRQLo7H5U4cIip7h1OuuZY3cknYbFF4EcCJ/gn9C8M2UrDHwLkJWAfgzX1iLpL+1IWEAcJl0SQ/3BTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aShk8tBV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aShk8tBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384821F00893;
	Sat, 30 May 2026 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162028;
	bh=nTwsonZuMHYf5lTrL7ddn6VXdPOYOWRVPsBoTK62b4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aShk8tBVyiMKhdgk0XtLcpLTua8tl/qLMpqRn37Mkt6DyjcMvLzrkU5bJ5WDCOT4v
	 lmQrLKX2DtAy+ExarEQ1ek3o6x+fXlym5rdSxyyNbVkG8ngrrr2ewgugie2v3GtRhx
	 e4co9QiRujErInRmDbEOEuOIpLa6X9AoWMY+BdmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wood <thepacketgeek@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 770/969] net: netconsole: move newline trimming to function
Date: Sat, 30 May 2026 18:04:54 +0200
Message-ID: <20260530160321.845541900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e797f1ddc31c..f9bf2c9a3ae2a 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -240,6 +240,16 @@ static struct netconsole_target *to_target(struct config_item *item)
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
@@ -404,7 +414,6 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
 		size_t count)
 {
 	struct netconsole_target *nt = to_target(item);
-	size_t len;
 
 	mutex_lock(&dynamic_netconsole_mutex);
 	if (nt->enabled) {
@@ -415,11 +424,7 @@ static ssize_t dev_name_store(struct config_item *item, const char *buf,
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



