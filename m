Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF5042E8FF;
	Thu, 30 Jul 2026 14:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421316; cv=none; b=Dm/VSdHwjNGiI8WZuDWxEPzMacu31srIKmsUC6l2oibATAMiaEBLKOTUEL4vWS3xxXCvASPCyusYWQjXoPvf38UzGHfmWbsIRONaX70ceGlsZ7OJQzupT7NwYhfDPXpKgo80/2iOVQVV1vK/qA4V+xm+628wk+4OKQe1EPgs6ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421316; c=relaxed/simple;
	bh=McrGoI3M0AlShPpFCF63ITY8qr8G0eWZgHqjSJVlaDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRr+4cEK69DfhoIi+U7JPHP2vjzsGc6XM/JoW8nEYch+Tuyd4srF6VgTR90bBNRUUbEW0UzdcL0vmJNinoYoiNSFNU8EJ1OOwY3WoekrNDppGA9XJf/HZQe+hUUrDijGX7tEQSRxf0Qf4XhN2/chhFKWbCtUqmit267fSas3YCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq7Jdmaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq7Jdmaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3151F000E9;
	Thu, 30 Jul 2026 14:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421315;
	bh=z7DtN4bXIqUmTimczbDp/r+rZ3z1fol5SDoDJLPC/rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sq7JdmaquSz2G+q2EWzZf5w3cqAY3xVZjak+VIt8Jmfn/Gf3pwhrlD21KP2VmTKof
	 nWh5kZeRY1TTwdGz8F9KD37y/nqoQW0qt7cecDb0lv8gd1gu4aybMFRKrT8GgJPb1y
	 QOS9jx0qwF0BFbEw2c5zVLm8yI1++2hru4AiwW0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 061/744] wifi: cfg80211: derive S1G beacon TSF from S1G fields
Date: Thu, 30 Jul 2026 16:05:34 +0200
Message-ID: <20260730141445.575363751@linuxfoundation.org>
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

[ Upstream commit 4e5a4641e7b4763656336b7891d01359aaf363cd ]

cfg80211_inform_bss_frame_data() parses S1G beacons with the extension
frame layout, but still reads the TSF from the regular probe response
layout after the S1G branch. For S1G beacons that reads bytes at the
regular management-frame timestamp offset instead of the S1G timestamp.

Use the 32-bit S1G beacon timestamp and the S1G Beacon Compatibility
element's TSF completion field when informing an S1G BSS. Keep the
regular management-frame timestamp read in the non-S1G branch.

Fixes: 9eaffe5078ca ("cfg80211: convert S1G beacon to scan results")
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Tested-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Reviewed-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260611161943.91069-6-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 654f3300912dab..4b7d4c576763ba 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3312,14 +3312,15 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 		bssid = ext->u.s1g_beacon.sa;
 		capability = le16_to_cpu(compat->compat_info);
 		beacon_interval = le16_to_cpu(compat->beacon_int);
+		tsf = le32_to_cpu(ext->u.s1g_beacon.timestamp);
+		tsf |= (u64)le32_to_cpu(compat->tsf_completion) << 32;
 	} else {
 		bssid = mgmt->bssid;
 		beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 		capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
+		tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	}
 
-	tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
-
 	if (ieee80211_is_probe_resp(mgmt->frame_control))
 		ftype = CFG80211_BSS_FTYPE_PRESP;
 	else if (ext)
-- 
2.53.0



