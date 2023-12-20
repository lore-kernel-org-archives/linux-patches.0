Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9271B4C3DB;
	Wed, 20 Dec 2023 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMFC67Ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1542CC433C9;
	Wed, 20 Dec 2023 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088738;
	bh=x8TffMKaZRC5lkRwoARAVAjkQI43lkaEPTDRAj9BDPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMFC67RoFlPkIrpdCpJJ2S5PL8pHRyw+dwmCHF44EUHO+/JWhANBTqx16VXewTIqc
	 h2hNTIhiKsUqL7CaGcAVYE0q0tbSlAyqVA8uqgh1wd8E83o4VxYMC/Gh2rvsNYj/O2
	 MLsYqXI4RfNYDTwm6/OkXCQhiwj4io/zBJ5YgjSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 041/159] ksmbd: smbd: relax the count of sges required
Date: Wed, 20 Dec 2023 17:08:26 +0100
Message-ID: <20231220160933.218188032@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 621433b7e25d6d42e5f75bd8c4a62d6c7251511b ]

Remove the condition that the count of sges
must be greater than or equal to
SMB_DIRECT_MAX_SEND_SGES(8).
Because ksmbd needs sges only for SMB direct
header, SMB2 transform header, SMB2 response,
and optional payload.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/transport_rdma.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1711,11 +1711,11 @@ static int smb_direct_init_params(struct
 	int max_send_sges, max_rw_wrs, max_send_wrs;
 	unsigned int max_sge_per_wr, wrs_per_credit;
 
-	/* need 2 more sge. because a SMB_DIRECT header will be mapped,
-	 * and maybe a send buffer could be not page aligned.
+	/* need 3 more sge. because a SMB_DIRECT header, SMB2 header,
+	 * SMB2 response could be mapped.
 	 */
 	t->max_send_size = smb_direct_max_send_size;
-	max_send_sges = DIV_ROUND_UP(t->max_send_size, PAGE_SIZE) + 2;
+	max_send_sges = DIV_ROUND_UP(t->max_send_size, PAGE_SIZE) + 3;
 	if (max_send_sges > SMB_DIRECT_MAX_SEND_SGES) {
 		pr_err("max_send_size %d is too large\n", t->max_send_size);
 		return -EINVAL;
@@ -1736,6 +1736,8 @@ static int smb_direct_init_params(struct
 
 	max_sge_per_wr = min_t(unsigned int, device->attrs.max_send_sge,
 			       device->attrs.max_sge_rd);
+	max_sge_per_wr = max_t(unsigned int, max_sge_per_wr,
+			       max_send_sges);
 	wrs_per_credit = max_t(unsigned int, 4,
 			       DIV_ROUND_UP(t->pages_per_rw_credit,
 					    max_sge_per_wr) + 1);
@@ -1760,11 +1762,6 @@ static int smb_direct_init_params(struct
 		return -EINVAL;
 	}
 
-	if (device->attrs.max_send_sge < SMB_DIRECT_MAX_SEND_SGES) {
-		pr_err("warning: device max_send_sge = %d too small\n",
-		       device->attrs.max_send_sge);
-		return -EINVAL;
-	}
 	if (device->attrs.max_recv_sge < SMB_DIRECT_MAX_RECV_SGES) {
 		pr_err("warning: device max_recv_sge = %d too small\n",
 		       device->attrs.max_recv_sge);


