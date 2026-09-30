Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2C24C4F58;
	Wed, 30 Sep 2026 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783409; cv=none; b=RrxhHROmNJeRtxE+cwUVoY08SGMyUHRtUshuFDJ2oHnH+gYMlSs0flB0J0739qL3r5rSlgjpTWUN0lexlcYl6B9AlgL+GsrDvI873gnYy7zKz9fsZjaFjFfRcmAsUBTxPFSLLHBScxB9B+O1KH/BgIXdllUd4ufZejR7fPLmObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783409; c=relaxed/simple;
	bh=LFz0keq1ercnDrNMk6zD5Q6M1AVhxLbd/WljNJmMIic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqQSkBR7ORrx7Oi+nWxM5S13386FUXIe8UXHQBsxR7gXS5cHqFLaPMIcYiXuJM3RTmOC89lITV1Es5hj17kC30aEXgU7hUao6A97J2e9veMbjTmyoE6tnm2zZNn98BKKF3rTgK6EfLXhG3JhUGW5gLbDQ/Tir3Zvu4Wvsd0tHYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOu60mxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOu60mxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33FE1F000FF;
	Wed, 30 Sep 2026 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783404;
	bh=qNFD33eVy4YLZe2T8vAcp7QpTfduMSPZqgwEIRswHPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOu60mxCPl7eNJnlTrbg5PFTlOFE2GkqlWiIUtovurJF/8VddyG0qKTU8nHYgbLo0
	 Qa6a31DjEQcUqDtYr/dd7eeZfr3pAp4jBHEcSmAi2RxttrdFsL2jZzah9e1STGrdI+
	 bQKSrErFhhCXQ5/rdMUYdW2m5NTfnBintAsmuVlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/595] wifi: mac80211: dont access the TSF of a down interface
Date: Wed, 30 Sep 2026 17:24:39 +0200
Message-ID: <20260930152355.977795261@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0b1de9feeb8651f7a3bb53ed7c9006e3b5298c01 ]

The tsf debugfs files call the driver even if the interface
isn't up, tgriggering check-sdata-in-driver warnings.

Reject the access in that case.

Assisted-by: LLM
Fixes: 37a41b4affa3 ("mac80211: add ieee80211_vif param to tsf functions")
Reported-by: syzbot+1c8c45017f784e646b47@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1c8c45017f784e646b47
Link: https://patch.msgid.link/20260908122838.201719-18-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index fe8a7a87e5133..0f79cb14763cf 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -522,6 +522,9 @@ static ssize_t ieee80211_if_fmt_tsf(
 	struct ieee80211_local *local = sdata->local;
 	u64 tsf;
 
+	if (!ieee80211_sdata_running((struct ieee80211_sub_if_data *)sdata))
+		return -ENETDOWN;
+
 	tsf = drv_get_tsf(local, (struct ieee80211_sub_if_data *)sdata);
 
 	return scnprintf(buf, buflen, "0x%016llx\n", (unsigned long long) tsf);
@@ -535,6 +538,9 @@ static ssize_t ieee80211_if_parse_tsf(
 	int ret;
 	int tsf_is_delta = 0;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	if (strncmp(buf, "reset", 5) == 0) {
 		if (local->ops->reset_tsf) {
 			drv_reset_tsf(local, sdata);
-- 
2.53.0



