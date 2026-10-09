Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4861849738E;
	Fri,  9 Oct 2026 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555514; cv=none; b=T6a2Yh+a3ift+numlFRaVl+YyYdF+mmJ/jzekPVLk17AbqR9cC8WFhOtY27Q7s0BKWyqT49t+1t9fkq+8o7yIV8KBwterrTu4rh9Qskx82QTFTu1Ocv9cY8dESKlMomKwF3Ccg/qg4KNZklTdlCTjsTSgd5rzHwSeYmW3hG6PIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555514; c=relaxed/simple;
	bh=+a7p52rBcAvcUGIX0sWCSXYwgOIWXNbb6RztReMbDaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyNt/2hnVqPctajDg9nFnlgtxTBQ+k9CuFaPEc+m9vH2gsSrWdrGZmK0wIAcgExMo7Dbh0hI2U8q1aAUZoftii8aI3sbEvUi2hAteaAvCW+f5SPUE0NJag54O0hhy7CQReQ5PTda0aXuBc+jw5c3QHYJ2jfn3Ziej1yoUkl0M7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYs/j1EZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYs/j1EZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A1C1F000FF;
	Fri,  9 Oct 2026 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555511;
	bh=QF0HvuZ1bSNFSZGjI4G7q8Ws32Sz3iOdb3XgHvdbUTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYs/j1EZTXhlDUrSaBKW9GldYeNqk77uHj2YC/9LRW0huUXHhq2yGks0t5b8HSjbz
	 kEFt/X5J+4ODLYSxnVxlLlE7ID4UZkim0G2lJh0WYlKocCnmeKM50qRxFjcyykpLSZ
	 /DiMGWfuCZlnth/e3mNIlzPHy+VxZhnuYaQ+pPiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.18 030/403] of/overlay: put property on deadprops only after changeset add succeeds
Date: Fri,  9 Oct 2026 16:06:31 +0200
Message-ID: <20261009140952.817205235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 814f2da6995772c07a7c9c2cc6028b6e3f3ecc9c upstream.

add_changeset_property() links a new property of a not-yet-live
target node into the node's deadprops list before handing it to
of_changeset_add_property(). If that fails, the error path frees the
property but leaves the freed pointer linked in deadprops, and
of_node_release() frees it a second time when the aborted overlay's
node is released.

Record the changeset entry first and link the property into deadprops
only on success. of_changeset_add_property() never looks at the
node's property lists, so the order of the two steps is otherwise
immaterial, and the error path frees a property that nothing
references.

Fixes: f96278810150 ("of: overlay: set node fields from properties when add new overlay node")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5 [Claude Code]
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://patch.msgid.link/20260831-nh-of-alias-overlay-v7-4-02754604805a@nexthop.ai
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/overlay.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/of/overlay.c
+++ b/drivers/of/overlay.c
@@ -358,12 +358,13 @@ static int add_changeset_property(struct
 		return -ENOMEM;
 
 	if (!prop) {
-		if (!target->in_livetree) {
+		ret = of_changeset_add_property(&ovcs->cset, target->np,
+						new_prop);
+		/* the detached node owns the property until the apply */
+		if (!ret && !target->in_livetree) {
 			new_prop->next = target->np->deadprops;
 			target->np->deadprops = new_prop;
 		}
-		ret = of_changeset_add_property(&ovcs->cset, target->np,
-						new_prop);
 	} else {
 		ret = of_changeset_update_property(&ovcs->cset, target->np,
 						   new_prop);


