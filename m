Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D6023752
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12814C433CC;
	Wed, 20 Sep 2023 11:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210912;
	bh=BRXYHnEbDkdEqWI5c7vypyNLzXvB9niRsRgJEFP8Ao4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n3xBhRLw+m6ymO2tRZwKsPo4otuKIP338UqCdfFL9hKygPAJ3MuBMHsW5Wwv77Ihk
	 iD8w3BP6O8C3NJDiR61fGlNAqoaJ3Izt5/K8gC1l+X6XOKrR+d7k3dVZwgkHsvMQnF
	 gwbF/JzacvWATVKPK/rrwNDl63UirjgvGF64jNHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/139] wifi: mac80211_hwsim: drop short frames
Date: Wed, 20 Sep 2023 13:29:31 +0200
Message-ID: <20230920112837.017013683@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit fba360a047d5eeeb9d4b7c3a9b1c8308980ce9a6 ]

While technically some control frames like ACK are shorter and
end after Address 1, such frames shouldn't be forwarded through
wmediumd or similar userspace, so require the full 3-address
header to avoid accessing invalid memory if shorter frames are
passed in.

Reported-by: syzbot+b2645b5bf1512b81fa22@syzkaller.appspotmail.com
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index da5c355405f68..db70cef854bc4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4906,14 +4906,15 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
 	frame_data = (void *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
 
+	if (frame_data_len < sizeof(struct ieee80211_hdr_3addr) ||
+	    frame_data_len > IEEE80211_MAX_DATA_LEN)
+		goto err;
+
 	/* Allocate new skb here */
 	skb = alloc_skb(frame_data_len, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
 
-	if (frame_data_len > IEEE80211_MAX_DATA_LEN)
-		goto err;
-
 	/* Copy the data */
 	skb_put_data(skb, frame_data, frame_data_len);
 
-- 
2.40.1



