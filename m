Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2141F46D2CC;
	Fri,  7 Aug 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117084; cv=none; b=Z+4DjUyBCm4IZLoX2Thlm1wxqnD+GV1C9sIiOLK77EAFDIsgwNl4KrO0SIhq6Q/9FRpBD6wgDHrHT03PXCXMNNsTq79m6kkGvORyaou9Uatf6tm+HmyBPspVY7GqICqYb1fySPcF/MjRWXs3YVCQQTQTj5VRrPfxo0xrx6GlZYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117084; c=relaxed/simple;
	bh=DtjAcwo0GJBTKcGnd9faPTSdpp228BdVFM3LzTb9HXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCeYOrhpftK9pyVsYYOnWn2uQjAorM4/G/fyLzc7Oxf0DzSPk/0Y6TlEeBSGoBcJsr+gI7lCvtEThTUvJM0Gh7aEvJcWWKM4d6FT0XXCq/2J39Igwwmg3U6YidpVw31PgtDuRTvOjXmut7gadri+DPqXceJ1ofqujc5e68qSRuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDGePB96; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDGePB96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BD71F000E9;
	Fri,  7 Aug 2026 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117083;
	bh=NhDP3G6iDJUALJavz19k6A4HbR8U5D+8nr2yQwraCOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDGePB96Pu7uNcw/WEZ0XMp3T6bP4Ofxk97n1ovYEWSF3PcvtHvIGe4YywkMtIl+F
	 iLOGXEO4RUka8/jr8XtPYHppbvAZFheuwydlbCPsnUszEthqwR3rv3aJEJHXPqeWLr
	 AhVhJEI28zpWOXhNFhXFF8ktyjHPA2Gea9GX8RXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>,
	"Anirudh Rayabharam (Microsoft)" <anirudh@anirudhrb.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 193/438] mshv: Fix missing error code on VP allocation failure
Date: Fri,  7 Aug 2026 16:36:29 +0200
Message-ID: <20260807143432.142126216@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>

[ Upstream commit f546be6a19d24d02be576d8617cb26c7acb61594 ]

In mshv_partition_ioctl_create_vp(), when kzalloc for the VP struct
fails, the code jumps to the cleanup path without setting ret. At that
point ret is 0 from the preceding successful mshv_vp_stats_map() call,
so the function returns success to userspace despite having failed to
create the VP. No fd is installed and no VP is registered in pt_vp_array,
but userspace has no way to know the operation failed.

Set ret to -ENOMEM before jumping to the cleanup path.

Fixes: 621191d709b14 ("Drivers: hv: Introduce mshv_root module to expose /dev/mshv to VMMs")
Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Reviewed-by: Anirudh Rayabharam (Microsoft) <anirudh@anirudhrb.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/mshv_root_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/mshv_root_main.c b/drivers/hv/mshv_root_main.c
index 146726cc4e9ba..644f9b10cbba4 100644
--- a/drivers/hv/mshv_root_main.c
+++ b/drivers/hv/mshv_root_main.c
@@ -1117,8 +1117,10 @@ mshv_partition_ioctl_create_vp(struct mshv_partition *partition,
 		goto unmap_ghcb_page;
 
 	vp = kzalloc_obj(*vp);
-	if (!vp)
+	if (!vp) {
+		ret = -ENOMEM;
 		goto unmap_stats_pages;
+	}
 
 	vp->vp_partition = mshv_partition_get(partition);
 	if (!vp->vp_partition) {
-- 
2.53.0



