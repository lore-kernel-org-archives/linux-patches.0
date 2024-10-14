Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0594A24;
	Mon, 14 Oct 2024 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916641; cv=none; b=JdZukkvYCGs/II27ceqPyGavKNoKibFuPjV11LAidoZ/MtKm77REvfEvXReYz0vrHg3G995lHFZykMlE3W40hm8a0FWkpfWxPxUi+75eVJAE46X4RDZpb/ILl+MSCQhm7UeF6tK5xKcaEbwAf658woqax4PEMgEwjA/CoLRnOX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916641; c=relaxed/simple;
	bh=BpcHcOPsL/Yf9cl7HNx/DUkKWELcYoM6vJ0zaLx9mVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDdtUxDZ/1ydid973HrvM75Im0LuTi1SbEVY+cEmrxkDt+Ffoh2dULrlHsyypFKfOagXZmjc/42ZXe6qI0B1OTPbBNT9kaqjDCFdIGd84ejh8w8jHrZ1w2dzzLpa9OadgxZcjS+t8ppuijpUa9bWObAHqBk8XpsXaEvFcru2gRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A13LKL5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A13LKL5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12B5C4CEC3;
	Mon, 14 Oct 2024 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916641;
	bh=BpcHcOPsL/Yf9cl7HNx/DUkKWELcYoM6vJ0zaLx9mVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A13LKL5IK+GJd6SkhiUAXdV8DZy8AcVwiGoIBoYh70TDCHeSt00M96PJrNsGH/ifz
	 qnHdpb2AknoRmfovsVog6Mfum+jS1kHya38YBKnBCNdx8I8Rn8UD/0mkfDyv0rWrbD
	 kHe49mRAZ6WQaDN61dpW5t5gDHmofakrTluCxEg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Luis Henriques <lhenriques@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/213] libceph: init the cursor when preparing sparse read in msgr2
Date: Mon, 14 Oct 2024 16:18:50 +0200
Message-ID: <20241014141043.929601567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 321e3c3de53c7530cd518219d01f04e7e32a9d23 ]

The cursor is no longer initialized in the OSD client, causing the
sparse read state machine to fall into an infinite loop.  The cursor
should be initialized in IN_S_PREPARE_SPARSE_DATA state.

[ idryomov: use msg instead of con->in_msg, changelog ]

Link: https://tracker.ceph.com/issues/64607
Fixes: 8e46a2d068c9 ("libceph: just wait for more data to be available on the socket")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Tested-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/messenger_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index a901cae2f1060..f9ed6bf6c4776 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2038,6 +2038,9 @@ static int prepare_sparse_read_data(struct ceph_connection *con)
 	if (!con_secure(con))
 		con->in_data_crc = -1;
 
+	ceph_msg_data_cursor_init(&con->v2.in_cursor, msg,
+				  msg->sparse_read_total);
+
 	reset_in_kvecs(con);
 	con->v2.in_state = IN_S_PREPARE_SPARSE_DATA_CONT;
 	con->v2.data_len_remain = data_len(msg);
-- 
2.43.0



