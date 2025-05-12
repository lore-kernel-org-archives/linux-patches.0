Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616A225742B;
	Mon, 12 May 2025 17:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072746; cv=none; b=BFu2hvNCfKLd5W/dGsBXGO8vUvp7Eag/hhAwkVjg476VjYzi728iMFT+QjSf5A+fh9LPbb6D9uLiR0qo3ZCZubpquXM7AgLHEpQdMZjTjaHd4bSMnYGjMiwH251Utg7Njqk7aKOhswjwzP+7NtabOCdcsYxMHBy6hkLUC2vTK+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072746; c=relaxed/simple;
	bh=nQX9Kpoc2Uj+GGFybLVGPxDgWA559kY3w9eJkuRuXsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWo3Mr1qxv8Usjxr736Dnsf556MB5ZrqsJd5UntpSGVGXDzxZpkf+VA9HsyQeKJdNVWfOC+JXadcDl0vk4lyv/QdN5wuLkx2YCu+3Se9iyX+IEtgC6xpEAHSx9ycI0SJKdjiq7KnXPs8POE29D8J7xnqdVkkKEm55WjbdBGRmEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rTCxKhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rTCxKhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8001C4CEE7;
	Mon, 12 May 2025 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072746;
	bh=nQX9Kpoc2Uj+GGFybLVGPxDgWA559kY3w9eJkuRuXsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rTCxKhELdpCssMWi39C35xwN3HbjAIejSwi3iHz8SGUYSNMq04aw4MEnHy/Z6+fC
	 ldmS6PscYDqZo6ng31re4JRn7snJclaAgtZRHx6lPPKB34ez8Xd/eJUbKOMA8Trjcd
	 7LLuWXMWZ8bTBpVnDVvC0fGpv7xvHbdrQoQXTGPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/184] net: dsa: b53: fix learning on VLAN unaware bridges
Date: Mon, 12 May 2025 19:44:05 +0200
Message-ID: <20250512172043.528830141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 9f34ad89bcf0e6df6f8b01f1bdab211493fc66d1 ]

When VLAN filtering is off, we configure the switch to forward, but not
learn on VLAN table misses. This effectively disables learning while not
filtering.

Fix this by switching to forward and learn. Setting the learning disable
register will still control whether learning actually happens.

Fixes: dad8d7c6452b ("net: dsa: b53: Properly account for VLAN filtering")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-11-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d790fdf9fa3b4..5ac34e6f877db 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -383,7 +383,7 @@ static void b53_enable_vlan(struct b53_device *dev, int port, bool enable,
 			vc4 |= VC4_ING_VID_VIO_DROP << VC4_ING_VID_CHECK_S;
 			vc5 |= VC5_DROP_VTABLE_MISS;
 		} else {
-			vc4 |= VC4_ING_VID_VIO_FWD << VC4_ING_VID_CHECK_S;
+			vc4 |= VC4_NO_ING_VID_CHK << VC4_ING_VID_CHECK_S;
 			vc5 &= ~VC5_DROP_VTABLE_MISS;
 		}
 
-- 
2.39.5



