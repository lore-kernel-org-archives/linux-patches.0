Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF9400DF6;
	Sat, 12 Sep 2026 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212648; cv=none; b=kO5uijAq3/dr/Tnlt6VFpvKh1rap2FkgEzg0JCpxRkLpRZcwZVvTovX9JeVLqGGHwJJHEhSplqIvkn/ADFH8kpSSShXvNUupG9308HxyeuE4nTSsK1b5hGkiNuM77tfP/oOUl8YsNaukxkLiS1iiKLp9HIL9Qzg3E9IwmS3pdjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212648; c=relaxed/simple;
	bh=pzY+uvPPx8gBMld4Pyp7TijBuanI+HFRIGmrs1zd0tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=me+8qzzGMESU+b7h7WMhidz/KGK6OEfJ2KznnYyjotIJGGezRawtPlNp9JYINW+YtqENM/XzyiD3Rzlni021DT5UYz1J/KI8ibdJzrcHaWCIN9zmFP3kOXqQm7guGB4Dlakc4vXqb28RjaJDdUh+Z90Gulj8XMCgMTUWs/1mZrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW9XaptW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW9XaptW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DDE1F000FF;
	Sat, 12 Sep 2026 11:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212647;
	bh=tBRBqohQlEkjYvLayHpfzyKesPRwtRdFjl/jUa6of5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PW9XaptWU1WUAK9l21su10+rPTp6PCisBQ9LRVw6D/yz46akRNhUkzPX0LJuTb/VU
	 Pjs3Hny6mz3BXGxhlIE/5421SPQOuSw1Inowe0/stRQY+xBgBUvBbDISl9QMMAi8md
	 2bHIAbEVfKJeHIQ5P6LwU9oCAPg3dBPnGgfBgp0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	stable+noautosel@kernel.org
Subject: [PATCH 6.18 1480/1518] wifi: nl80211: fix UHR capability validation
Date: Sat, 12 Sep 2026 09:00:49 +0200
Message-ID: <20260912065657.038576266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a140826caa2c14aa5a9a6990e514c5edbdb7eafd ]

The ieee80211_uhr_capa_size_ok() function returns a boolean,
but we need an error code here. Fix that.

Fixes: 072e6f7f416f ("wifi: cfg80211: add initial UHR support")
Cc: <stable+noautosel@kernel.org> # no drivers with UHR yet
Link: https://patch.msgid.link/20260303151614.e87ea9995be5.Ie164040a51855a3e548f05f0d0291d7d7993c7ee@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9c713094f0a5c..232218818ed7f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -372,7 +372,9 @@ static int validate_uhr_capa(const struct nlattr *attr,
 	const u8 *data = nla_data(attr);
 	unsigned int len = nla_len(attr);
 
-	return ieee80211_uhr_capa_size_ok(data, len, false);
+	if (!ieee80211_uhr_capa_size_ok(data, len, false))
+		return -EINVAL;
+	return 0;
 }
 
 static int validate_uhr_operation(const struct nlattr *attr,
-- 
2.53.0



