Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA8D2E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462A0C433C8;
	Wed, 20 Sep 2023 12:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212074;
	bh=sOZzuEAZCi/jloHC+BJLNvii5bZ8580TRQ3QhZZ6D6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pS36NexZBYixWQsqC59BVmAa5UxfDiTEmy5UzxxQ35lKwEsgiswAPala4tVM+YQ7
	 9sg/131J/p+7NjYeyRMYWfFhTzeKs8NZdiz+PGQ64GMUkNyOR+fxsbmJ4fwsK+zBdx
	 dkRmAt9WzciLm+RXN/3u1Fl0plUzrXaUkV1mI1zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/273] scsi: qla4xxx: Add length check when parsing nlattrs
Date: Wed, 20 Sep 2023 13:29:41 +0200
Message-ID: <20230920112850.886774836@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 47cd3770e31df942e2bb925a9a855c79ed0662eb ]

There are three places that qla4xxx parses nlattrs:

 - qla4xxx_set_chap_entry()

 - qla4xxx_iface_set_param()

 - qla4xxx_sysfs_ddb_set_param()

and each of them directly converts the nlattr to specific pointer of
structure without length checking. This could be dangerous as those
attributes are not validated and a malformed nlattr (e.g., length 0) could
result in an OOB read that leaks heap dirty data.

Add the nla_len check before accessing the nlattr data and return EINVAL if
the length check fails.

Fixes: 26ffd7b45fe9 ("[SCSI] qla4xxx: Add support to set CHAP entries")
Fixes: 1e9e2be3ee03 ("[SCSI] qla4xxx: Add flash node mgmt support")
Fixes: 00c31889f751 ("[SCSI] qla4xxx: fix data alignment and use nl helpers")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20230723080053.3714534-1-linma@zju.edu.cn
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4ba9f46fcf748..21cc9e2797a28 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -940,6 +940,11 @@ static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void *data, int len)
 	memset(&chap_rec, 0, sizeof(chap_rec));
 
 	nla_for_each_attr(attr, data, len, rem) {
+		if (nla_len(attr) < sizeof(*param_info)) {
+			rc = -EINVAL;
+			goto exit_set_chap;
+		}
+
 		param_info = nla_data(attr);
 
 		switch (param_info->param) {
@@ -2724,6 +2729,11 @@ qla4xxx_iface_set_param(struct Scsi_Host *shost, void *data, uint32_t len)
 	}
 
 	nla_for_each_attr(attr, data, len, rem) {
+		if (nla_len(attr) < sizeof(*iface_param)) {
+			rval = -EINVAL;
+			goto exit_init_fw_cb;
+		}
+
 		iface_param = nla_data(attr);
 
 		if (iface_param->param_type == ISCSI_NET_PARAM) {
@@ -8098,6 +8108,11 @@ qla4xxx_sysfs_ddb_set_param(struct iscsi_bus_flash_session *fnode_sess,
 
 	memset((void *)&chap_tbl, 0, sizeof(chap_tbl));
 	nla_for_each_attr(attr, data, len, rem) {
+		if (nla_len(attr) < sizeof(*fnode_param)) {
+			rc = -EINVAL;
+			goto exit_set_param;
+		}
+
 		fnode_param = nla_data(attr);
 
 		switch (fnode_param->param) {
-- 
2.40.1



