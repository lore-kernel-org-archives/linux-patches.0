Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1574432F7;
	Thu, 30 Jul 2026 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427119; cv=none; b=k72W0OQdl1+SYeDC0GAE+gdNihWKYQtuVlMUMHYhFU//FhgbMrXqNEDvPDxQvYK4eFv5RAloi32t+8FCUFkX6xQtya4dwukI0GnLnWoWk2QPeRlFxtNsRIHlPL5Sm+InPZVn6exh3XlOKj/ECdrMihGlKc3Mb5ymwb55eIjRUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427119; c=relaxed/simple;
	bh=bBWBMff3H66dc/V46sCAct5haY+niHWEaYB9hZhgLgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNgnTIIgge0v0KTB43FphkPSJsOxDdrMLJkC+lfUjebR25OgTzXRzWNXxu297J1XLcCfDZTYAuiLzsKQKEkgtl/14yR4ukZakfDjKJVr6BYOSqD+393Z9zXJ/v3eS0o/o59SWe4MxPKbTBnE0hSinwnlMi45xWDTzfAj8ck45DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0icWRdi4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0icWRdi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047461F000E9;
	Thu, 30 Jul 2026 15:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427118;
	bh=d9VJj3nlTjiPvzfgR4DwJ4BvMIYE3NMgMNSFHBRbAcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0icWRdi4xaYiAOkg2WFsUpi7PNImywRd1J7I5rkhIzWXNVNI9sA7/eMY9O4Z9HSWg
	 IZ7FfomJLkA/nKlV47x/P3ClVndkg7wDkPXRPrKNCLC5hfOGQ7IsVVQVQwaw3QZ+W9
	 SRRHALdazftduaHPCNxHnGUawB0HREWPRqY5kzp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/484] wifi: nl80211: free RNR data on MBSSID mismatch
Date: Thu, 30 Jul 2026 16:09:15 +0200
Message-ID: <20260730141424.690099348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 07a95ec2b54774201fdf4ef7ffb0ca2ab19ed29c ]

nl80211_parse_beacon() rejects EMA RNR data when there are fewer RNR
entries than MBSSID entries.

The rejected RNR allocation has not been attached to the beacon data yet,
so free it before returning the error.

Fixes: dbbb27e183b1 ("cfg80211: support RNR for EMA AP")
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260610112208.1308-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4a490d12b504e..15c8f98bf5e235 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5651,8 +5651,10 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 			if (IS_ERR(rnr))
 				return PTR_ERR(rnr);
 
-			if (rnr && rnr->cnt < bcn->mbssid_ies->cnt)
+			if (rnr && rnr->cnt < bcn->mbssid_ies->cnt) {
+				kfree(rnr);
 				return -EINVAL;
+			}
 
 			bcn->rnr_ies = rnr;
 		}
-- 
2.53.0



