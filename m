Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E157461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:19:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7DFC433C8;
	Sun, 17 Sep 2023 20:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981950;
	bh=I8qwLVSvqwlIKTOAkZ/7p/v9QfiokpzvX9miXBbY2M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WPJE8ruYZUnYso1cBdrJ1ULEDn6QrF2V3owgjr5S916YVULjsVckeChwerkMZgxxR
	 7pIP47a0lKjA9q/jN8obK2FV/yRMpCCis3IkmN15TXlqZceLZj5IJoKdFEDN+EsudE
	 VgPIEx0bjLQGFIztB0cHjxGbd795QhSPs5iOh3oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/219] net: dsa: sja1105: propagate exact error code from sja1105_dynamic_config_poll_valid()
Date: Sun, 17 Sep 2023 21:15:24 +0200
Message-ID: <20230917191048.064928591@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c956798062b5a308db96e75157747291197f0378 ]

Currently, sja1105_dynamic_config_wait_complete() returns either 0 or
-ETIMEDOUT, because it just looks at the read_poll_timeout() return code.

There will be future changes which move some more checks to
sja1105_dynamic_config_poll_valid(). It is important that we propagate
their exact return code (-ENOENT, -EINVAL), because callers of
sja1105_dynamic_config_read() depend on them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 7cef293b9a63 ("net: dsa: sja1105: fix multicast forwarding working only for last added mdb entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 7729d3f8b7f50..93d47dab8d3e9 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -1211,13 +1211,14 @@ sja1105_dynamic_config_wait_complete(struct sja1105_private *priv,
 				     struct sja1105_dyn_cmd *cmd,
 				     const struct sja1105_dynamic_table_ops *ops)
 {
-	int rc;
-
-	return read_poll_timeout(sja1105_dynamic_config_poll_valid,
-				 rc, rc != -EAGAIN,
-				 SJA1105_DYNAMIC_CONFIG_SLEEP_US,
-				 SJA1105_DYNAMIC_CONFIG_TIMEOUT_US,
-				 false, priv, cmd, ops);
+	int err, rc;
+
+	err = read_poll_timeout(sja1105_dynamic_config_poll_valid,
+				rc, rc != -EAGAIN,
+				SJA1105_DYNAMIC_CONFIG_SLEEP_US,
+				SJA1105_DYNAMIC_CONFIG_TIMEOUT_US,
+				false, priv, cmd, ops);
+	return err < 0 ? err : rc;
 }
 
 /* Provides read access to the settings through the dynamic interface
-- 
2.40.1



