Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0C365192;
	Wed, 30 Sep 2026 17:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788264; cv=none; b=sxK96sWNGAdACDR/wl2McUoLS4GtCc9CK6ioyWYyCVOTdPXvSbnJkiOfIdnrmfsLq9B7+gfA7cMXGfQTxIGm4fwtkNdOmYmqhSrd2yI8tFonl4OgiA3xSpoDpHDr60B6HIVVKowkXkfma6ba17754lSrffigJR0QfJ93sDGD6xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788264; c=relaxed/simple;
	bh=t8xmr1vyG5eYXBxDb4XJ7b/730ntHGmXFCD+ixKyYvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwNSQmU4YoarfbPVWyZAZIU3FdJbho6+VOd51+JsdPTqtwLlOwsbFVD6kpKiFf44UyxeVDBPSaE3WvV4XnILUGb/+xBnqgOCrenfJ6G52DsSTzUWllqpYlmtM8+hM+v4VM/n8381DLCkk1RfVvIOHhAh5ENhIHm/cPkAnQB+VGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXvXgH75; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXvXgH75"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01B31F000FF;
	Wed, 30 Sep 2026 17:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788263;
	bh=nRufxtjiD1b15XgxkadrEwakTiq45VT4hhldWJrNd6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXvXgH75iy76PpMil7OATz0AkATvHW6X6++bELmSuC89Ov2+bJjFRZowpfVZlsxu+
	 zmjIV7jq2xkTLsOb3r8qge/v7YJGm8Ld76qvjqIlI3Q3T7SEVg/9ZM6CrBVWFeVvQe
	 eDZBi61w8pL2enIFJY6o4ssYNOmAEUK2NR17r5Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/877] wifi: mac80211: dont offload TC setup on AP_VLAN interfaces
Date: Wed, 30 Sep 2026 17:16:12 +0200
Message-ID: <20260930152416.059543237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 362bd5bce29ed0f6fd3d39a7065567777d70606e ]

AP_VLAN interfaces are purely virtual, so don't try to offload
TC setup to drivers. We can't really use the AP interface either
since we may not know it all the time, and it could technically
even change.

Just reject the TC offload so things get done in software.

Assisted-by: LLM
Fixes: 61587f1556fe ("wifi: mac80211: add support for letting drivers register tc offload support")
Reported-by: syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f1ba58d6b55abd13239e
Link: https://patch.msgid.link/20260904165722.726cc076cecb.Iccfd88b13635425e850ce031376eb60a4ce5f4f8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7a79b40d23b36..98bc924d74fa6 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -873,6 +873,9 @@ static int ieee80211_netdev_setup_tc(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
 	return drv_net_setup_tc(local, sdata, dev, type, type_data);
 }
 
-- 
2.53.0



