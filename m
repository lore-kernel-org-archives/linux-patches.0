Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE601D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D140BC433C7;
	Wed,  4 Oct 2023 18:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442877;
	bh=rmCea8LePp2aflmpsGKWa8jlWYDgfXdrpf9x9PaICUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ln27Rs0L+pRQdzXyckkdPxPo1DjBu47IIuKOCJTZ+BsZ2SjNkFTM7v6OSLly/9AHG
	 TsbCmb6BhMMyscaTJc8CYDM7+krotCrPwqjVHbCkNUbMpwr/xQNiqNOf9xG9TenjaC
	 Hw9dUaJjDQotbTb5Wya0qUWI2avdLnrW4rcqzYAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johnathan Mantey <johnathanx.mantey@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/183] ncsi: Propagate carrier gain/loss events to the NCSI controller
Date: Wed,  4 Oct 2023 19:56:11 +0200
Message-ID: <20231004175209.842896994@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Johnathan Mantey <johnathanx.mantey@intel.com>

[ Upstream commit 3780bb29311eccb7a1c9641032a112eed237f7e3 ]

Report the carrier/no-carrier state for the network interface
shared between the BMC and the passthrough channel. Without this
functionality the BMC is unable to reconfigure the NIC in the event
of a re-cabling to a different subnet.

Signed-off-by: Johnathan Mantey <johnathanx.mantey@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-aen.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ncsi/ncsi-aen.c b/net/ncsi/ncsi-aen.c
index 62fb1031763d1..f8854bff286cb 100644
--- a/net/ncsi/ncsi-aen.c
+++ b/net/ncsi/ncsi-aen.c
@@ -89,6 +89,11 @@ static int ncsi_aen_handler_lsc(struct ncsi_dev_priv *ndp,
 	if ((had_link == has_link) || chained)
 		return 0;
 
+	if (had_link)
+		netif_carrier_off(ndp->ndev.dev);
+	else
+		netif_carrier_on(ndp->ndev.dev);
+
 	if (!ndp->multi_package && !nc->package->multi_channel) {
 		if (had_link) {
 			ndp->flags |= NCSI_DEV_RESHUFFLE;
-- 
2.40.1



