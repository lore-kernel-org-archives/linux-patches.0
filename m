Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1748833F5B4;
	Thu, 28 May 2026 20:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999225; cv=none; b=n+L9Lvetqgj5EsJYXnMEXEe7lMw48LKqM1vwJHGq1nThxt4NncUE5yBLXjTWr5u6TPoDDsJh81Kp4u+SjsU0omt3VQttpgOcCOUlyQ2Nyvla4qo0HOjG+6rjN1SiqDl80NpTWADi1jg5iy2Fuxhxncq9jTyIseWzX5Xbab65zwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999225; c=relaxed/simple;
	bh=Orzz6b7eS00eBIP9RF32tZIDk5qPP8DWyQcvTgHD57Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2eFWEIuWowa6OLX3OAv6QIbnn1gkDnWUXWaU+O3hP0ZRXKtosokIv2fbTS6aYy2pz8ORtCUXWcH9JwO5YvBAsU3s+9TzwUskjYB/NjP5530/BZ7ZbAEFrbYlZGcrYvjMi3WOdIdhcNcn6ghqmA4h4dWyIdGaB3a5ikO7zYJ/jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZRmwTa1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZRmwTa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D941F000E9;
	Thu, 28 May 2026 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999224;
	bh=5+7m1qNI/AHweW2JOs778zlXxeq4knPHX2Y5PWbBXZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZRmwTa1Tchp0tuEdWDWgSMGJwouvKCePPLhbYENhMJ5UuuleCHZvdpdVMuO2ytgN
	 tK0ct0PffDaqa2km5HDn4u4jfe/3mwnJZfvgrXIfov94ra6pKjPGyuXVQMjrEjL7mE
	 sycG/GnMKMOW8vmdECYH93JQ8WNHXwp4ZnM+Lt08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 452/461] pds_core: ensure null-termination for firmware version strings
Date: Thu, 28 May 2026 21:49:41 +0200
Message-ID: <20260528194700.624002162@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index b576be626a294..3f0e56b951bf0 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -122,12 +122,14 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
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



