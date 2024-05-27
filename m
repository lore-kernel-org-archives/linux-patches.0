Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801B71607AA;
	Mon, 27 May 2024 19:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837855; cv=none; b=EpRL7Ce+3o2awfvEg1LIMdEUjdnIgaB8rLhdiMndgQub/3VeDPJPPlU9qIuotAIAXChHrRVHNnGDKS46IjrJiJdFcZyvhRm5IJYN/PY+cbHyqCvAicV4WF54r9+kUGs4D9L4sxUX03Vq5LUbWmyIRgpVgCb/ps9UE2flsAKtmh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837855; c=relaxed/simple;
	bh=DqmXxHPg2vhXcZr4ol+YOuxnQmWxcuC3T58GsdwSkSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4yqGjjbxThpDSHmMwmuDC/dqyGWz9/zxSkYsPfEM5BVF8QVO6+TUObk/yXkR9lxf3WJfJXQ1XFhUbsMVNX7xF7ZNjyapZLeSQy96ZC9aFG7bRX/mUNZCy8EwuKtqt3z1UK3fAN+uEQ0hlFj91+G/IPMzDGj2+9zRBUH1M99JC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10uae6hD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10uae6hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16996C32781;
	Mon, 27 May 2024 19:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837855;
	bh=DqmXxHPg2vhXcZr4ol+YOuxnQmWxcuC3T58GsdwSkSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10uae6hDSWKtCR5+/zBg7dF19i4vmGAt7yCfYzs9w53Df1Fj7ZSpvsU+UMlZ/64po
	 /DC8zJsate5uXQzdM9fKXPn/g9GBafYryDI9nNXKfJ5qsRFqNgIZBpT92NCy7Kr3Hh
	 faXlW5jOZVFHVdAaBhO6iFtDsGdEWa9pes9wTkX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 169/493] wifi: ieee80211: fix ieee80211_mle_basic_sta_prof_size_ok()
Date: Mon, 27 May 2024 20:52:51 +0200
Message-ID: <20240527185635.890739495@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 83c4d060a5596..b69771a2e4e74 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -5145,7 +5145,7 @@ static inline bool ieee80211_mle_basic_sta_prof_size_ok(const u8 *data,
 		info_len += 1;
 
 	return prof->sta_info_len >= info_len &&
-	       fixed + prof->sta_info_len <= len;
+	       fixed + prof->sta_info_len - 1 <= len;
 }
 
 /**
-- 
2.43.0



