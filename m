Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED09DDC5;
	Thu, 28 May 2026 20:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999993; cv=none; b=Iblstdda2w7S+2bUKlaxeEJE91zzJmZmWGTrVuUDz6OCegw7LJ3jEqQAcOr8guE2gsp+wyq0CgKFJ2AD/bvCxi2LVaGEVKDiWM+Qw/2ngXp+mdS8taYdvpC9JTiRuBK7ke3i3TxAyo1xovOZCW4yYC3UF8q4QmGGIV5XZoXn0EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999993; c=relaxed/simple;
	bh=AdYlzPA+Qwhq4GH+/rcKsAmkxwJsSiqcv1eVmXogZOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnZoirfp9PS4u1opQaTr/m7YzaH9MU1L+2qMk4CNBxuTQ7Sf0y8YprgBOXa3sCNdCZkuHyvX+K/O7eypQzIqOInqwo6+Vky4vqdPRe33z/hdKAAynuNRtjN0Np0xI7FYZF/ODGLzcNg3KIcn+qq02aCfcmxNHe/zIIkX2Iavk+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XAImBWvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XAImBWvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D271F00A3A;
	Thu, 28 May 2026 20:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999992;
	bh=eVh3FVJyVq1KengrbXNeTVjcOuhtjtjdrOWRaJ6l7UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAImBWvvAyt3vHtsmuaFH4GAXq5DXU0eZ0dJzrxQ1eFt0LQqDv/gRHNr9HauxKMOH
	 glJEoOXcYXYamBdE1c83ifmIifrHlAfLqw14j+6ftd6LPz++so+Pm8o0xwCBMnciIe
	 EsbFs35JsGJGE+Ay5R9aGlklBGZJzgIu3ifwJ84s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 263/377] net: shaper: enforce singleton NETDEV scope with id 0
Date: Thu, 28 May 2026 21:48:21 +0200
Message-ID: <20260528194645.982539983@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b62b29e6de6711f5918940aa6ff2bbab6d6af502 ]

The NETDEV scope represents a singleton root shaper in the per-device
hierarchy.  All code assumes NETDEV shapers have id 0:
net_shaper_default_parent() hardcodes parent->id = 0 when returning
the NETDEV parent for QUEUE/NODE children, and the UAPI documentation
describes NETDEV scope as "the main shaper" (singular, not plural).

Make sure we reject non-0 IDs.

Fixes: 4b623f9f0f59 ("net-shapers: implement NL get operation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-10-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index b2d85963243fa..d65008b819dc9 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -482,6 +482,12 @@ static int net_shaper_parse_handle(const struct nlattr *attr,
 	else if (handle->scope == NET_SHAPER_SCOPE_NODE)
 		id = NET_SHAPER_ID_UNSPEC;
 
+	if (id && handle->scope == NET_SHAPER_SCOPE_NETDEV) {
+		NL_SET_ERR_MSG_ATTR(info->extack, id_attr,
+				    "Netdev scope is a singleton, must use ID 0");
+		return -EINVAL;
+	}
+
 	handle->id = id;
 	return 0;
 }
-- 
2.53.0



