Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93A77638;
	Wed, 21 Feb 2024 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521501; cv=none; b=kiEFUdxO/47Alk+MS3codvcbvEAlIVObjBGClSDMLZmq1Kuc7JDXRBbTxBklswPFgAGhmoPajrmFH10VgQz6czQwTLDB3s0JWLhZtP1ULb/9qemPcij2JE5xez+ouudYmRdHD8wXwnX7woL+rzIpPl2/U90ucZlkAofZMt2LVtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521501; c=relaxed/simple;
	bh=U3CL0RSIEGwHIU3i05GEmSbSvPPUgQwg0OG3khopTtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6Rg8RN5SdLVpJhg0gNHmmyVOdITbZwONZHhxbTGU66GV2DqwM36sKMMubTq1VXPQGz9xnlNuiiR3aep8FTyxOdzJABtZwDISkW44+KVg37bH22Ronqm3hB1UU6tsj0Gn5LDQ6PbUUMZ+zX/0uah5cerZlMXcdJZ2w3GTG1YFEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5qr+U7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5qr+U7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A059C433C7;
	Wed, 21 Feb 2024 13:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521500;
	bh=U3CL0RSIEGwHIU3i05GEmSbSvPPUgQwg0OG3khopTtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o5qr+U7Pyzs8A/GOrgjqwJ3DUq3zAa1IT/2U//RnbT5//jbUxUpvZ6Phs5TkENinp
	 cMix/al7n5mhzWctcYJuLcgG77/VaxXqykhxDDxTFEoZhp0RiT+HWfyI2VYDU8QOBM
	 U2KpymTx/kkP2eSlJbL2v9O+uxwae++zYyfjT7Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Subject: [PATCH 4.19 129/202] wifi: cfg80211: fix RCU dereference in __cfg80211_bss_update
Date: Wed, 21 Feb 2024 14:07:10 +0100
Message-ID: <20240221125935.876171402@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 1184950e341c11b6f82bc5b59564411d9537ab27 ]

Replace rcu_dereference() with rcu_access_pointer() since we hold
the lock here (and aren't in an RCU critical section).

Fixes: 32af9a9e1069 ("wifi: cfg80211: free beacon_ies when overridden from hidden BSS")
Reported-and-tested-by: syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://msgid.link/tencent_BF8F0DF0258C8DBF124CDDE4DD8D992DCF07@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7f1a4ba975dd..dacb9ceee3ef 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1019,7 +1019,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					 &hidden->hidden_list);
 				hidden->refcount++;
 
-				ies = (void *)rcu_dereference(new->pub.beacon_ies);
+				ies = (void *)rcu_access_pointer(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
 				if (ies)
-- 
2.43.0



