Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D84579FD;
	Thu, 11 Apr 2024 10:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832587; cv=none; b=WN9eTeyzwKUxalReHnEzBD3G2n/+mQ9TFzPczDOH2L/Ds0xEXcKVJJmbOKiTo3CvIdIc2qXj58Vj4INamraUJ6IokM25v9U5BiFRPw2e3+gI8iUMtJtIVOJ0uT78yt7JWg4H4ir5OLDLy/8UTD9uwbagdh6aCPdwJUCYqGCKsG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832587; c=relaxed/simple;
	bh=O2fdcscBA3c3capcWmCUI/IV9rmygdNl/DlLmB7PQ/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jya9WKMudrwsJmeDviovYNO3EPQ9HkreDoQVQ2qXVZE3DG06kZeB5EKnj2nJo5ZrIoF4CCt634hKeXb9IjQwiu1B/VAxGlFEXy88BZXeY55br/XxBTh05Lts648CRpyibeHUXfzSKm4derAkRt30Sqtdsx6Mqlham8i+y65Sk0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y22ktpiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y22ktpiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E4BC433F1;
	Thu, 11 Apr 2024 10:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832587;
	bh=O2fdcscBA3c3capcWmCUI/IV9rmygdNl/DlLmB7PQ/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y22ktpiUbgn9oHqD3q/DF+ZrHWuVvV9MJrwiVQosuNvn6ojNb/xwExq1wCdDUFRKp
	 hzT3w1q8gAqees8QDTuq+eGP++zfh2kY9Vxxzhkux1OF4Qy+Lw695Or3WEGGe2OeyW
	 ksVpkR1Uvlan2rrdOANR9TJfLbIcxXLYYUYm8BwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Kees Cook <keescook@chromium.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/57] VMCI: Fix memcpy() run-time warning in dg_dispatch_as_host()
Date: Thu, 11 Apr 2024 11:57:13 +0200
Message-ID: <20240411095408.151230810@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 19b070fefd0d024af3daa7329cbc0d00de5302ec ]

Syzkaller hit 'WARNING in dg_dispatch_as_host' bug.

memcpy: detected field-spanning write (size 56) of single field "&dg_info->msg"
at drivers/misc/vmw_vmci/vmci_datagram.c:237 (size 24)

WARNING: CPU: 0 PID: 1555 at drivers/misc/vmw_vmci/vmci_datagram.c:237
dg_dispatch_as_host+0x88e/0xa60 drivers/misc/vmw_vmci/vmci_datagram.c:237

Some code commentry, based on my understanding:

544 #define VMCI_DG_SIZE(_dg) (VMCI_DG_HEADERSIZE + (size_t)(_dg)->payload_size)
/// This is 24 + payload_size

memcpy(&dg_info->msg, dg, dg_size);
	Destination = dg_info->msg ---> this is a 24 byte
					structure(struct vmci_datagram)
	Source = dg --> this is a 24 byte structure (struct vmci_datagram)
	Size = dg_size = 24 + payload_size

{payload_size = 56-24 =32} -- Syzkaller managed to set payload_size to 32.

 35 struct delayed_datagram_info {
 36         struct datagram_entry *entry;
 37         struct work_struct work;
 38         bool in_dg_host_queue;
 39         /* msg and msg_payload must be together. */
 40         struct vmci_datagram msg;
 41         u8 msg_payload[];
 42 };

So those extra bytes of payload are copied into msg_payload[], a run time
warning is seen while fuzzing with Syzkaller.

One possible way to fix the warning is to split the memcpy() into
two parts -- one -- direct assignment of msg and second taking care of payload.

Gustavo quoted:
"Under FORTIFY_SOURCE we should not copy data across multiple members
in a structure."

Reported-by: syzkaller <syzkaller@googlegroups.com>
Suggested-by: Vegard Nossum <vegard.nossum@oracle.com>
Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240105164001.2129796-2-harshit.m.mogalapalli@oracle.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_datagram.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
index f50d22882476f..d1d8224c8800c 100644
--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -234,7 +234,8 @@ static int dg_dispatch_as_host(u32 context_id, struct vmci_datagram *dg)
 
 			dg_info->in_dg_host_queue = true;
 			dg_info->entry = dst_entry;
-			memcpy(&dg_info->msg, dg, dg_size);
+			dg_info->msg = *dg;
+			memcpy(&dg_info->msg_payload, dg + 1, dg->payload_size);
 
 			INIT_WORK(&dg_info->work, dg_delayed_dispatch);
 			schedule_work(&dg_info->work);
-- 
2.43.0



