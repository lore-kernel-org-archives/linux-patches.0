Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FA013D896;
	Tue, 23 Jul 2024 18:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760267; cv=none; b=SLbFGB92qc9E43pQmmOBCR1KMlvgH6ftmogQ3a8b+PlLRg+PLnYuGqqrk5KoRkRtoWmZjcA5uW08enDusXcaBHpt/1JGSuU1ELjJ1erR2b4s19P4BC8Nd0DwlEkRGcYtCyNbqjmkEhtjivw7bOHdsjXe3kLPnIOY7i3DNGvtLuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760267; c=relaxed/simple;
	bh=OEEDX6ZbzAR+63ObDMG357rn03HOIBqrGIQnCLXa8H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIdnaxqcvr6m+FQuMuAm/mqAF9G7zZ2e5/E0BwCC5KFa1+6rtaqv+aze1RaaBl5ooRGi5sgl/OfMB9vaUSPr1RhEqqhV809xYTN6fgVa8Ap8B7pvlLxXrGMAfcmtNVUXYBmvHGZVhA0fNp3u6LmpJ8cgAywHsCsgjhPd8FfzUs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxH0Lv0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxH0Lv0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93678C4AF0B;
	Tue, 23 Jul 2024 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760267;
	bh=OEEDX6ZbzAR+63ObDMG357rn03HOIBqrGIQnCLXa8H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxH0Lv0K/miOiuR8Sm7NuYLIKksNlUnCHRxR+9rjKt6haADukEEWD7GikgsyFXJg5
	 wxDsXoOXkTBeZiUGzZtlTMHVl7/Br7XcaaX+7nEDPJLm1cWtWfJugdDCH6iLMFHwsp
	 jE7MhymIxnBMYh9ENYsjDa9BES8hf732ii8KzoRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cd6135193ba6bb9ad158@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.9 158/163] wifi: cfg80211: wext: set ssids=NULL for passive scans
Date: Tue, 23 Jul 2024 20:24:47 +0200
Message-ID: <20240723180149.577078987@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 0941772342d59e48733131ac3a202fa1a4d832e9 upstream.

In nl80211, we always set the ssids of a scan request to
NULL when n_ssids==0 (passive scan). Drivers have relied
on this behaviour in the past, so we fixed it in 6 GHz
scan requests as well, and added a warning so we'd have
assurance the API would always be called that way.

syzbot found that wext doesn't ensure that, so we reach
the check and trigger the warning. Fix the wext code to
set the ssids pointer to NULL when there are none.

Reported-by: syzbot+cd6135193ba6bb9ad158@syzkaller.appspotmail.com
Fixes: f7a8b10bfd61 ("wifi: cfg80211: fix 6 GHz scan request building")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3492,8 +3492,10 @@ int cfg80211_wext_siwscan(struct net_dev
 			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
 			creq->ssids[0].ssid_len = wreq->essid_len;
 		}
-		if (wreq->scan_type == IW_SCAN_TYPE_PASSIVE)
+		if (wreq->scan_type == IW_SCAN_TYPE_PASSIVE) {
+			creq->ssids = NULL;
 			creq->n_ssids = 0;
+		}
 	}
 
 	for (i = 0; i < NUM_NL80211_BANDS; i++)


