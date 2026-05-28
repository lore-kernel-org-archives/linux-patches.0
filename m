Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF061DE4E0;
	Thu, 28 May 2026 20:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001070; cv=none; b=QmG5rSE6EB931IvFkkFqn1/DUO1FLs96YGmKY3lSgt3hkjlfLSNl8b03vfgnVhCuZiMxGX10MWiW46vUtRn7w9DDsBRatNQbPJ8/gzdHbgPnIp4U5fIxuV69abn/Sm92Qx2oRSq5qgqz79V7/e2/qIbaV8G1SW2nlu8G+8W2G68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001070; c=relaxed/simple;
	bh=agxwLD7VnZkdDMrfQKbvZIqxQn3yEYqOOrgRQn5HU0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxUL6uI1VqmRIwWHMQOokvx6NkWqyLwr3wVD0aMGehCO8x4vXkzQlS4BzPk//CDSKcghhA3CnpUsIzlJxYzcr2L40asWF7GSsWrOefVZft92wcc03NR38RzdUnFyxFmFnwTxHH9MFLDur0qRWfOdHLUHShpWkHBNzwPXLli8Pk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5VjdqPP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5VjdqPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D341F000E9;
	Thu, 28 May 2026 20:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001069;
	bh=Xpyj+5/XTQXDNlS58ZVQ5JzCL7qoGyq7N28aDw36ir0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D5VjdqPPoWLbiakLJxy4dQjkdW+GZ7A+w6hDD+F+UlJMtLcqutuB6NGzC+pZ/90jn
	 jZIBNAk0Qa48lBWbJ5xauXKKmncb4RqvSctX/PbwGglSoG1t8NB477vNtBi0zc26z/
	 vbfrrBC4Y4qVQDg8Mw/Q5sQajpKatEB2neUjChAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 269/272] pds_core: ensure null-termination for firmware version strings
Date: Thu, 28 May 2026 21:50:43 +0200
Message-ID: <20260528194636.607954777@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 3d4432d34c1992701289cbe12df9fd024f315998 ]

The driver passes fw_version directly to devlink_info_version_stored_put()
without ensuring null-termination. While current firmware null-terminates
these strings, the driver should not rely on this behavior. Add explicit
null-termination to prevent potential issues if firmware behavior changes.

Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260520205842.1486718-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index d8dc39da4161f..621791a3c543b 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -121,12 +121,14 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
 	listlen = min(fw_list.num_fw_slots, ARRAY_SIZE(fw_list.fw_names));
 	for (i = 0; i < listlen; i++) {
+		char *fw_ver = fw_list.fw_names[i].fw_version;
+
 		if (i < ARRAY_SIZE(fw_slotnames))
 			strscpy(buf, fw_slotnames[i], sizeof(buf));
 		else
 			snprintf(buf, sizeof(buf), "fw.slot_%d", i);
-		err = devlink_info_version_stored_put(req, buf,
-						      fw_list.fw_names[i].fw_version);
+		fw_ver[sizeof(fw_list.fw_names[i].fw_version) - 1] = '\0';
+		err = devlink_info_version_stored_put(req, buf, fw_ver);
 		if (err)
 			return err;
 	}
-- 
2.53.0



