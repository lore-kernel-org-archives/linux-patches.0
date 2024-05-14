Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4AB7F7C7;
	Tue, 14 May 2024 11:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687514; cv=none; b=mdPps/sDWHdl7p79zEVNHB4hlaB6pOe6/kriNv4ErwIIaagP7d0ODranhn0qrv1lTMHRaDQp2lcDeDVDqW8FmYKqIrGo1HDNSVtS9yAvMzZWUtuzHPE9I70wA/5EnfMeZglS4WwXnJ4yB4B9/EB+zAVCuAC3+91aWFk2YJCj9YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687514; c=relaxed/simple;
	bh=xmTKb8iaRFT202y7ts24i2z3WCcaFk4EwJ1Q1uu83zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzXp0bTUl0WP5TsxMQoH/SeXaS2coSX+nbOalV/1PYDZ15RDkdktelpM83jhZFzQLri7W4hUJVdJdNlcPUk0aIIPpU7oPwKFXJ3aJ777eQBbvn9DgRWRY08GP4cqaCHjLL+yrEMfbP7shHWdUodaD8DiHb04Lkx2SAibl6uOBj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HTLPve0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HTLPve0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5FCC2BD10;
	Tue, 14 May 2024 11:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687514;
	bh=xmTKb8iaRFT202y7ts24i2z3WCcaFk4EwJ1Q1uu83zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HTLPve0Hw0jdIpMfVKAC2ubMHK7Qvsm5IoFS2OmhtngQnmAaA3k+TwHUX7Yc4rp+
	 PzjU3uRoqivmCcjittyxXHqkxAMkt4SlX7FNigMA+PQoBx5BoJIH++bWF6Upqk1PVC
	 zgEQY5SbB4I8vVkp28h1dIdMyt9XjZDP5bkpPiTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/168] wifi: nl80211: dont free NULL coalescing rule
Date: Tue, 14 May 2024 12:18:21 +0200
Message-ID: <20240514101006.814122927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 801ea33ae82d6a9d954074fbcf8ea9d18f1543a7 ]

If the parsing fails, we can dereference a NULL pointer here.

Cc: stable@vger.kernel.org
Fixes: be29b99a9b51 ("cfg80211/nl80211: Add packet coalesce support")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240418105220.b328f80406e7.Id75d961050deb05b3e4e354e024866f350c68103@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 99149b10f86f6..d758ec5655892 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12890,6 +12890,8 @@ static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
 error:
 	for (i = 0; i < new_coalesce.n_rules; i++) {
 		tmp_rule = &new_coalesce.rules[i];
+		if (!tmp_rule)
+			continue;
 		for (j = 0; j < tmp_rule->n_patterns; j++)
 			kfree(tmp_rule->patterns[j].mask);
 		kfree(tmp_rule->patterns);
-- 
2.43.0



