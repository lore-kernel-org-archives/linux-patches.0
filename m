Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049414;
	b=pJlRBSPKE9qYbmQHfzKB+RdyVZ21g9/kXTcScDuDQUE3iMU7ObL83MVT/WJ0F0KjNBeQ
	 K/ZMZltiA8mYnZw6HCZqSETKAzkg37d+fXf2Bn2qZVXzmQj9KKMN0HjoBjYDDmmW9LICH
	 WG0UL8kciuekbGfvTlf2+n1Q4zY7QdNUdi5Hb0/oQUP/MyalK1yOdFdBXtE64r5XYz0//
	 ZVh1EDfLfZxLkaySBdAWeFkA7NKGL7nghzb+ikQo4d/HXyC1nKqHGtAw4navoYgbVTnmA
	 I4V5ZwboEeLPQ/XVkUlcbRUBT58wpnZBgHtNESqYpwxZipAO9oN8o4NzG+e6uMgZkMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ggm0OsopoZxEKheppJKL6GH50wkFvNN55lG+NtgIddA=;
	b=wnv1w+BmoQ17RdOiq9o0E61XzPmz8JsmtBaazgw2wswtBJ4mHXJtO8wvupux2mYEK6xc
	 SB0WtRsLd3NmQX71Yf2n/IFJYfj1AwO9/R8xHuCi2v7M+qrKFa+ArmiZjUkzLb0tu5r6F
	 DJLldyYaR/D/zvV9J5eIXxugRXZYa/uFxmDlVfGx6gbkfWIwtZu/y0QKrvN7AJO1rACq+
	 lj0BC+aZNNKIEXXL5Gj6ozUCjTUVIrE3rxak6WOLE+qtf2CLfV4fDGohbkRmZhJc4sEz7
	 ciTpuMe8uz4gHkjuN8sEQOdXw6oF5tzVLkhZMvvbQA8tX8S71+xD7ki8/eYAihZe62A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1LXkq8M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC3E606A325;
	Thu, 19 Nov 2026 00:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1LXkq8M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31D41F000C4;
	Thu, 19 Nov 2026 00:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049414;
	bh=Ggm0OsopoZxEKheppJKL6GH50wkFvNN55lG+NtgIddA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1LXkq8MX/0qK1YW6HbZJjyIsZQJWNGQNkK97X/eAJK8A5gfC8fh28h4BnYG7S/XQ
	 TTey1QJEVBifE4jYFJgvENEG9z234kWIgNWurUaC6R4O582kKrxpyT+lJhqdA2iAl7
	 G0w3D7i3SNuwhD7ScyDK7040INSWkCu+yMVSGNnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2343/2857] wifi: mac80211: kill wake_txqs_tasklet on unregistration
Date: Wed, 18 Nov 2026 15:56:17 +0100
Message-ID: <20261118150325.890403175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8ea4f50c3426aaaf3f4c118ee2c2876326ca5db5 ]

We never kill the wake_txqs_tasklet so it could be running
while the hardware is being freed. Kill it, late enough to
never be able to restart afterwards.

Assisted-by: LLM
Fixes: 21a5d4c3a45c ("mac80211: add stop/start logic for software TXQs")
Link: https://patch.msgid.link/20261005224950.3fdb8d0ff377.I851e79ac625c4926e211642ee7a7e458728b0ad3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b695c0b6728ed..e3e59fd64650c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1497,6 +1497,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	cancel_work_sync(&local->restart_work);
 	cancel_work_sync(&local->reconfig_filter);
 
+	tasklet_kill(&local->wake_txqs_tasklet);
+
 	ieee80211_clear_tx_pending(local);
 	rate_control_deinitialize(local);
 
-- 
2.53.0



