Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150B1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzHdzHVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBE1C433C7;
	Wed,  4 Oct 2023 18:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443919;
	bh=ypzltvnii92eYOu5/ITUMYET7remSkAAxBzLEqHitFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzHdzHVlZqiWDfJRk6uma7NDqd4C1mMitY0CrFYf8cZvXhjZDP4MsmJeVXKUXgdY+
	 /EYbaxxZoiqT2ip2/mQ1hIBVW7FEetBi4uVE94gFflweurU5nrVbVDb9IMwqZZcPR0
	 7uvDbThEUjxtWWiIPgkVnfpgHfepyUZ3BnxwNCeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 067/321] scsi: iscsi_tcp: restrict to TCP sockets
Date: Wed,  4 Oct 2023 19:53:32 +0200
Message-ID: <20231004175232.295425568@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f4f82c52a0ead5ab363d207d06f81b967d09ffb8 ]

Nothing prevents iscsi_sw_tcp_conn_bind() to receive file descriptor
pointing to non TCP socket (af_unix for example).

Return -EINVAL if this is attempted, instead of crashing the kernel.

Fixes: 7ba247138907 ("[SCSI] open-iscsi/linux-iscsi-5 Initiator: Initiator code")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9ab8555180a3a..8e14cea15f980 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -724,6 +724,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		return -EEXIST;
 	}
 
+	err = -EINVAL;
+	if (!sk_is_tcp(sock->sk))
+		goto free_socket;
+
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (err)
 		goto free_socket;
-- 
2.40.1



