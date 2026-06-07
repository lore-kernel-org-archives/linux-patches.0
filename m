Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DC64071DA;
	Sun,  7 Jun 2026 10:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827397; cv=none; b=Nz4/DR6kIzLwd4BEs1ul71iAH8HFK3aZfkoCdCvT2IJ5ceJ6MPPetQBv1xhdQXuTuVVIjLuxKCec7k96fZ5Xf3sL4RnMCwcVi7VDHIxuYmk46pGyf5hf8zP61ahXDHRsdlm9z3BXH0fW7EZVjEE+27C9ubhGVd0mxArJecjgVTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827397; c=relaxed/simple;
	bh=Gl7ozKcWJsld57XbyPti/xD3k4uPZ7xZWxRhCEHxCOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE605JUnB+gSQHOU6mf9GWkcetYahCzf/Y887G3sB5F5n1L2ujrumh7NlDxT8MG77uEAE+ved51PNjOvXDfHlEXNqnLe/oAHAQNAzP2W/xLsOGA3hyFzaE5AJb8S7Jbpm7FVjRZqHXvFRvgMNcm91PFZ+Vh7PcLg91Bh3aiBS6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eVItYnfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eVItYnfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685C61F00893;
	Sun,  7 Jun 2026 10:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827396;
	bh=GTj+LzNmnPdQ9MCaVDxvPn9oSe0vJAuTNhFbuFyF0o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eVItYnfcwPlSsJolbbfVEeemAWMOv/aPoMYO4yjdT/dE/fdS5KMmE9yu5i6+7tiat
	 BIItndhyFC3ny9gRNdqs4hty5jEJbNOZ6u4q9eJ2ZhhLkNhm+eHXrofGZZqLHVnjr5
	 EuxdNd1kiLAeJlw9h/7lC2mD49DsvNkeS3I+8VEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/315] ethtool: tsinfo: dont pass ERR_PTR to genlmsg_cancel on prepare failure
Date: Sun,  7 Jun 2026 11:57:37 +0200
Message-ID: <20260607095730.184765910@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

[ Upstream commit c3fc9976f686f9a95baf87db9d387f218fd65394 ]

The goto err label leads to:

	genlmsg_cancel(skb, ehdr);
	return ret;

If ethnl_tsinfo_prepare_dump() failed, it has not started a genlmsg.
There's nothing to cancel, and passing an error pointer to
genlmsg_cancel() would cause a crash.

Fixes: b9e3f7dc9ed9 ("net: ethtool: tsinfo: Enhance tsinfo to support several hwtstamp by net topology")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260526153533.2779187-8-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/tsinfo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ethtool/tsinfo.c b/net/ethtool/tsinfo.c
index fcc28fca526d82..53f12128a1a580 100644
--- a/net/ethtool/tsinfo.c
+++ b/net/ethtool/tsinfo.c
@@ -405,10 +405,8 @@ static int ethnl_tsinfo_dump_one_netdev(struct sk_buff *skb,
 			continue;
 
 		ehdr = ethnl_tsinfo_prepare_dump(skb, dev, reply_data, cb);
-		if (IS_ERR(ehdr)) {
-			ret = PTR_ERR(ehdr);
-			goto err;
-		}
+		if (IS_ERR(ehdr))
+			return PTR_ERR(ehdr);
 
 		reply_data->ts_info.phc_qualifier = ctx->pos_phcqualifier;
 		ret = ops->get_ts_info(dev, &reply_data->ts_info);
-- 
2.53.0



