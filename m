Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AB140926C;
	Thu, 30 Jul 2026 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421333; cv=none; b=cYM/MCvPiw4ZBh77SE/4sSZCySzh16QtGToN1b2bi7vzzHBVRoTx6K7CYlWOznm3M/yg37rZmGjChOY9oZpwRD5uetYFU0C6vxHfiOqDsiQWL6N1VgjP7mda4b31bAG44OLEMoueAa8BFsHioK3z8HVEOucQKncG7UB/nZGIjlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421333; c=relaxed/simple;
	bh=MHEFyROYm7PG1pka/IY51ffe4GlEvK/z5b4WuwYHcGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+66NOhlU+k2r4+oy2Gc9PqQnP6eJ4ztfODkxnUh95W0PbbjNTxuR4vExcShkTj0ZAEVejczv6XqOP3C6+6cFUy+GhOLkr4rYxn8Xea/BYEUNRTNhAtaMzDWyqwpIz1GyQpRM6Nb9hgpi8/DDBIxZHiu/Ddyat/Uaw7pQZU/cGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zevQWpSL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zevQWpSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E901F00A3A;
	Thu, 30 Jul 2026 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421332;
	bh=0YsVcLcNEFY7e19DyulvaUJA0wy+SS2G+/dWgoohdwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zevQWpSL5kbMAa32Hfy8mE/ecwLWog43a/8u6jsBWZpsMvoHAl9IApIhdSKw1veiF
	 7Q8LPrVj6l/PNTZYE0+XUEXzegf3Q6gB7B2SSOy5G8ppzZ/eCszajUfbRjzDuteZG6
	 Eb5vmLolYw7bYFOIKinaa7F3dZR1YiGxrTDl1dnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 067/744] wifi: cfg80211: reject empty PMSR peer lists
Date: Thu, 30 Jul 2026 16:05:40 +0200
Message-ID: <20260730141445.701899972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 57c05ce14fea03df01288fe1250f49197e161710 ]

A PMSR request with an empty peers array is not a useful request and
weakens the cfg80211-to-driver contract by allowing start_pmsr() with
no target peer.

Reject empty peer lists before allocating the request object or calling
into the driver.

Fixes: 9bb7e0f24e7e7 ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612133717.93783-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index 9246640d2eedfd..feced0f762e01d 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -332,6 +332,11 @@ int nl80211_pmsr_start(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (!count) {
+		NL_SET_ERR_MSG_ATTR(info->extack, peers, "No peers specified");
+		return -EINVAL;
+	}
+
 	req = kzalloc_flex(*req, peers, count);
 	if (!req)
 		return -ENOMEM;
-- 
2.53.0



