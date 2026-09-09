Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C9F58E2BC;
	Wed,  9 Sep 2026 14:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963530; cv=none; b=u7zqXM2+3dI97+fIHyZKOXlIfsQL0aO9M+SkccZaWRVHfsvdpKDeeG8Rd/naOX10/swTtd40Gfl7VKNf+j6WY1qnr22+ZNesBgNCpAgKTSWoLQSdbUnyBzRrysjXp+uOfBQNqTwmj6a8xYk/xtXPDO9s2qtSe+npPpz8/6AGr6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963530; c=relaxed/simple;
	bh=KEoVcsF5xR8BjGtKjEsXyCYfRl25eRva7JBN14xdR1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hMqbr48cb/gaJW11pRSTUArNeXy4UIgrAenmix8rsCPU1qZJ5nTgVrVbdUZqpfIX4IwYM994BuhVwgSKnIcCs6hGbHo1mqf6RhjNFsTVjjSiZZlPIj5dPkpYIsWmqbcxuEgGlDA0n8bOFjWcBU2n07cTUQ5h4+ms6xRhRox50oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGroUa7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGroUa7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EB01F00A3A;
	Wed,  9 Sep 2026 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963528;
	bh=Qma4uFQVAOhRtv26tikuatKOLXd9l1uPy+Ma/qgVt3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGroUa7O4wotUb1l2hrRI6ysUinV4/p46F106Xzm2mAW7KXNHSixq5KdV8+rABWok
	 xZgYFh0oYdn96yvMo4n2mJSe4CJ8UiydAP+KFfESTutIgp/C8XINRuXiqVfT/rwrIp
	 cIYg0sBSAv1gJ0j9O38hhY4TAmmmiUUFPoz8oaTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 109/583] nvme: add missing SRCU grace period in error path
Date: Wed,  9 Sep 2026 15:36:34 +0200
Message-ID: <20260909134241.910846630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit ef248d5de4469fb6bbaf8dbe0c4c47800080d648 upstream.

nvme_alloc_ns() error path at out_unlink_ns removes ns from the
namespace head siblings list with list_del_rcu(&ns->siblings) but
does not wait for SRCU readers before freeing the namespace struct.
Multipath code iterates the head->list under srcu_read_lock() in
nvme_find_path() and nvme_mpath_revalidate_paths(), so a concurrent
reader can still hold a reference to ns when kfree(ns) runs.

The normal removal path in nvme_ns_remove() correctly calls
synchronize_srcu(&ns->head->srcu) after list_del_rcu() to wait for
in-progress readers. Add the same grace period in the error path.

Fixes: ed754e5deeb1 ("nvme: track shared namespaces")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4218,6 +4218,9 @@ static void nvme_alloc_ns(struct nvme_ct
 			last_path = true;
 	}
 	mutex_unlock(&ctrl->subsys->lock);
+
+	/* guarantee not available in head->list */
+	synchronize_srcu(&ns->head->srcu);
 	if (last_path)
 		nvme_put_ns_head(ns->head);
 	nvme_put_ns_head(ns->head);


