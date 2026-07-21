Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6D246EF88;
	Tue, 21 Jul 2026 19:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662825; cv=none; b=iZLnQXwLQ2WhnNR/vKjnpdtRE7nLE5tSILMSpIZF2eIdQvibJ2CsX9nkl7ikdCzkJfhLN+J/uAOWZekvOq0QZiGbXNmBFjgBJwIepBoxpsfuGZFYMOqnMqXGzCLvNqWBjEkVR+fn8ddc7y3czYpRkCzMOuc4eFG2cGeczr/FOkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662825; c=relaxed/simple;
	bh=Tvp5n1ipOJqk4r2z1k/Rh92gFTwHxKUK+I27+5GtUZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTlgTuTYYAh24UBs8Ajkz+RfhPyAR/sWAEQtc/kt7KAe6eU1AR+5Y1h0xByyKlsPEZ1jOKA/1lPjt+HkKfjvZLrKjD4TjfyvamrVhnKRe8agfPq/FsheB8OYbw/kANbNqZlpBmd6iVxESxnSBQ9BvjyD5xQDdpKvD/CvLwP/YA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbapzoG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbapzoG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B44F1F00A3A;
	Tue, 21 Jul 2026 19:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662824;
	bh=lhYsGTw2L8PJRzv/87EoFdUSg69tq4QqELf9XY9c78k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbapzoG2gGlmnvUQMsIvfI69odVyMN68rZObqgTkqxCNznAtLVaZY84YwUYg7egLm
	 uFE2t3DxoziqRhuhDVcs4Lt/TXi4IIzcQ/5k8wAV7ojGQokhp2TKfaEwlYwOjWCNH7
	 AduxgpnBKE3Gb/pLYVYKeUqRcKSpuX1gJlv9IA14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robertus Diawan Chris <robertusdchris@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0590/1276] mac802154: Prevent overwrite return code in mac802154_perform_association()
Date: Tue, 21 Jul 2026 17:17:13 +0200
Message-ID: <20260721152459.317412916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Robertus Diawan Chris <robertusdchris@gmail.com>

[ Upstream commit 649147cb3f8b3c0c9aeba5d89d69a6ef221c12c2 ]

When assoc_status not equal to IEEE802154_ASSOCIATION_SUCCESSFUL, the
return value assigned to either "-ERANGE" or "-EPERM" but this return
value will be overwritten to 0 after exiting the conditional scope.
So, jump to clear_assoc label to preserve the return value when
assoc_status not equal to IEEE802154_ASSOCIATION_SUCCESSFUL.

This is reported by Coverity Scan as "Unused value".

Fixes: fefd19807fe9 ("mac802154: Handle associating")
Signed-off-by: Robertus Diawan Chris <robertusdchris@gmail.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/20260602054133.470293-1-robertusdchris@gmail.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac802154/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index a6dab3cc3ad858..0eef3b4f5b9b39 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -594,6 +594,7 @@ int mac802154_perform_association(struct ieee802154_sub_if_data *sdata,
 			 "Negative ASSOC RESP received from %8phC: %s\n", &ceaddr,
 			 local->assoc_status == IEEE802154_PAN_AT_CAPACITY ?
 			 "PAN at capacity" : "access denied");
+		goto clear_assoc;
 	}
 
 	ret = 0;
-- 
2.53.0



