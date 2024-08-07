Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47FE6FE16;
	Wed,  7 Aug 2024 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723042935; cv=none; b=pPXtOLdjdKgTj+HrpeoFof4tFd9vff1IjM3QXxNLs5+TLUOq3DFo/Ijfxy8D6vU6tVmeKAXrzfcal0o7HnZkQ4FzlQ7Wru8FPlwc+dILXaogM3Bmm8r1U/ENzSfNhRK6C9b7mvld8Hak27Z+/zjHH5FGLON2wXgUC+deRNDOnyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723042935; c=relaxed/simple;
	bh=mJhLVy/37Ku5g4STZ5v5GXEjqGJZLpWrb1jCewMJmX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkSmcoEK8Y5D89An40ON6nNy+KtjFvKTxpAoq2yTE33OZej9RpG9FOv2IWy9rS1aZtjC8mSY82YZ2DS+BQhlLphPI/eCfm14Bfsorzn6OWHPVkL4vt/nsRTMdvDt3HC/XjYmU5YuqG3EK56ih0QyJL+EcWPeL0yEK+ks6QAGy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzpgJstO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzpgJstO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F4CC32781;
	Wed,  7 Aug 2024 15:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723042934;
	bh=mJhLVy/37Ku5g4STZ5v5GXEjqGJZLpWrb1jCewMJmX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzpgJstOkj7a3F9kpwJuT1YlmY5WCESfBq/BnpiQw2ADhSyVzHpa0pOHK+Rl1ccPS
	 Smp6rzSHMlumascVL8+1KetWgwdAIHjn7kDWp2CYQAhd6Mx7u8lhTpiE90Y+9sBbqt
	 dqQA1FTlnYg3P+zAFL6DwYev8sSH1tzp/cJiyn8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
	Carlos Llamas <cmllamas@google.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 029/123] wifi: cfg80211: fix reporting failed MLO links status with cfg80211_connect_done
Date: Wed,  7 Aug 2024 16:59:08 +0200
Message-ID: <20240807150021.763193794@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veerendranath Jakkam <quic_vjakkam@quicinc.com>

[ Upstream commit baeaabf970b9a90999f62ae27edf63f6cb86c023 ]

Individual MLO links connection status is not copied to
EVENT_CONNECT_RESULT data while processing the connect response
information in cfg80211_connect_done(). Due to this failed links
are wrongly indicated with success status in EVENT_CONNECT_RESULT.

To fix this, copy the individual MLO links status to the
EVENT_CONNECT_RESULT data.

Fixes: 53ad07e9823b ("wifi: cfg80211: support reporting failed links")
Signed-off-by: Veerendranath Jakkam <quic_vjakkam@quicinc.com>
Reviewed-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20240724125327.3495874-1-quic_vjakkam@quicinc.com
[commit message editorial changes]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a8ad55f11133b..1cfe673bc52f3 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1045,6 +1045,7 @@ void cfg80211_connect_done(struct net_device *dev,
 			cfg80211_hold_bss(
 				bss_from_pub(params->links[link].bss));
 		ev->cr.links[link].bss = params->links[link].bss;
+		ev->cr.links[link].status = params->links[link].status;
 
 		if (params->links[link].addr) {
 			ev->cr.links[link].addr = next;
-- 
2.43.0



