Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335C732D420;
	Wed,  3 Dec 2025 16:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778219; cv=none; b=eh79o505e2dXXVA5SzMSbYJfgQaIboLtjuCK1pY6OzCpB4dc3wb0DmBwX0eJoeBL2WlajtZ2UYq25cHI+EimTILDkKxOnUi0hrrX9Nh2QWa2tGXS6i8cLTtYxhG/XfXMnQm0bTyoZOX3O0VcGuYfQxfoKK+Vr4DavJji0NUo1P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778219; c=relaxed/simple;
	bh=NMUDsXWQ13qIJq2GYf7L/cZmic924kQ/1OEhqnMI+YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j27ivSN2sYHYDBps5Zy3cvC0xo6fgj/AT8oOxeircvf4GoWQJCHGPmeyzlIaBYAEwWLkjf6TZfxS+4Eh0hLggQEFLGvLw/3YgMjSCIYq8HbjT2cmFEIZ1aPLDZjFNWJ9FV4KLLJ7teIMAFdXKwZ01ULp4S6kgFqTa5ZK6xaxr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NupmvJC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NupmvJC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A391C116C6;
	Wed,  3 Dec 2025 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778218;
	bh=NMUDsXWQ13qIJq2GYf7L/cZmic924kQ/1OEhqnMI+YE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NupmvJC56Bgjng5c8MkRBScjqxacZ6J9qfnfZyBhRy/2BsfPknXw3kRCVdDgzL0RS
	 unQTy7Ah3sQv7RN1Vt5ihbjx64y5iwXZCjpJxvd+yNdJk9jyswHYbQ4cGjc6olkQpU
	 Gj52Ry0kSTiwXchRIAhh6jqUfvOv5aejw5W80RKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 246/392] wifi: mac80211: skip rate verification for not captured PSDUs
Date: Wed,  3 Dec 2025 16:26:36 +0100
Message-ID: <20251203152423.224714721@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c160ff2aab90..aa3442761ad05 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4911,10 +4911,14 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
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



