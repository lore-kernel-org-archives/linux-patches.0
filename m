Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D343F0A2;
	Thu, 30 Jul 2026 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421330; cv=none; b=PelkYxGa3CSX9vArAKm0ivxACx5z5tjtj/LKvCN0cbqEb476tvUBSsy1xVqC1Xc7n+sJf46leouy0MWpv34HJCVZoYop+C+ywDuTmZXlta95MS84dKjz1naF/FrdNxoFvcWBG7da71plxYmfkancMtfKoIyVT8XNqSRvcYe5Qho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421330; c=relaxed/simple;
	bh=Os5bhnfr4Shap/MvQ1UvJFlUPS2KuC17SGLq9Eqrf24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpxDRyrbJPp0PdZLLQzCisTPS9uz2RbqO4Lr5gEF6LvjHFpYGvK0hXApK3n66cONlLYNQuRD7FUjxxE8o+KNbUqO7m23nY72Bb49+a1epEIltf/T7I3v5re5NdNj48L4l+6hM+nPh/sd5XnX1pnbtVDhsg9BWliGoemiKXz9nYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBKMZlq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBKMZlq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5211F00A3A;
	Thu, 30 Jul 2026 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421329;
	bh=zLLjbfmQ9FRT18A+sUXXeKmaAX8HLHqTNoy4X8MPwME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBKMZlq0Td0uzoF2sJGqFIQMy3+IZ0tvSYQWj7ma+nc7J2T22JP5i5wxZRLVefEM/
	 77E0ZykZcvEuI1v3VOd9CGFy1cpSmCSJ03b3Ie66RHxOVKs0shmfPo2jUfRlhG0dty
	 FS0wzQWOLj3ZF0oykY7PUhL9LkfFfu/k6cKg8Z48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 066/744] wifi: cfg80211: reject unsupported PMSR FTM location requests
Date: Thu, 30 Jul 2026 16:05:39 +0200
Message-ID: <20260730141445.679907244@linuxfoundation.org>
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
index 4b10ce0486f4a6..9246640d2eedfd 100644
--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -109,6 +109,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI],
 				    "FTM: LCI request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.request_civicloc =
@@ -117,6 +118,7 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
 		NL_SET_ERR_MSG_ATTR(info->extack,
 				    tb[NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC],
 			    "FTM: civic location request not supported");
+		return -EOPNOTSUPP;
 	}
 
 	out->ftm.trigger_based =
-- 
2.53.0



