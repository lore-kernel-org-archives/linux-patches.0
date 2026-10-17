Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F30E3A7F41;
	Sat, 17 Oct 2026 16:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256359; cv=none; b=mMQULQVQGSefJomls2LKhtKXeJhVfu8aQwklbv5t+/cm+KsT7oO1lHAmOGHlenkSgowH1zb/J+I78g/yjIcHKCu2N/YwVFcVmJec7sYVl5dBE20F5JAEE2sOabC1c+dl5AY8u0QKYMIzIYvZd9T08Qn7EbHOfsSHzEfeIv7ypKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256359; c=relaxed/simple;
	bh=yWYNKEIX+vTZXZVFa9aNhaWgoccSBZrgQhYuijfgYVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnWAo7f000lqz9QcaOsuvbfe1AmYQAlwBlbCEN1gNjtXhVUj3BKY0p+mbUq85e4SMI+7QQx+SpeDBAftETOQGC+JIxLeV2ADC+4EkdZcnpw33Sjt1Vo+z3z1AcNE8yZsQ6+jj18oVXFM3n9ImeMQePaAflToGbtB3sPXS/GZ4M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1D3UNlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1D3UNlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEACC1F000C4;
	Sat, 17 Oct 2026 16:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256358;
	bh=0GnJW8tU6VYbck8Jh/Ykldp4Y0o4sZnnI3IrplUFBJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1D3UNlkVWXHNNwWSonwYYemN2otVo1h5IB11Fb8D1jajUj+/3Sr5ifCyWMZjhM0n
	 tj+xDy3XZ3xIj5ttp5ALdR2RNn8A9XJR9DwxQ/28XoetdONbUMQW6ik5hKXqSdXQug
	 OVYO1+BvgoLSrx2zX3MJuOydJTAqWHnmqgbLjVUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 0168/1674] of/overlay: put property on deadprops only after changeset add succeeds
Date: Sat, 17 Oct 2026 17:40:40 +0200
Message-ID: <20261017160435.471411229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


