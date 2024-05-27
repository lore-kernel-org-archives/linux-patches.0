Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A5B1667CE;
	Mon, 27 May 2024 19:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836552; cv=none; b=Nr5utZ23n+07zNKKjbdB1W4Elg6D4pMG6jo27AOU+azwq81d13NwYIaTdenkMUr0hDh5AnEa0z+GeIXOWhAsnXjXGRpqRTveMWhYIfmZBMTTBL5RaOvli4jKQYT4FgYSWErCn2DHNfOutkdbyRozATU5ALufHQ4kxF8Cf57JSgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836552; c=relaxed/simple;
	bh=Cs+gbqK+uNjoncZ9os07ySdSBO1AddWCNvylR4OUA00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViExwyu7aQdyEapAtW+qRSYvdTGqqCD2Eh3YSxIZxMmROP2wD4HLPwV+ctGgWMJzO3KRmPACuhddAusCbqO/3marza3wiSnlHETAdC2hEk6TqCpQryamm68o7wVKMujtTzs2+VlSp6HjK2BD2Xx/UzCHGtJN/sa10csCbSMME7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ki71Rxfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ki71Rxfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A00C2BBFC;
	Mon, 27 May 2024 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836551;
	bh=Cs+gbqK+uNjoncZ9os07ySdSBO1AddWCNvylR4OUA00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki71RxfiQVfvMwsAN+6teIzAn/tIh+40EC4Yg6y4laZjSObXFIsV9nPafFVnEmE8L
	 dP8ifsrFgvpRwq0AwsW1U3pdsfMbwrgnzhAwIJxuCkzDhGT553E7Nq/odWCiql7lKy
	 kr8cuMecOd0+393qgf87MSuSInXQ468hMilYiMdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 099/427] wifi: ieee80211: fix ieee80211_mle_basic_sta_prof_size_ok()
Date: Mon, 27 May 2024 20:52:26 +0200
Message-ID: <20240527185611.045665117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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
index 3385a2cc5b099..ac5be38d8aaf0 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -5302,7 +5302,7 @@ static inline bool ieee80211_mle_basic_sta_prof_size_ok(const u8 *data,
 		info_len += 1;
 
 	return prof->sta_info_len >= info_len &&
-	       fixed + prof->sta_info_len <= len;
+	       fixed + prof->sta_info_len - 1 <= len;
 }
 
 /**
-- 
2.43.0



