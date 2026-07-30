Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CE6407CCF;
	Thu, 30 Jul 2026 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423673; cv=none; b=dPwn2uELSEuHBnH/P8QXxaZGWitkd/yc2Nnp9itUOKzXCuDanSn/8rv8PdJaTmt9qFLaamZUHe0V3Eh3kwluI8jtFPv1VInkm2dmyNvcAQ81aVGDlgNKizJUvWbC8bY2bu0Y3iId5KsYUbl2203mxkwKkzU5+ak5RvTMwA6m2Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423673; c=relaxed/simple;
	bh=bW0VA6wdV86uO99fD4O1AbHyliNcnEud/X9FAJ5o9qI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zc+IgbjEn4wwk0t/erG1B/aOJyCONt1ytH/8Z0J65llXKlBs83Lsxm/o+1danruHB7h4QyhNiIyAXZSyjM3KuCqGJ7Q6cUiE9sdCHSXWBxQElsfCPWfZ8uAR5+3sdlo/BY1TEPGQqAPa+4knjY+E0KseG3KHloyeVPrcSKVQ1Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FsiBu6VE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FsiBu6VE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41BDD1F000E9;
	Thu, 30 Jul 2026 15:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423671;
	bh=VA9WVd6jF/3fxGtkofjuVP6nGoG6dqnkm4hVcb619K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsiBu6VECVvwceAy6dG55PqW81ivjDdk80LetA28gBYUOH3zjIqtCyX7ha5JXHPte
	 YgAAD4Ukgrumt51RuxS0VdaJtOAOF5D1OlfNf3QC1lSIuFX1JVOxS7VFmmTDXm0bLM
	 z7P2Qp/JyPAcR/V4h+fkm41TxyaBn1LNl9IHCsl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/675] wifi: cfg80211: reject unsupported PMSR FTM location requests
Date: Thu, 30 Jul 2026 16:06:51 +0200
Message-ID: <20260730141446.854233854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 69ef6a7ec277f16d216be8da2b3cbe872786c999 ]

PMSR FTM location request flags are syntactically valid, but they must
be rejected when the device capability does not advertise support for
them.

Return an error immediately after rejecting unsupported LCI or civic
location request bits so the request cannot reach the driver.

Fixes: 9bb7e0f24e7e7 ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612133710.93544-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/pmsr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
index fd14a3c2eab45b..06563f60848705 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -114,6 +114,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI],
 				    "FTM: LCI request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.request_civicloc =
@@ -122,6 +123,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC],
 			    "FTM: civic location request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.trigger_based =
-- 
2.53.0



