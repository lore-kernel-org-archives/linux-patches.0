Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202E6848D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C964C433EF;
	Fri, 10 Mar 2023 14:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458383;
	bh=aKafg4amWM7IRKIC5i95X0nN1iEROJ/OpQ8u/vqawmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCpL2LcJpqM1OiEVxP7rzOqtt9Po+Z6aRi+ICMy3hn0zt9D7PldXJY7j/6rJXjntM
	 dT4uHwTpEcUzw+/rNCJawhksAFdLkPH+zUwW4vuJ37P/sRLBNuAW69X5oZuo5U4u88
	 MkiBI2lR+j3bZ15nQQ9rlPPebnqJPVOR1L/54xdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Juergen Gross <jgross@suse.com>,
	Simon Horman <simon.horman@corigine.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 221/252] 9p/xen: fix version parsing
Date: Fri, 10 Mar 2023 14:39:51 +0100
Message-Id: <20230310133725.899039083@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juergen Gross <jgross@suse.com>

[ Upstream commit f1956f4ec15195ec60976d9b5625326285ab102e ]

When connecting the Xen 9pfs frontend to the backend, the "versions"
Xenstore entry written by the backend is parsed in a wrong way.

The "versions" entry is defined to contain the versions supported by
the backend separated by commas (e.g. "1,2"). Today only version "1"
is defined. Unfortunately the frontend doesn't look for "1" being
listed in the entry, but it is expecting the entry to have the value
"1".

This will result in failure as soon as the backend will support e.g.
versions "1" and "2".

Fix that by scanning the entry correctly.

Link: https://lkml.kernel.org/r/20230130113036.7087-2-jgross@suse.com
Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 6459c2356ff9f..c4aea1e3134c2 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -395,13 +395,19 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	int ret, i;
 	struct xenbus_transaction xbt;
 	struct xen_9pfs_front_priv *priv = NULL;
-	char *versions;
+	char *versions, *v;
 	unsigned int max_rings, max_ring_order, len = 0;
 
 	versions = xenbus_read(XBT_NIL, dev->otherend, "versions", &len);
 	if (IS_ERR(versions))
 		return PTR_ERR(versions);
-	if (strcmp(versions, "1")) {
+	for (v = versions; *v; v++) {
+		if (simple_strtoul(v, &v, 10) == 1) {
+			v = NULL;
+			break;
+		}
+	}
+	if (v) {
 		kfree(versions);
 		return -EINVAL;
 	}
-- 
2.39.2



