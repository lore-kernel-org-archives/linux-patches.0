Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102AE3BB9F3;
	Thu, 15 Jan 2026 16:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496367; cv=none; b=suy6yeLV7Jq7lR3PdCZ+lDz/xXYhJKN8tB/cbRVIImwIKY+TYKqvSqo7jRST4CVMopedk6LD59L3IjiULe50On672c95GQKMwBJ7itOhP8WfZmH5ch+8k/jo6jYremYx8VBIYYHc1M4Ux6xRQ8451Y7QQSMRLhK8dCSjANEwUfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496367; c=relaxed/simple;
	bh=qiUyqTqo2goJNbiMetRDVL41ONMyPVlZDMMOF8CEiX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7V45aqXVPcDJ59ahTGMrE05KNhBSLCF9a42WhZHfosKf6BHo3bpv6Dy3CfP34ncyWURXeQoLy7NoLAOIUNUzZ5ImKiOfgy235GTIYsDbn2D0lpWQihAFzHPIgQrzvLCcuSBmt0gS/71ML+3lef4XEClxC1Z2PwrgNSOdJERV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIjw4fW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIjw4fW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9DFC116D0;
	Thu, 15 Jan 2026 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496366;
	bh=qiUyqTqo2goJNbiMetRDVL41ONMyPVlZDMMOF8CEiX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIjw4fW/sbki0UTgtLuVGWeyspM61+Fej80g4iRTTRVhUiDmQcs58rsO93QpZfvab
	 gPb/OgZmdNHAJMhKeVEx5+bqT2037i1qFM4Kvp+t0ly1Vfhf5WZ4r6rEmDz/Lo1eak
	 kvsjs1Os4v4VSdKu3wsSy+/E7qcbbGoA5IJtbxYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/181] accel/amdxdna: Block running under a hypervisor
Date: Thu, 15 Jan 2026 17:48:27 +0100
Message-ID: <20260115164208.450796134@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 7bbf6d15e935abbb3d604c1fa157350e84a26f98 ]

SVA support is required, which isn't configured by hypervisor
solutions.

Closes: https://github.com/QubesOS/qubes-issues/issues/10275
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4656
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251213054513.87925-1-superm1@kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_pci.c b/drivers/accel/amdxdna/aie2_pci.c
index 43f725e1a2d76..6e07793bbeacf 100644
--- a/drivers/accel/amdxdna/aie2_pci.c
+++ b/drivers/accel/amdxdna/aie2_pci.c
@@ -17,6 +17,7 @@
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 #include <linux/xarray.h>
+#include <asm/hypervisor.h>
 
 #include "aie2_msg_priv.h"
 #include "aie2_pci.h"
@@ -486,6 +487,11 @@ static int aie2_init(struct amdxdna_dev *xdna)
 	unsigned long bars = 0;
 	int i, nvec, ret;
 
+	if (!hypervisor_is_type(X86_HYPER_NATIVE)) {
+		XDNA_ERR(xdna, "Running under hypervisor not supported");
+		return -EINVAL;
+	}
+
 	ndev = drmm_kzalloc(&xdna->ddev, sizeof(*ndev), GFP_KERNEL);
 	if (!ndev)
 		return -ENOMEM;
-- 
2.51.0



