Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A001A189E;
	Thu,  6 Jun 2024 14:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683190; cv=none; b=ar6EE5GPJ8dMWvaKAVDb1DjMwncM75i82517l1GPRMxo2ZbDDRtBuX2+a+a2457YUNxO9+Gbg65Lbl7wFtF+asqIWIqZlqJUNB0UdBO+z2bwITywDcK/SKn8v2XvenqzESCzMhf/2xVoyK5Lxmyl1N+2b5degQnTfSVHqgNX15U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683190; c=relaxed/simple;
	bh=vhSMXx7WUpfi7of4BSmgYMrh6Sh0zez/ygCZrHG3UWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3jl8cJZv5jl0ZXUW5v2AJdnZmVCrWFB+TmlGWIUqcU8rGn1luKhq7EnF12OAwQGmIu/3OF3ife6nsZno3dIcCT+bLkkDQvLAn5+Y1Siz+GxfWTCeUFhwFtVjBTIRiK+Usm6s7cwkV4mkl//hxzy9BnSlgR9w6FpV0IdnpXBb34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO3mVx1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO3mVx1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EFCC2BD10;
	Thu,  6 Jun 2024 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683189;
	bh=vhSMXx7WUpfi7of4BSmgYMrh6Sh0zez/ygCZrHG3UWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO3mVx1m0B+HBOISCYM4gjXFtNEGtl5XSysFyVVbjqguez+Jhi9Big9xGOSqg4ohZ
	 Yj4mfEC0FdTwzZFemJt9lBkeJvemHDlbJeB1B7JyWMnbDSyZCz/WYWxB1dixcunWvh
	 Lc1q05p45joq8r4Jx3nOGi3JRMe0K6/qdQTolo8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/744] wifi: ieee80211: fix ieee80211_mle_basic_sta_prof_size_ok()
Date: Thu,  6 Jun 2024 15:56:45 +0200
Message-ID: <20240606131736.691367351@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit c121514df0daa800cc500dc2738e0b8a1c54af98 ]

If there was a possibility of an MLE basic STA profile without
subelements, we might reject it because we account for the one
octet for sta_info_len twice (it's part of itself, and in the
fixed portion). Like in ieee80211_mle_reconf_sta_prof_size_ok,
subtract 1 to adjust that.

When reading the elements we did take this into account, and
since there are always elements, this never really mattered.

Fixes: 7b6f08771bf6 ("wifi: ieee80211: Support validating ML station profile length")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240318184907.00bb0b20ed60.I8c41dd6fc14c4b187ab901dea15ade73c79fb98c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2fa186258e359..aaaa5b90bfe25 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -5081,7 +5081,7 @@ static inline bool ieee80211_mle_basic_sta_prof_size_ok(const u8 *data,
 		info_len += 1;
 
 	return prof->sta_info_len >= info_len &&
-	       fixed + prof->sta_info_len <= len;
+	       fixed + prof->sta_info_len - 1 <= len;
 }
 
 /**
-- 
2.43.0



