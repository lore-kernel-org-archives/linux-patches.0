Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065782185B1;
	Thu, 12 Dec 2024 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017840; cv=none; b=jncAvj3sUIY5y/SFmfR6lEkjAAaEV0W+a8f166wdmRKOV+kpBSVe6JJCkwF/Igo1zeNQARNXk7rZ1nbqw8j6jGy95QyqryoPKIKhQ03locWy6J0Ar2D37W6XId7tmkjL7++2BeN8Ek9hVrx3U/oKEo9xJYdsBnFTWHnjfMeMwIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017840; c=relaxed/simple;
	bh=Il58N4Q2z4nTllO6ifQc54yconmmvB1CLMrgIxGWsX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HW1liQ8wFJ9jCUqYZlDQSAHRzMEFMgoGZaNPXFZoHWedNCCCOHZBQEGHT2JSCA8CNUsiRN/ITlBQFQlMger6TyrwU6yCuAXnMHt5YIMfPtoTfQSNzAYKzyRjmftQ+9l/1pqkna24yqncpTWDy+almNybV5sBI9V2ohJVqQcpOxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rO0I/RX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rO0I/RX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DC9C4CECE;
	Thu, 12 Dec 2024 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017839;
	bh=Il58N4Q2z4nTllO6ifQc54yconmmvB1CLMrgIxGWsX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rO0I/RX6OQQmxoafmc44K07D8KFuKEyCH0CA3OSjOhGvh7tgtFnoH216yxFswTWBe
	 xBh5SmzZG4zzJfS6a5G830TWpwOFNfo781dLw0atsxKKfUl/bC6lyIpcRlDwSZjf6d
	 y88Mg0FtEXKg2G0/msB6NE7UPOjfecrySKJR/WLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/356] driver core: Add FWLINK_FLAG_IGNORE to completely ignore a fwnode link
Date: Thu, 12 Dec 2024 15:56:54 +0100
Message-ID: <20241212144248.369520124@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit b7e1241d8f77ed64404a5e4450f43a319310fc91 ]

A fwnode link between specific supplier-consumer fwnodes can be added
multiple times for multiple reasons. If that dependency doesn't exist,
deleting the fwnode link once doesn't guarantee that it won't get created
again.

So, add FWLINK_FLAG_IGNORE flag to mark a fwnode link as one that needs to
be completely ignored. Since a fwnode link's flags is an OR of all the
flags passed to all the fwnode_link_add() calls to create that specific
fwnode link, the FWLINK_FLAG_IGNORE flag is preserved and can be used to
mark a fwnode link as on that need to be completely ignored until it is
deleted.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20240305050458.1400667-3-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: bac3b10b78e5 ("driver core: fw_devlink: Stop trying to optimize cycle detection logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 9 ++++++++-
 include/linux/fwnode.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 499904f1ba6b3..3aaf234dbb088 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1025,7 +1025,8 @@ static struct fwnode_handle *fwnode_links_check_suppliers(
 		return NULL;
 
 	list_for_each_entry(link, &fwnode->suppliers, c_hook)
-		if (!(link->flags & FWLINK_FLAG_CYCLE))
+		if (!(link->flags &
+		      (FWLINK_FLAG_CYCLE | FWLINK_FLAG_IGNORE)))
 			return link->supplier;
 
 	return NULL;
@@ -1976,6 +1977,9 @@ static bool __fw_devlink_relax_cycles(struct device *con,
 	}
 
 	list_for_each_entry(link, &sup_handle->suppliers, c_hook) {
+		if (link->flags & FWLINK_FLAG_IGNORE)
+			continue;
+
 		if (__fw_devlink_relax_cycles(con, link->supplier)) {
 			__fwnode_link_cycle(link);
 			ret = true;
@@ -2054,6 +2058,9 @@ static int fw_devlink_create_devlink(struct device *con,
 	int ret = 0;
 	u32 flags;
 
+	if (link->flags & FWLINK_FLAG_IGNORE)
+		return 0;
+
 	if (con->fwnode == link->consumer)
 		flags = fw_devlink_get_flags(link->flags);
 	else
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 5700451b300fb..525cc031596b6 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -51,8 +51,10 @@ struct fwnode_handle {
  * fwnode link flags
  *
  * CYCLE:	The fwnode link is part of a cycle. Don't defer probe.
+ * IGNORE:	Completely ignore this link, even during cycle detection.
  */
 #define FWLINK_FLAG_CYCLE			BIT(0)
+#define FWLINK_FLAG_IGNORE			BIT(1)
 
 struct fwnode_link {
 	struct fwnode_handle *supplier;
-- 
2.43.0



