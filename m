Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA801C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B0FC433D2;
	Wed, 28 Dec 2022 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243875;
	bh=n63OJlO5NFLIXrQiDUEKqQoYYsMh666UlNW/XdXI1lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnElnfkOItP2Q0y5cGxZRefhAAANglz8zEC072ERB/Z8S8uAbX+t3cwc5K2nxTG6p
	 p6sfnTpqLyL+O9OZEtxzrTAmnuK8CgmIosn6oPcoZaX8nECiQkXBIry9wnc7b5C0C7
	 AgUngTbDU7WPwLh6nsAxG0OUW7+15dzt2xtCKF+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0570/1146] net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path
Date: Wed, 28 Dec 2022 15:35:09 +0100
Message-Id: <20221228144345.656411570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e095493091e850d5292ad01d8fbf5cde1d89ac53 ]

If dsa_tag_8021q_setup() fails, for example due to the inability of the
device to install a VLAN, the tag_8021q context of the switch will leak.
Make sure it is freed on the error path.

Fixes: 328621f6131f ("net: dsa: tag_8021q: absorb dsa_8021q_setup into dsa_tag_8021q_{,un}register")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20221209235242.480344-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_8021q.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 34e5ec5d3e23..89371b16416e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -398,6 +398,7 @@ static void dsa_tag_8021q_teardown(struct dsa_switch *ds)
 int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 {
 	struct dsa_8021q_context *ctx;
+	int err;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
@@ -410,7 +411,15 @@ int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto)
 
 	ds->tag_8021q_ctx = ctx;
 
-	return dsa_tag_8021q_setup(ds);
+	err = dsa_tag_8021q_setup(ds);
+	if (err)
+		goto err_free;
+
+	return 0;
+
+err_free:
+	kfree(ctx);
+	return err;
 }
 EXPORT_SYMBOL_GPL(dsa_tag_8021q_register);
 
-- 
2.35.1



