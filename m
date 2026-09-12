Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52732EC09B;
	Sat, 12 Sep 2026 13:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218681; cv=none; b=tkat/8aHDfpbeNhI+WJPT3rqEPzkkkGvu64bqD6kfBdJHUiCzaj9oZTzxQ8tgViZVAEyRam1JHk+DwS9AiNHlMG2MZHcmSGzv9PyWg8PJKKdKHP6y1lMP5A7ylTAiV6+6plPknPeQOyg9kK8CB5tL4i5ryz91BhPdUVG2j8Ku40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218681; c=relaxed/simple;
	bh=gOJPXib9M57OEJK3t/oA7u8wUbJbLhC2adV2ZvvxAVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAVmBHrKSdcks3PKiqHI/Zw3uili0gW9UtF4YK2DFDfCKAO5vWQ2iavukiJ4RNG+w/4uTCr9/C4n9rRoWz6UW4onhMK4gromYliL2TxOkpxDARRWfje2sEgvWZoQDKGAXDLyQB+/ADDZx0IU0wgHp2EeD00fsGwRAmWb52E8tT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkiSLMjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkiSLMjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34731F000FF;
	Sat, 12 Sep 2026 13:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218679;
	bh=lyTwY7KlIz0kUskNxUG7LU3oWu6QZXnBQG7pgf0dSLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkiSLMjlXjP45KFXTjrTqDLnARwraCrmsz2gCLNzQKIutqDUQOnrwK8+Wcl+6OwCG
	 CGwkCp3GMKmjgzxVOqq8aPbhLNH8og5tIH6XETmlq3KbyfnPdWgXyiksJP3QGoMv4L
	 lwfrY8gtjL3MAQRFqhRXDMQQlIgFrNfN3MFfbNCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1193/1376] net: dsa: b53: fix error propagation from b53_fdb_dump()
Date: Sat, 12 Sep 2026 09:00:19 +0200
Message-ID: <20260912065634.139177659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4f1d06cf8aaa9d2cb18e5ee8835aff6177256bc6 ]

The blamed commit replaced "return ret" statements in b53_fdb_dump()
with "break;" which jumps to the mutex_unlock() -> return 0 section.

This is notably problematic because it swallows errors from the
b53_fdb_copy() -> cb() path, and this will result in FDB dump truncation
when the netlink skb overflows - see commit 21b52fed928e ("net: dsa:
sja1105: fix broken backpressure in .port_fdb_dump").

Let's go back to "return ret". We don't need to preinitialize "ret" with
0, because the "do {} while" block guarantees we cannot reach the end of
the function without at least once calling b53_arl_search_wait(), which
will have initialized ret to some valid value.

Fixes: f7eb4a1c0864 ("net: dsa: b53: serialize access to the ARL table")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260812201121.2012356-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 0b666a77ea977..04027cbefddba 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2020,7 +2020,7 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	mutex_unlock(&priv->arl_mutex);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
-- 
2.53.0



