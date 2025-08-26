Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC21034F49A;
	Tue, 26 Aug 2025 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216253; cv=none; b=r0rbn1BVcWtBFyDGZvW+Gka48/CnbB2TTcozwbWEznrWiUJItI8AAUYM8oLYufGSu/Kj7bAtWwWjPrxF0EYIrd6IB1qqeCl3yIXoWmeMQIiqgwh1xhqTCYf9yPC0PmUEzZtw5GOHt4y65TCLjJrfBwJFAXFCHsnjzo2XzDgD6QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216253; c=relaxed/simple;
	bh=fRkE3D7+HFACO5iU1jkKB91oIPTFhfhekZbRYnH6gqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvMFluzLKzuwu+uML2PNL5dKfTHeHbr+WOf/ZPNYqFDXJFFecQglIk/7bHnbzfPJsupMajRO1k5jz+EWETwtj7LRDQ8AEM6NxNi4XJFOEIsjvRw+Y9L29S09h1sFNa3hYhzwItI/EYGBJIKoLyjSAj1KWIwmHXEqM9x1Tqch6Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEl1c9W6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEl1c9W6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F40EC113CF;
	Tue, 26 Aug 2025 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216252;
	bh=fRkE3D7+HFACO5iU1jkKB91oIPTFhfhekZbRYnH6gqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEl1c9W6OF7h9UhC1prMvzAo6cKuod+MJrT91NhQ/eWSveXkHzKtX/HlJ3QGcnuYw
	 MAq1hD3xmZPu3VsmgahcaS7XwWKFHbqCe8WJO0jCADrgzRPLTGsLZgWJYCwKlXnyQw
	 9GLWCT8dsttBwE6f2bHrxZemdvu8vhruq8tRhOYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/644] wifi: cfg80211: reject HTC bit for management frames
Date: Tue, 26 Aug 2025 13:07:10 +0200
Message-ID: <20250826110954.787743262@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit be06a8c7313943109fa870715356503c4c709cbc ]

Management frames sent by userspace should never have the
order/HTC bit set, reject that. It could also cause some
confusion with the length of the buffer and the header so
the validation might end up wrong.

Link: https://patch.msgid.link/20250718202307.97a0455f0f35.I1805355c7e331352df16611839bc8198c855a33f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 783acd2c4211..5c805a2bda62 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -661,7 +661,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	mgmt = (const struct ieee80211_mgmt *)params->buf;
 
-	if (!ieee80211_is_mgmt(mgmt->frame_control))
+	if (!ieee80211_is_mgmt(mgmt->frame_control) ||
+	    ieee80211_has_order(mgmt->frame_control))
 		return -EINVAL;
 
 	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
-- 
2.39.5



