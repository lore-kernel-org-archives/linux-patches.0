Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852342566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD7DC433D2;
	Tue, 18 Apr 2023 12:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821198;
	bh=Ld2R06EyD3db4l9Qo1PkejYPI3Iuyg+TgTFKKu7MAo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k93FLA31B7wzoch+rtUTq7Lilv/7QUP7LqiYdw54miBq5UezHWVPLSV0eIXghh98n
	 skCn497juF2p8bUxDF4zlo061uTmQIXFU5j46QMZVD+HfyrzB88wITGeQAwJ0DSclf
	 EBMKSi6Taz//b0/qTRoxU9i/+cIHucV/25LMcyMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhong Jinghua <zhongjinghua@huawei.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/124] scsi: iscsi_tcp: Check that sock is valid before iscsi_set_param()
Date: Tue, 18 Apr 2023 14:20:55 +0200
Message-Id: <20230418120311.116088456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhong Jinghua <zhongjinghua@huawei.com>

[ Upstream commit 48b19b79cfa37b1e50da3b5a8af529f994c08901 ]

The validity of sock should be checked before assignment to avoid incorrect
values. Commit 57569c37f0ad ("scsi: iscsi: iscsi_tcp: Fix null-ptr-deref
while calling getpeername()") introduced this change which may lead to
inconsistent values of tcp_sw_conn->sendpage and conn->datadgst_en.

Fix the issue by moving the position of the assignment.

Fixes: 57569c37f0ad ("scsi: iscsi: iscsi_tcp: Fix null-ptr-deref while calling getpeername()")
Signed-off-by: Zhong Jinghua <zhongjinghua@huawei.com>
Link: https://lore.kernel.org/r/20230329071739.2175268-1-zhongjinghua@huaweicloud.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 252d7881f99c2..def9fac7aa4f4 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -721,13 +721,12 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 		iscsi_set_param(cls_conn, param, buf, buflen);
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
-		iscsi_set_param(cls_conn, param, buf, buflen);
-
 		mutex_lock(&tcp_sw_conn->sock_lock);
 		if (!tcp_sw_conn->sock) {
 			mutex_unlock(&tcp_sw_conn->sock_lock);
 			return -ENOTCONN;
 		}
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_sw_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		mutex_unlock(&tcp_sw_conn->sock_lock);
-- 
2.39.2



