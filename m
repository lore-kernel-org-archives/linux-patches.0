Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B478C67;
	Wed,  7 Aug 2024 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043423; cv=none; b=UYSUvPC8DwzAWjTF6J6HGXtA4s9/TjaShhS012Sf4UO3qSzMnZfGd+UA8O35xFZc2i5jw5Zp6GzcUevtiJKrDZNCihEUcqE4N8kghiJeVbtPMy9TRxJKEb49tU3TWqwhwQeWc4l2jeDWd97+4Gq/V2cRw+Mwwt7V6b1+u2WbaRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043423; c=relaxed/simple;
	bh=8r8rGWLlIlSRPQYCE8K6ynn67ZBjpT/5P2B7X3LQ2qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFJNCPxBDn4U+yBxXyBDb8zsjpzLn+3nS3ud4iDjgYy9amA89Jk+0vzaH2YxJ501pzHR4WMbanMcHBfWkCyqBUScQJlayTDF8XktA3JBpPTnYrCcrpcsPMI8FF2E0FHlRT+TOvErPgXTQoQV3wsc0966fmYJ9CdD4GyUXCreAeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEIfCTDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEIfCTDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68381C32781;
	Wed,  7 Aug 2024 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043423;
	bh=8r8rGWLlIlSRPQYCE8K6ynn67ZBjpT/5P2B7X3LQ2qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEIfCTDkfGyHdD7Kw6I0p2pkS6Eq2Ta+QwjqsLXlggPlcPdUHTfvAMiG83gfco0Wt
	 3A+dn/aq4329kbAwBPUbiSUgkv2meLqVPKzOxuiNW5zVJayLYRC2TRVsvzxbv3Z0Zy
	 rkgYRKtkQKxjohYIFM2aQ/ZbiydW2Qs2odL1Uku4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
	Carlos Llamas <cmllamas@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/121] wifi: cfg80211: fix reporting failed MLO links status with cfg80211_connect_done
Date: Wed,  7 Aug 2024 16:59:49 +0200
Message-ID: <20240807150021.279910114@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veerendranath Jakkam <quic_vjakkam@quicinc.com>

[ Upstream commit baeaabf970b9a90999f62ae27edf63f6cb86c023 ]

Individual MLO links connection status is not copied to
EVENT_CONNECT_RESULT data while processing the connect response
information in cfg80211_connect_done(). Due to this failed links
are wrongly indicated with success status in EVENT_CONNECT_RESULT.

To fix this, copy the individual MLO links status to the
EVENT_CONNECT_RESULT data.

Fixes: 53ad07e9823b ("wifi: cfg80211: support reporting failed links")
Signed-off-by: Veerendranath Jakkam <quic_vjakkam@quicinc.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20240724125327.3495874-1-quic_vjakkam@quicinc.com
[commit message editorial changes]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 9bba233b5a6ec..72d78dbc55ffd 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1057,6 +1057,7 @@ void cfg80211_connect_done(struct net_device *dev,
 			cfg80211_hold_bss(
 				bss_from_pub(params->links[link].bss));
 		ev->cr.links[link].bss = params->links[link].bss;
+		ev->cr.links[link].status = params->links[link].status;
 
 		if (params->links[link].addr) {
 			ev->cr.links[link].addr = next;
-- 
2.43.0



