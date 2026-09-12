Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8F447CC94;
	Sat, 12 Sep 2026 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218011; cv=none; b=SD0XPDb/5Wb+sBTGKhuBHgUaG5pT9UQBJV9QhlKspQq4y4KKzTgsg6fiOwZCEv7Z03OhczEEXzEoZ/sjztyVQG8m4GssZfKX1p9oA7HcuvPZRlg+YxoCr3mPJMq3uZO2FWbgYdxpaTYnZNvFRUtC8YMVDo2nxQ3EhztqPUKUtHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218011; c=relaxed/simple;
	bh=+v9q939/Zh00C3gqYVtLrHJBXoBtKXv5yDn4slHp8No=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2YF8f7tevZwGhIjArYZDPWOKkIT+7Z9jobDOUWTCdfQNe7YyBSrkwu2G4fSbr0/NLFdUP/mBy/LXV+dE8d8FpqKC99lVzdPYs+r73JD7NEQRmKPl2rkFxnuTjq1g1Njel0NIiwTpNB45/8juYjU80OrWljLOL8QokJ+75KYShI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfTkmrQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfTkmrQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6E61F000FF;
	Sat, 12 Sep 2026 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218010;
	bh=QQb7roiBWu2P+L0KB36vQG+F/M6c3NcxhRZwcKXWx5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CfTkmrQMbtNtzme5IzwJFIKyyrEMacI3O/e2AYsVC0h2DttPZwqv6e5EOcuA7bTsk
	 EhMyX2Wnbgtwv7CeI9U1BB/JOgqiplRe2c1e1MI+BrDwTPfrevglHs+ade8IFPKUxx
	 n6hbe/2q3AmWTdOULtjWKTYhGe+0/JzvLfLLH6M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1056/1376] nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()
Date: Sat, 12 Sep 2026 08:58:02 +0200
Message-ID: <20260912065631.096348086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 5bb96cc218835769ab74ec7f3ea2bf81fbffe955 ]

nvmet_execute_auth_send() allocates the DH-HMAC-CHAP message buffer with
the host-supplied transfer length (tl) and hands it to
nvmet_auth_negotiate() without passing tl along. nvmet_auth_negotiate()
then reads the negotiate header and, for each of the halen hash
identifiers and dhlen DH group identifiers, indexes into the fixed
idlist[60] array (hashes at idlist[0..halen), groups at idlist[30..]).

Neither the transfer length nor halen/dhlen is validated. A malicious or
non-conformant host can report a tl smaller than the negotiate structure,
or a halen/dhlen larger than the array (both are u8, up to 255), making
the loops read past the end of the allocated buffer (heap out-of-bounds
read). The sibling nvmet_auth_reply() already validates tl against the
structure size; the negotiate path did not.

Pass tl into nvmet_auth_negotiate(), reject a tl that does not cover the
negotiate data plus one full protocol descriptor, and reject halen/dhlen
larger than NVME_AUTH_DHCHAP_MAX_DH_IDS.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 34924c4c73b97..4d7b5ef643eb3 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -31,12 +31,16 @@ void nvmet_auth_sq_init(struct nvmet_sq *sq)
 	sq->dhchap_step = NVME_AUTH_DHCHAP_MESSAGE_NEGOTIATE;
 }
 
-static u8 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
+static u8 nvmet_auth_negotiate(struct nvmet_req *req, void *d, u32 tl)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
 	struct nvmf_auth_dhchap_negotiate_data *data = d;
 	int i, hash_id = 0, fallback_hash_id = 0, dhgid, fallback_dhgid;
 
+	if (tl < sizeof(*data) +
+			sizeof(struct nvmf_auth_dhchap_protocol_descriptor))
+		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+
 	pr_debug("%s: ctrl %d qid %d: data sc_d %d napd %d authid %d halen %d dhlen %d\n",
 		 __func__, ctrl->cntlid, req->sq->qid,
 		 data->sc_c, data->napd, data->auth_protocol[0].dhchap.authid,
@@ -53,6 +57,10 @@ static u8 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
 	    NVME_AUTH_DHCHAP_AUTH_ID)
 		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
 
+	if (data->auth_protocol[0].dhchap.dhlen > NVME_AUTH_DHCHAP_MAX_DH_IDS ||
+	    data->auth_protocol[0].dhchap.halen > NVME_AUTH_DHCHAP_MAX_HASH_IDS)
+		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+
 	for (i = 0; i < data->auth_protocol[0].dhchap.halen; i++) {
 		u8 host_hmac_id = data->auth_protocol[0].dhchap.idlist[i];
 
@@ -270,7 +278,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 		} else if (data->auth_id != req->sq->dhchap_step)
 			goto done_failure1;
 		/* Validate negotiation parameters */
-		dhchap_status = nvmet_auth_negotiate(req, d);
+		dhchap_status = nvmet_auth_negotiate(req, d, tl);
 		if (dhchap_status == 0)
 			req->sq->dhchap_step =
 				NVME_AUTH_DHCHAP_MESSAGE_CHALLENGE;
-- 
2.53.0



