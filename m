Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84CD158871;
	Tue, 23 Jul 2024 18:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759781; cv=none; b=dgYf59/JETfZPOv5KwwL/o6XTKdKwrmYDhFwiasNyTVVaof2g9zY2lTDkluJ0iuXBz6cQ+q3tur43M7YGLfzrU/QKpmrNolKTRDGRovKMXDMZIf4ULJJj1Z+bALhrHRK78FB7inn+ukjOen1WwIPQphLpxzc0F0SrxT3kwiPYzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759781; c=relaxed/simple;
	bh=WJXz2++BS//XxXl/5utTiOJJDtq+/pgeKy+8WEMHxw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPoKvJaSXikFoLutLmSb11rre7uG5Y5gwRBqTIRq5Jg04CLIivjXw2dErxpbwGmQFhrdImORIhfCfzE7umgkw6ijvgjJueZDahhJ7HhyqC/pt0Q7HvFOoiQQiL7C86cksCv3H5svDz/XnBmi3K/nKb8Qsazhuf86mZDDBEI1BTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRrkk5Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRrkk5Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD1EC4AF0A;
	Tue, 23 Jul 2024 18:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759780;
	bh=WJXz2++BS//XxXl/5utTiOJJDtq+/pgeKy+8WEMHxw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRrkk5Q1sO9FmiIBlLzu9lcawDnlX2m4N/EIdLjQe6GCZ52YKonc/GpROU5PNBfTa
	 yETYIYZhIbebGlYFa+tJsTHN7O+6eA6E+BmqdilhqYddu7tBZQMjKOOgTNUuGbKfQ7
	 f0LeNCZh5k+HIWd5r5e2csRSGw/c+sESCZA+T6I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cd6135193ba6bb9ad158@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 124/129] wifi: cfg80211: wext: set ssids=NULL for passive scans
Date: Tue, 23 Jul 2024 20:24:32 +0200
Message-ID: <20240723180409.583294127@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
@@ -3259,8 +3259,10 @@ int cfg80211_wext_siwscan(struct net_dev
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


