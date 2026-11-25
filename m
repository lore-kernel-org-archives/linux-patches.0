Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625901;
	b=SBm3HT7TUfogSyL4075bnDmAygAgEjfySRXGmyxLXMBSL93MgNcjaX0P2eW1ZoZIRp9q
	 wMnuxRTXwTZWRcke2YuFaKJsupzjEVgA5cQ4KEdf50ZLjvZMW68LJ+DPF3ncl1eAD8ewO
	 z97hAwwvzqwYHUycozbOs/6O/gO+5JrwDvYwmzJIXLbn/57Z/p9jT7t6+iLOdPwsKiEYn
	 iZ0Qaw5tw4Nhr2c7LVkBnN40GOyc96YihxlAU9Gv1t61Bx75S4MBghkya8d96b0ndMDel
	 voF/Cs+S0XY0uEp5ZuVuhJ2VsMqyCAp2iykX70sfbghaVoF1FmFhqaoli0UeMNEookg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uPT+DJpXw24gyld5kidQPbaf6CvQrgYaKy1WAhjeuJY=;
	b=0KO+aeRd58iG5tvDlLIe+ch1TDtWxldWBxCTDckLRDem2tbtcEJzKgZ1ytOejTF21MiV
	 6D7a8O50okIPJyCCqyevg7U/4VuUHkYDzJ2rpEsQuklBgmyGaHfnL5rA6awCg930FN3D+
	 tEeELCEwazAN/3nrziRqcThPGPe4DOShRLWf6qWKiO7iLOsdcjwou1Mc2ze5Exqc/Om8z
	 0tOjAuctZc/bt3vhcpxWazCLSFz6SgVxj1xGwD72yr5c8mrrgpdUcry0nAMqxlb1gg0ym
	 m0XEQqWI7WJkHufN4dd9FMLuD5Uk/TNb1+hpkDhDvg2oYcK0HYpl5EKD3SQSJARelRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgFDY0TE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D983E606A32C;
	Wed, 25 Nov 2026 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LgFDY0TE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383041F000C0;
	Wed, 25 Nov 2026 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625901;
	bh=uPT+DJpXw24gyld5kidQPbaf6CvQrgYaKy1WAhjeuJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgFDY0TEhX0W36cUuzG1gXCqQbINNCl6C9b4MVxE56AZKzNClp2y1PHN2G7Gjh6rd
	 nBcItuq1v0IK5hC2jHKH67ClpZuvUBbXWRdTVsR/6RoHaT5TqdRZY57DH8YBdQXFuq
	 FVlEKLJRldSDQYpIZWvPXq+9MHfUoSA8iR7XKw8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 668/816] wifi: mac80211: reject invalid EHT guard intervals in airtime estimates
Date: Wed, 25 Nov 2026 15:36:56 +0100
Message-ID: <20261125143904.640315826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 582edbdbc5d288bd128b54935738fe38f15c8c29 upstream.

An invalid EHT guard interval can select the wrong airtime group and, at
320 MHz, read beyond airtime_mcs_groups.

Guard interval 3 advances EHT_GROUP_IDX() into the next bandwidth group
at narrower widths. With one spatial stream and 320 MHz, it evaluates to
264, one past the 264-entry table. RX rate parsing rejects the value, but
the common TX-status validator has no EHT check and last_rate_info can
carry it to the airtime helper.

Reject values above NL80211_RATE_INFO_EHT_GI_3_2 in the helper. This also
protects exported ieee80211_calc_rx_airtime() callers that do not pass
through the TX-status validator.

LLM assistance was used to find the bug and review.

Fixes: 3702a33216e6 ("wifi: mac80211: introduce EHT rate support in AQL airtime")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142212.14523-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/airtime.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -550,6 +550,8 @@ static u32 ieee80211_get_rate_duration(s
 		group = HE_GROUP_IDX(streams, status->he_gi, bw);
 		break;
 	case RX_ENC_EHT:
+		if (status->eht.gi > NL80211_RATE_INFO_EHT_GI_3_2)
+			return 0;
 		streams = status->nss;
 		idx = status->rate_idx;
 		group = EHT_GROUP_IDX(streams, status->eht.gi, bw);


