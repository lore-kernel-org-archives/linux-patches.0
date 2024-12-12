Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7992080FC;
	Thu, 12 Dec 2024 15:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016138; cv=none; b=I9JAq6av+iW/clF3C4zB3lV5qLlejWJHWf3IpZ/M8k6Y/AvGzkMp2kvSE1IAhCHwOzE++dnUawZCH49j2bc7bdmJKvHH6pXvo/vidpSlUcVGIy7QYpnMPAtNiVXJDYC0eMO5ZR0DsgQGfp9qUGDagiLhWTqb//0Y3q9TRSKEkjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016138; c=relaxed/simple;
	bh=dqRdFl/vonbxecwOxnoF27THB1gNBSihhUObUtwRv4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuGpCnhA6JntKxjhxkLUIV1yz4Nid67EktVK5hfBDkuWk/1Qifkqn3ye3+h3JueTOZF+Gd0vwRw9lqe23PQ47jTNHvdZNkCs/+3kIlqOL/vhQImyjNgsdarZdcbCBX7GrJwBnFTlhtiMuYq16RcrPRwksgCC/vZMWTrEvv8nGn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e0wi64LV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e0wi64LV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCAFC4CECE;
	Thu, 12 Dec 2024 15:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016138;
	bh=dqRdFl/vonbxecwOxnoF27THB1gNBSihhUObUtwRv4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0wi64LV3h4RiHdvUY28vKFPT0gOhAVp3ZNucC4jz5mMS2EzOOkX+yowZSAj0voNh
	 M2L3mNo+BVDWQp3ZMltjOpl07Z0odKOLQ3L4VDThbYlGlMxOxhbhzmoJQD72b5pfYg
	 oqJYC/ZSpEAZf6Hi3q8Dzo9joi3vm668nbW5/E3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordy Zomer <jordyzomer@google.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 126/466] ksmbd: fix Out-of-Bounds Read in ksmbd_vfs_stream_read
Date: Thu, 12 Dec 2024 15:54:55 +0100
Message-ID: <20241212144311.782585742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordy Zomer <jordyzomer@google.com>

commit fc342cf86e2dc4d2edb0fc2ff5e28b6c7845adb9 upstream.

An offset from client could be a negative value, It could lead
to an out-of-bounds read from the stream_buf.
Note that this issue is coming when setting
'vfs objects = streams_xattr parameter' in ksmbd.conf.

Cc: stable@vger.kernel.org # v5.15+
Reported-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Jordy Zomer <jordyzomer@google.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6651,6 +6651,10 @@ int smb2_read(struct ksmbd_work *work)
 	}
 
 	offset = le64_to_cpu(req->Offset);
+	if (offset < 0) {
+		err = -EINVAL;
+		goto out;
+	}
 	length = le32_to_cpu(req->Length);
 	mincount = le32_to_cpu(req->MinimumCount);
 


