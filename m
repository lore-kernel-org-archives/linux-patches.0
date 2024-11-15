Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF81C18734F;
	Fri, 15 Nov 2024 06:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653242; cv=none; b=PRVNjzp5pEc0Xr6IHRLAAbollJzirVQY/mC0CCmemkuDnti+/PbDd4wlnSMoL59vb5i3k2g+hspXq3fm+924MroI2cjmqA940Q6wwRlyJjetVWihAzzcrAblEYQnBXHMpYXzAS0cjIvqsqRrJrsmSJg3BaGmGZUzCOSxwfc+m+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653242; c=relaxed/simple;
	bh=uwq+ngDo51od4NGZ39H1qe4b5WPhaO6oGiFe64PWCE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmv4596rcLZ70+RRSpgQaywn0h1L8KtVO8JQa8EyMeP1yGsBLv5ACk91jhHLwwRNx2nXDJN4mAKM5hSV3+Va+jpadGSDTofAS6HoK0ehKARr6RqR+l67bvKAlVHRmOlmz9sX+l5ZtHGlHPLty4asF6HQuPpqLdqulovsi/uvNn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvbHG3M9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvbHG3M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52766C4CECF;
	Fri, 15 Nov 2024 06:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653242;
	bh=uwq+ngDo51od4NGZ39H1qe4b5WPhaO6oGiFe64PWCE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvbHG3M9X0P8bds+upvZvy6KnYn9yw+WCbTBPVnPJ1htQSc7p/RsONVzrt54EOhdJ
	 TjLsU/IgPkHUkBhE0/6tzTjAmPYKZEPediGHb2NzC2BQsn+ccSGvtU3+1gAAH6Pgcp
	 DwSFNcsGpy+FdWv3LaqJaTSxUwTJr43eGP2cRRLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 06/63] nvmet-passthru: clear EUID/NGUID/UUID while using loop target
Date: Fri, 15 Nov 2024 07:37:29 +0100
Message-ID: <20241115063726.126896964@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit e38dad438fc08162e20c600ae899e9e60688f72e ]

When nvme passthru is configured using loop target, the clear_ids
attribute is, by default, set to true. This attribute would ensure that
EUID/NGUID/UUID is cleared for the loop passthru target.

The newer NVMe disk supporting the NVMe spec 1.3 or higher, typically,
implements the support for "Namespace Identification Descriptor list"
command. This command when issued from host returns EUID/NGUID/UUID
assigned to the inquired namespace. Not clearing these values, while
using nvme passthru using loop target, would result in NVMe host driver
rejecting the namespace. This check was implemented in the commit
2079f41ec6ff ("nvme: check that EUI/GUID/UUID are globally unique").

The fix implemented in this commit ensure that when host issues ns-id
descriptor list command, the EUID/NGUID/UUID are cleared by passthru
target. In fact, the function nvmet_passthru_override_id_descs() which
clears those unique ids already exits, so we just need to ensure that
ns-id descriptor list command falls through the corretc code path. And
while we're at it, we also combines the three passthru admin command
cases together which shares the same code.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/passthru.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 24d0e2418d2e6..0f9b280c438d9 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -535,10 +535,6 @@ u16 nvmet_parse_passthru_admin_cmd(struct nvmet_req *req)
 		break;
 	case nvme_admin_identify:
 		switch (req->cmd->identify.cns) {
-		case NVME_ID_CNS_CTRL:
-			req->execute = nvmet_passthru_execute_cmd;
-			req->p.use_workqueue = true;
-			return NVME_SC_SUCCESS;
 		case NVME_ID_CNS_CS_CTRL:
 			switch (req->cmd->identify.csi) {
 			case NVME_CSI_ZNS:
@@ -547,7 +543,9 @@ u16 nvmet_parse_passthru_admin_cmd(struct nvmet_req *req)
 				return NVME_SC_SUCCESS;
 			}
 			return NVME_SC_INVALID_OPCODE | NVME_STATUS_DNR;
+		case NVME_ID_CNS_CTRL:
 		case NVME_ID_CNS_NS:
+		case NVME_ID_CNS_NS_DESC_LIST:
 			req->execute = nvmet_passthru_execute_cmd;
 			req->p.use_workqueue = true;
 			return NVME_SC_SUCCESS;
-- 
2.43.0



