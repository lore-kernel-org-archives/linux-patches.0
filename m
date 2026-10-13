Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0319D4EE842;
	Tue, 13 Oct 2026 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894702; cv=none; b=S6NMfZeEzMIdwxqW8Er8xrVnqfa5RBUv00snVTYEKobCnwKyFPooim1N6gBUQa4UNMS5klwvqK6YGaij80o0o8x8BkYmZSth/PL6X5ro6cKGg21m0qgbQtUoXzprtiNkf5nMEoJrshp0Ye0y/Xb5y4Ewb+RudCVBrpJCymuAjxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894702; c=relaxed/simple;
	bh=tlYd7yucW9JfIylUUhU3QjcNSwQ3mmn3VZKZyWtTZ1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/UCvpitGjIJB+/biua/Codw/Angz7sD4d7ESVO00Tur3fhYjBxdZkGqcovQmQW2a8zyBQla85c61KkR82XzIzDU9pf8JOz4/Lu8cV3+DbOriCVhT5kU/kBV7SFhLgl6w8NNz5F7aqB1I/j94DCOYDP1GdmdqDKghhOMf44+Z5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OB5oOo5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OB5oOo5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AC01F00899;
	Tue, 13 Oct 2026 12:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894700;
	bh=r+k7x/V2xfzZgw0Lh7Y6n+Iv79noryFrDBQ5yj0QXI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OB5oOo5QrX1Dsy57scc/euPnzSY3zUI2YgZbHIjiKsa8bmt60bnz3cqjMpRC1X2D0
	 y/g5aITcM1KNydNFvC6cfV+8WR/N0GObc7D4mxh/gchpbI0oVhVt+foosvJ56atccZ
	 CoPsh1II9GIpsb99RVL4L82KyNSMsxc7D+P7W67U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.12 027/497] of/overlay: put property on deadprops only after changeset add succeeds
Date: Tue, 13 Oct 2026 13:33:14 +0200
Message-ID: <20261013112908.529703383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -353,12 +353,13 @@ static int add_changeset_property(struct
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


