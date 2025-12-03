Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448B35BDD6;
	Wed,  3 Dec 2025 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779782; cv=none; b=piQAN4l1Tzlm0F6T2gt2EnnKU3Uie7+7TQmbNwd+ZxhIioPrCYIOVYpjNenFGZOiDjty/FkACxO/taOxuUwpEesRT1sqT1w9cwTlu6wBi4jEKFSAIYzipDjz09I4xadhdoq+BVKPbYRzqDsxQMNk22mqQg/y8anb3RzguNI3/kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779782; c=relaxed/simple;
	bh=CZrNPmct2ogEErAnea+NpStMZfDqUuDFYws0Z4YcMMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efWShMfBYl4Z/3iJAjwss/m+CAX4CiKfsaOg6OT+nIhVZa8SUq2CsErhZio3XKCpj0pRKupyT+2mZKsd6Ol9zd2QIEyH9gCu3aprkE44+W367TRV4NsJOLRiqBxeC0kFnsKSlFhn9QN/c3pREwLvaPP3kGsrvqjKCv0r9/kyXAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONtI4RRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONtI4RRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EFAC4CEF5;
	Wed,  3 Dec 2025 16:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779782;
	bh=CZrNPmct2ogEErAnea+NpStMZfDqUuDFYws0Z4YcMMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ONtI4RRE9gYbG2+ulCtXF67LoBVULY7RJA+d8tlzvDdKPXvr8wv3VadthUdXaxCzD
	 I0+s/dsWJ2gKp+bzIGXaxoC+9oh7QqPNtJCFnTBVFbtUFpPnhenxanYQjqF0b0ydt3
	 svt5ncarjGdfWjwe9KyVlY2HSngGcLM7ya+Zyuzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 360/568] wifi: mac80211: skip rate verification for not captured PSDUs
Date: Wed,  3 Dec 2025 16:26:02 +0100
Message-ID: <20251203152453.887720695@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 7fe0d21f5633af8c3fab9f0ef0706c6156623484 ]

If for example the sniffer did not follow any AIDs in an MU frame, then
some of the information may not be filled in or is even expected to be
invalid. As an example, in that case it is expected that Nss is zero.

Fixes: 2ff5e52e7836 ("radiotap: add 0-length PSDU "not captured" type")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110142554.83a2858ee15b.I9f78ce7984872f474722f9278691ae16378f0a3e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 776f9fcf05abe..1cd75c200cfe6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5228,10 +5228,14 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 	if (WARN_ON(!local->started))
 		goto drop;
 
-	if (likely(!(status->flag & RX_FLAG_FAILED_PLCP_CRC))) {
+	if (likely(!(status->flag & RX_FLAG_FAILED_PLCP_CRC) &&
+		   !(status->flag & RX_FLAG_NO_PSDU &&
+		     status->zero_length_psdu_type ==
+		     IEEE80211_RADIOTAP_ZERO_LEN_PSDU_NOT_CAPTURED))) {
 		/*
-		 * Validate the rate, unless a PLCP error means that
-		 * we probably can't have a valid rate here anyway.
+		 * Validate the rate, unless there was a PLCP error which may
+		 * have an invalid rate or the PSDU was not capture and may be
+		 * missing rate information.
 		 */
 
 		switch (status->encoding) {
-- 
2.51.0



