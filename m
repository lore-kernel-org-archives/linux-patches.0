Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8112D77EA;
	Wed, 25 Feb 2026 06:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002620; cv=none; b=gGMkqNd3k6U1NPFB/45Q8AmtkZc5GbPo0RVCJUxIZiPZ8WcxfKnFASFdBinZHWCNIckR8qfIIeM06LwvtJQs5ZHgtDoZpiyr5oBFzV4PmYre/Rpkdtds+gUMlG0YyB8P54yUsbzYjQpj1GUunD17OIemEdz+47BIorkPkc2mYO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002620; c=relaxed/simple;
	bh=ipeslegiRgRaDURMSwshO7i4lfiJEMa0YW7kQ1mG3Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akTlS7iQ3fqZD5uRG3JahAo3JnfJmMAqMawVGOJ6dr6wNKMbK9Dq0mwz21VzJeyhN9rXgBTjF9uRTJ3oheb6Qzu9VR5aadS9M7/e4eC3tWnIKHwGS98e6C/Fg4FmhYyJl8fDrb891oNxKo+uLwKv//LoM5cQ3aIg7rwYa6gUohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f0b6nOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f0b6nOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFA4C116D0;
	Wed, 25 Feb 2026 06:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002619;
	bh=ipeslegiRgRaDURMSwshO7i4lfiJEMa0YW7kQ1mG3Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0f0b6nOL3qWfFcGqdxASLj9mEGA/PqNy8eUV4JBU04hGb0SbqPPUZ0umMqhD/5+CM
	 A0utJz9p2ykMcqRshYVNEHTW8AzvmhWcCBKFPhkxKsEzJi7hE2Afv8+jzbx4PL/tG0
	 k81yweoCjKDAlDxvkEn1JusZYUHYA2xTteqEd6+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Joyner <eric.joyner@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 333/641] ionic: Rate limit unknown xcvr type messages
Date: Tue, 24 Feb 2026 17:20:59 -0800
Message-ID: <20260225012356.751452215@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Eric Joyner <eric.joyner@amd.com>

[ Upstream commit cdb1634de3bf197c0d86487d1fb84c128a79cc7c ]

Running ethtool repeatedly with a transceiver unknown to the driver or
firmware will cause the driver to spam the kernel logs with "unknown
xcvr type" messages which can distract from real issues; and this isn't
interesting information outside of debugging. Fix this by rate limiting
the output so that there are still notifications but not so many that
they flood the log.

Using dev_dbg_once() would reduce the number of messages further, but
this would miss the case where a different unknown transceiver type is
plugged in, and its status is requested.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Link: https://patch.msgid.link/20260206224651.1491-1-eric.joyner@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 2d9efadb5d2ae..347b0aff100b9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -263,9 +263,10 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
 		/* This means there's no module plugged in */
 		break;
 	default:
-		dev_info(lif->ionic->dev, "unknown xcvr type pid=%d / 0x%x\n",
-			 idev->port_info->status.xcvr.pid,
-			 idev->port_info->status.xcvr.pid);
+		dev_dbg_ratelimited(lif->ionic->dev,
+				    "unknown xcvr type pid=%d / 0x%x\n",
+				    idev->port_info->status.xcvr.pid,
+				    idev->port_info->status.xcvr.pid);
 		break;
 	}
 
-- 
2.51.0



