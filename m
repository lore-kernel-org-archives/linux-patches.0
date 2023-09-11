Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 854C01171B
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0543BC433C9;
	Mon, 11 Sep 2023 15:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444532;
	bh=Er/e7eH2qEuzf7bjuGC8j4gTYRvOZ9xPUkywcTcnisU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHrs8YPWljvww0MH24B0VtBFGH0HoLoYF1Ue9WVZ0mRDXS8S3jZxgDiNNumXKILMY
	 h32nIG/h+xeu+o+8d+C3Sp/SRfAdK0U9QLDAu06sYnijCGmncPrk4OarxljVk/ylVw
	 tnCjHRvx9YOcySGov6aSfn7EWmY8K+JsWd/fLt6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.1 018/600] ksmbd: no response from compound read
Date: Mon, 11 Sep 2023 15:40:51 +0200
Message-ID: <20230911134634.154065067@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e202a1e8634b186da38cbbff85382ea2b9e297cf ]

ksmbd doesn't support compound read. If client send read-read in
compound to ksmbd, there can be memory leak from read buffer.
Windows and linux clients doesn't send it to server yet. For now,
No response from compound read. compound read will be supported soon.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-21587, ZDI-CAN-21588
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 74c245809772e..f6fd5cf976a50 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6314,6 +6314,11 @@ int smb2_read(struct ksmbd_work *work)
 	unsigned int max_read_size = conn->vals->max_read_size;
 
 	WORK_BUFFERS(work, req, rsp);
+	if (work->next_smb2_rcv_hdr_off) {
+		work->send_no_response = 1;
+		err = -EOPNOTSUPP;
+		goto out;
+	}
 
 	if (test_share_config_flag(work->tcon->share_conf,
 				   KSMBD_SHARE_FLAG_PIPE)) {
-- 
2.40.1



