Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF79F746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527D9C433C7;
	Sun, 17 Sep 2023 20:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982448;
	bh=9A7KS8RlMP0yBuYtt67H2oWTcch64eeLnV1KgTnA4p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYYoiFIXOTkqWIlwCt9Gr3O1XX0JhYZ3e7yDhEAbJDQaZQV8vHdZ5Ego6G6SXuruU
	 YvKoIwfJ5xDgs6V4tHz0BkE2kftXTIX3ogMfL0RVa91a1ZD/vnP/Y35NFIsoUunGUO
	 a44fpzfVbAiB4zzm8Z/GtzHcKJC3bXn+TfazWNIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Chris Leech <cleech@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/511] scsi: iscsi: Add strlen() check in iscsi_if_set{_host}_param()
Date: Sun, 17 Sep 2023 21:11:21 +0200
Message-ID: <20230917191119.958765282@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit ce51c817008450ef4188471db31639d42d37a5e1 ]

The functions iscsi_if_set_param() and iscsi_if_set_host_param() convert an
nlattr payload to type char* and then call C string handling functions like
sscanf and kstrdup:

  char *data = (char*)ev + sizeof(*ev);
  ...
  sscanf(data, "%d", &value);

However, since the nlattr is provided by the user-space program and the
nlmsg skb is allocated with GFP_KERNEL instead of GFP_ZERO flag (see
netlink_alloc_large_skb() in netlink_sendmsg()), dirty data on the heap can
lead to an OOB access for those string handling functions.

By investigating how the bug is introduced, we find it is really
interesting as the old version parsing code starting from commit
fd7255f51a13 ("[SCSI] iscsi: add sysfs attrs for uspace sync up") treated
the nlattr as integer bytes instead of string and had length check in
iscsi_copy_param():

  if (ev->u.set_param.len != sizeof(uint32_t))
    BUG();

But, since the commit a54a52caad4b ("[SCSI] iscsi: fixup set/get param
functions"), the code treated the nlattr as C string while forgetting to
add any strlen checks(), opening the possibility of an OOB access.

Fix the potential OOB by adding the strlen() check before accessing the
buf. If the data passes this check, all low-level set_param handlers can
safely treat this buf as legal C string.

Fixes: fd7255f51a13 ("[SCSI] iscsi: add sysfs attrs for uspace sync up")
Fixes: 1d9bf13a9cf9 ("[SCSI] iscsi class: add iscsi host set param event")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Link: https://lore.kernel.org/r/20230723075820.3713119-1-linma@zju.edu.cn
Reviewed-by: Chris Leech <cleech@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 70a58b3ad5621..e044b65ee0d08 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3050,6 +3050,10 @@ iscsi_if_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev, u
 	if (!conn || !session)
 		return -EINVAL;
 
+	/* data will be regarded as NULL-ended string, do length check */
+	if (strlen(data) > ev->u.set_param.len)
+		return -EINVAL;
+
 	switch (ev->u.set_param.param) {
 	case ISCSI_PARAM_SESS_RECOVERY_TMO:
 		sscanf(data, "%d", &value);
@@ -3223,6 +3227,10 @@ iscsi_set_host_param(struct iscsi_transport *transport,
 		return -ENODEV;
 	}
 
+	/* see similar check in iscsi_if_set_param() */
+	if (strlen(data) > ev->u.set_host_param.len)
+		return -EINVAL;
+
 	err = transport->set_host_param(shost, ev->u.set_host_param.param,
 					data, ev->u.set_host_param.len);
 	scsi_host_put(shost);
-- 
2.40.1



