Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4FD611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA27C433D2;
	Sun, 28 May 2023 19:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301458;
	bh=bnMyapBWPgckjN1DKJMsqaEcgib2kKhWz1y+df38jZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCce0uuyjNUHu9//FOqZNYGvVeoYYh9NY6tTxxoIX7dTGgw+IH7pOJqi6zY4Vjzz2
	 HiaH5oDSUYbYwzD9Fd2oxH3UWv56Y421MpvAc9D2o8MBhQlAbSQm4jhRclQEWDdOR/
	 bk7iEOFmZ03Jpyf1LG4gIhUdb5jQkrXqT8HOphwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Frank Wang <frank.wang@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 038/132] usb: typec: tcpm: fix multiple times discover svids error
Date: Sun, 28 May 2023 20:09:37 +0100
Message-Id: <20230528190834.752893747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Wang <frank.wang@rock-chips.com>

[ Upstream commit dac3b192107b978198e89ec0f77375738352e0c8 ]

PD3.0 Spec 6.4.4.3.2 say that only Responder supports 12 or more SVIDs,
the Discover SVIDs Command Shall be executed multiple times until a
Discover SVIDs VDO is returned ending either with a SVID value of
0x0000 in the last part of the last VDO or with a VDO containing two
SVIDs with values of 0x0000.

In the current implementation, if the last VDO does not find that the
Discover SVIDs Command would be executed multiple times even if the
Responder SVIDs are less than 12, and we found some odd dockers just
meet this case. So fix it.

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Frank Wang <frank.wang@rock-chips.com>
Link: https://lore.kernel.org/r/20230316081149.24519-1-frank.wang@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm.c b/drivers/usb/typec/tcpm.c
index e4308f97d9739..0fdae44c9b8cf 100644
--- a/drivers/usb/typec/tcpm.c
+++ b/drivers/usb/typec/tcpm.c
@@ -1006,7 +1006,21 @@ static bool svdm_consume_svids(struct tcpm_port *port, const __le32 *payload,
 		pmdata->svids[pmdata->nsvids++] = svid;
 		tcpm_log(port, "SVID %d: 0x%x", pmdata->nsvids, svid);
 	}
-	return true;
+
+	/*
+	 * PD3.0 Spec 6.4.4.3.2: The SVIDs are returned 2 per VDO (see Table
+	 * 6-43), and can be returned maximum 6 VDOs per response (see Figure
+	 * 6-19). If the Respondersupports 12 or more SVID then the Discover
+	 * SVIDs Command Shall be executed multiple times until a Discover
+	 * SVIDs VDO is returned ending either with a SVID value of 0x0000 in
+	 * the last part of the last VDO or with a VDO containing two SVIDs
+	 * with values of 0x0000.
+	 *
+	 * However, some odd dockers support SVIDs less than 12 but without
+	 * 0x0000 in the last VDO, so we need to break the Discover SVIDs
+	 * request and return false here.
+	 */
+	return cnt == 7;
 abort:
 	tcpm_log(port, "SVID_DISCOVERY_MAX(%d) too low!", SVID_DISCOVERY_MAX);
 	return false;
-- 
2.39.2



