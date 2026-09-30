Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB1D5187DE;
	Wed, 30 Sep 2026 17:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788261; cv=none; b=tEcaes8DzG46+2nNIgUI803iYAWLjbEpS2wgEj+hFSBDKIx0BEbNxtqL8n+gD/QPw2ARDambIvmx38ThzSicMM+gi4lt2iOIW9UeuXRLx6+yH620lSC055mQIUrm0sJ1Dspc77d2jXf7UsxiLN5mvmll0xFaqQFQQABr6vQE39o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788261; c=relaxed/simple;
	bh=b8JFs6sZf9hiqLA5ctlMs9V5kGJ4MPsEyTPlAXSWrfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3zPSNYe+HZDbrsvFNyZjyqiucgM2T8/gqMxlsyxBD+2UV/D7iW3d+95VQj5pVohB8XtB/HtTgmdcnQpUhMOBgRFebQ4MZNjsStvb9d5m+0sqO4NuDsAgFRauEx5m8O2/lEu0aK/DfbK47NzEOZgeb9JsyXo2cTVdPux0r091so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7wCZ6RR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7wCZ6RR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A261F000FF;
	Wed, 30 Sep 2026 17:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788260;
	bh=4x+NtirnOmfA1Z5opVuMuaMuDXZNuMxAMgWi6GReM0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S7wCZ6RRNVogybD+ddQ+0KE2jRCdaaCgOAXqqazTmifPaSj8E0lpgIgzmMjaGOTA3
	 QV5sVtsAzTy039PmrwXbburS5onQ/FOvKIGjI69eA6ivMoANqxAo51InWvWVZVvmsc
	 dTqXuS1V1L/QLzumJv6vqZuOkRidgt+7Whh6nwpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1634c5399e29d8b66789@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 060/877] wifi: mac80211: dont warn when an IBSS has no channel to scan
Date: Wed, 30 Sep 2026 17:16:11 +0200
Message-ID: <20260930152416.039177757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a7491b7efbd9136b120a12ed72af9c12121dd134 ]

ieee80211_request_ibss_scan() warns when regulatory leaves no
allowed channel, but that can happen as the regdomain can change
while IBSS is operating, and it can continue to operate briefly
during the 60s grace period until it's shut down.

Just remove the warning in this case.

Assisted-by: LLM
Fixes: 34bcf7150241 ("mac80211: fix ibss scanning")
Reported-by: syzbot+1634c5399e29d8b66789@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1634c5399e29d8b66789
Link: https://patch.msgid.link/20260904165722.fe380c27fef4.I0e8bee2e12a40d240851a4bc724d47753af46159@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 07ce9cd35dab2..19e374fa00795 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -1214,7 +1214,7 @@ int ieee80211_request_ibss_scan(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		if (WARN_ON_ONCE(n_ch == 0))
+		if (n_ch == 0)
 			return -EINVAL;
 
 		local->int_scan_req->n_channels = n_ch;
-- 
2.53.0



