Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA6E2B9C7;
	Sun,  1 Sep 2024 16:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208876; cv=none; b=JAg55elP5b3461mOKALV0I9w5T39WC9XRfY+YDNMx2lGT5F8A/Ww4+ljpwpGmWsdESfLjrt4q6FMyYI3Jw3FV/DeKCLAOlqRlEN5LQ+IZ0QdbU6l1NjRYbJf8dC1OjzIY39mgUClbPg2dovHVU7icWx373vcBi21cnWUm9IvLu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208876; c=relaxed/simple;
	bh=cJOP8PKRYMEDpx0UXRv7p0sd2TVQcXcKUqkaziquLoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQapNSzt0vAOihPvXuvdQvGG8Msp/5OKFK+4KjE98mq5E6982ZXmEKznGVpI0i9u+8m3t0oUDy8ze3ukPuQydNl/s9gPxypzoUGcTRq/ytWbnFZ3KWQZ+Ukviu9nUmKUc6XA+V3pl6jMNvzV5B4/YVqXsvu3RJXxIeF6ayZw9jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKmF1lVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKmF1lVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50186C4CEC3;
	Sun,  1 Sep 2024 16:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208876;
	bh=cJOP8PKRYMEDpx0UXRv7p0sd2TVQcXcKUqkaziquLoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKmF1lVRPmE4BNKoUE+XeHM6fXTjvWX1o+gXZDFquoONZtzCh44fFkY31ozuwW2LP
	 06vLj70l6vO4lmqrVUL685B40Av8N2FIhCIPtQyHQu0OB254l9cgzRirAafwrPo9lT
	 nthxT9mDDR7NprgaqQVuNtBByXwzi0tKsShsFrn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 067/134] s390/iucv: fix receive buffer virtual vs physical address confusion
Date: Sun,  1 Sep 2024 18:16:53 +0200
Message-ID: <20240901160812.621695304@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 4e8477aeb46dfe74e829c06ea588dd00ba20c8cc ]

Fix IUCV_IPBUFLST-type buffers virtual vs physical address confusion.
This does not fix a bug since virtual and physical address spaces are
currently the same.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/iucv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index f0364649186b9..dc85973479284 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -1136,8 +1136,7 @@ static int iucv_message_receive_iprmdata(struct iucv_path *path,
 		size = (size < 8) ? size : 8;
 		for (array = buffer; size > 0; array++) {
 			copy = min_t(size_t, size, array->length);
-			memcpy((u8 *)(addr_t) array->address,
-				rmmsg, copy);
+			memcpy(phys_to_virt(array->address), rmmsg, copy);
 			rmmsg += copy;
 			size -= copy;
 		}
-- 
2.43.0



