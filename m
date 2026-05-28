Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD7334389C;
	Thu, 28 May 2026 20:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001625; cv=none; b=NZJZMfdsbHzMtxWNMiXt7nUSrNg3m86Bfwck0hujh7/ID8HfWNL8nJKZNBoO/LwF9dq4Tpklsn2AJQ9zzVvpPCOgcXGE/ZNoSPZYFrr5slor+C7uQt1pPCWezXdGW2B+sEu9saGeO2Uwy4m54ShYyBcthydYaU6DKophsLKK+10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001625; c=relaxed/simple;
	bh=QxWhn/CuaLO8EkOHyCbxAGpNfuKMnuo0o+1HWeDH5Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxUePJzlry8yU1D03bIPsDSLiYj4Eby6vryDwJVGEDnFqsPcmhdIiacMbR1SaApNW2KE2QclRpvY7lafOgm5zW6w53lCpJxq9lrrOuL/BRn9LrucKcKhTVMiFl9mYS5dRXB5YyDOK8HpmKR+N1krRpUtWimXCJvQhLhKl4OBNwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMwGvVfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMwGvVfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FD31F000E9;
	Thu, 28 May 2026 20:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001624;
	bh=Gkbozzp5LZHQedToxpX6M9CRunlyjkSb9A2YdNBX8HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMwGvVfJVMaPM7GUt0jK2zMnw5MafcPqGm+tSPNSF2vXDY8K2bMu7nIXQ/7E4FOnZ
	 O1jCZlDvzzPE/SoYITa3UpSJnSbtQWX+9M1O3abkBPrArZg/73t9KVANsdg7eaYWx1
	 oUMszErh5B4eVvHT9JGmR77T5FEePzJVZI4w8USg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/186] pds_core: ensure null-termination for firmware version strings
Date: Thu, 28 May 2026 21:51:04 +0200
Message-ID: <20260528194933.959172575@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index dfbd6d39136f4..3144bad75a4df 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -120,12 +120,14 @@ int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 
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



