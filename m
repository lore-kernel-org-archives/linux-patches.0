Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24C04772A1;
	Sat, 12 Sep 2026 11:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210856; cv=none; b=N+pgBZPMawVmDgdnyfAdm/z1EhbQK1VIDjd0LV880+hbXqTWXzeUavN2GlM79DW2jeLFKdyOAYzDruLovnRQUHutvXRV1InTVcgIOD+AjfOIsGFgJ59u8qBw9iHdVeki/dzr4muYJmmaJXYHeS3IjsEh9N2H6MoxEidcNKqUsA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210856; c=relaxed/simple;
	bh=ZrbmQCOZoV0B8vd53SKD7quiDf3ZVLqZ6nn7eVgKatE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSSNxeZ2Xz++fEz61neV5C1eEKbuXlMe3fzQnF0gUQxiYxNSWuLauVfxp4Amn8Vpz2wdv7Gnkp4Klbl8j1E+AFlpoezhFBC86xjEZhcVgJtU7xAgqVgBRfsJLCK4TRMU30glVaTSP3XuKXKWvFdYMYAvYkEOB15bRNry1FtQoOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ce0jmLzC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ce0jmLzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB4C1F000FF;
	Sat, 12 Sep 2026 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210854;
	bh=APwhy+2jA9o7BHz5ulXRQ4I6hMaPKx6FRdtJsjmBy6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ce0jmLzC1zZCZEDd2TrTUK/rXj46PAwggsYzC57bUFASdFFTt32tTTr0hsy2rTl/j
	 3I9O8BI/INBJ98qP6hKYShbGAJ4q68vRWPkcFjaE2HQ0VWSmPvBHKWrS0b44W+uHX6
	 3hmNeyV5C4gh+NdNj1vywy0PnuRjeNWBGcCkTV/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1112/1518] nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()
Date: Sat, 12 Sep 2026 08:54:41 +0200
Message-ID: <20260912065648.605192535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 27c15748fc7b8..9642f13601656 100644
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
@@ -72,6 +76,10 @@ static u8 nvmet_auth_negotiate(struct nvmet_req *req, void *d)
 	    NVME_AUTH_DHCHAP_AUTH_ID)
 		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
 
+	if (data->auth_protocol[0].dhchap.dhlen > NVME_AUTH_DHCHAP_MAX_DH_IDS ||
+	    data->auth_protocol[0].dhchap.halen > NVME_AUTH_DHCHAP_MAX_HASH_IDS)
+		return NVME_AUTH_DHCHAP_FAILURE_INCORRECT_PAYLOAD;
+
 	for (i = 0; i < data->auth_protocol[0].dhchap.halen; i++) {
 		u8 host_hmac_id = data->auth_protocol[0].dhchap.idlist[i];
 
@@ -317,7 +325,7 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
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



