Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6C11A6161;
	Tue, 30 Jul 2024 16:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356861; cv=none; b=XAoMSQGGZNbFmpG8pITVg+qYPjKttcYyHTLkEnxAdmh4QhO1GcvKxGPkGk3DEyk25XNTOyQzDK0ME9Jv+uGzjZ7Wl+XAyC3mI21boBu1VTRNII/ZYwOCTDuFYAh9vwDN9O+uCsUZtDYqfGO4jQFCQOq+mXWkop35lQ2qgHyobVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356861; c=relaxed/simple;
	bh=rx7NrnmemLcpkzISaW7tYNcWq7z0lQg5Lx2t2PQMhpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDS4KZi4mnYrtU+FlX9znn1iMWXq3Ekka84ojxx6JrNOUKr1XyL5nd8E46TuB5VmTU6mlcPBW074pax91/CTuwbP/FyRxufPXX1sDJd4LRk6ZhPEJLkEKYRacgcUNXNg/KkGeFrmlDZ6mkBMJ8SY3tvBBjnDbXt8NYjcN9BpwN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0iC5wG1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0iC5wG1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9D3C4AF0A;
	Tue, 30 Jul 2024 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356861;
	bh=rx7NrnmemLcpkzISaW7tYNcWq7z0lQg5Lx2t2PQMhpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0iC5wG1ipkJMoEmj7IfRSjvxk0duIcGneMWtdOzWIg4bnJ7My6K5BpMwpuVRC7wYW
	 GgcNqiJSaZw4M+fPvyARA/QRIthC/jDTMdIfqgmqG1AnGMIq4WarLJdJSbSEImkB5j
	 o8yb07NUzexnHAj4/V8ZYGGvOQt5/Rz3/W06KvGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 194/809] wifi: nl80211: expose can-monitor channel property
Date: Tue, 30 Jul 2024 17:41:10 +0200
Message-ID: <20240730151732.271155900@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f3269b7912f75b6e34926334377ede45656a8950 ]

It may be possible to monitor on disabled channels per the
can-monitor flag, but evidently I forgot to expose that out
to userspace. Fix that.

Fixes: a110a3b79177 ("wifi: cfg80211: optionally support monitor on disabled channels")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://msgid.link/20240523120945.9a2c19a51e53.I50fa1b1a18b70f63a5095131ac23dc2e71f3d426@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 72c7bf5585816..0fd075238fc74 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1208,6 +1208,9 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
 		if ((chan->flags & IEEE80211_CHAN_NO_6GHZ_AFC_CLIENT) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_6GHZ_AFC_CLIENT))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_CAN_MONITOR) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_CAN_MONITOR))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-- 
2.43.0



