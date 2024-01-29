Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2724915B308;
	Mon, 29 Jan 2024 17:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548288; cv=none; b=tJisf/rgYAaRPZCTMuzqJeSQT6gv4HHBhSq9XvJIj4U5JeaNUO2Zqd56afAcLphFtQjGQxaRTcFgk+xD5jZ7QSGoOiQ0m0bLKvUlO8wSL210dY3m2zIaXkRL5ZulFGffY7x2kCjnLMe0IDOW72pIrus6A/wBo0zPpEblt4hDU3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548288; c=relaxed/simple;
	bh=S81anpl1YGvhlZuoTdJFcSc8SV836df7O1jDqgMRHLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rv77qq1g/KdLBexKV+lDWff5fkBGCyHiLAJVOrOxoe9j/r0VF3p6ybrK6RjcwzDovx90qD71bmZLYF9fc0m7XLeJATIQ1JtE5zrSXGlRWWGXeht0MDSmKhRjfbAWtRzgUr2bMgboduttKOwRvx8YC9/0kN0d7QSiH1QBRGEy4L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIX1Srzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIX1Srzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0878C43390;
	Mon, 29 Jan 2024 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548287;
	bh=S81anpl1YGvhlZuoTdJFcSc8SV836df7O1jDqgMRHLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIX1SrzzvVw5iHYv2Cmndyhetmhim1phx8oXpFCmWFrf5JCD3njSxUaOgf4rOCCHO
	 MdfdLOukJ+oOC1EGJgE5ZUkEvMQWCgvtBMK46r/u8v8zB0rcVjzQn+y1KK1kX71ol6
	 mFWTdmQid2axg/YnynoGoZcln7n3JVrhubWeGJNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 071/185] ksmbd: dont increment epoch if current state and request state are same
Date: Mon, 29 Jan 2024 09:04:31 -0800
Message-ID: <20240129170000.882730414@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

[ Upstream commit b6e9a44e99603fe10e1d78901fdd97681a539612 ]

If existing lease state and request state are same, don't increment
epoch in create context.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/oplock.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -105,7 +105,7 @@ static int alloc_lease(struct oplock_inf
 	lease->is_dir = lctx->is_dir;
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
-	lease->epoch = le16_to_cpu(lctx->epoch);
+	lease->epoch = le16_to_cpu(lctx->epoch) + 1;
 	INIT_LIST_HEAD(&opinfo->lease_entry);
 	opinfo->o_lease = lease;
 
@@ -541,6 +541,9 @@ static struct oplock_info *same_client_h
 				continue;
 			}
 
+			if (lctx->req_state != lease->state)
+				lease->epoch++;
+
 			/* upgrading lease */
 			if ((atomic_read(&ci->op_count) +
 			     atomic_read(&ci->sop_count)) == 1) {
@@ -1035,7 +1038,7 @@ static void copy_lease(struct oplock_inf
 	       SMB2_LEASE_KEY_SIZE);
 	lease2->duration = lease1->duration;
 	lease2->flags = lease1->flags;
-	lease2->epoch = lease1->epoch++;
+	lease2->epoch = lease1->epoch;
 	lease2->version = lease1->version;
 }
 
@@ -1454,7 +1457,7 @@ void create_lease_buf(u8 *rbuf, struct l
 		memcpy(buf->lcontext.LeaseKey, lease->lease_key,
 		       SMB2_LEASE_KEY_SIZE);
 		buf->lcontext.LeaseFlags = lease->flags;
-		buf->lcontext.Epoch = cpu_to_le16(++lease->epoch);
+		buf->lcontext.Epoch = cpu_to_le16(lease->epoch);
 		buf->lcontext.LeaseState = lease->state;
 		memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
 		       SMB2_LEASE_KEY_SIZE);


