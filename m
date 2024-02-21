Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783966BB52;
	Wed, 21 Feb 2024 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521974; cv=none; b=ua/iC3wvbIr/Rz9A0MqBkXavsTLzOJS542TOUp69tYoumhDbWkugpSxvut2qsPBBYqEC2dx+dthEsrZKeD2h63hctZ5sLiMlDDVK/XtM18Ij/zTInnCTU4rfGFQif/ckYAuLNoA/y5NQefJVW09dJlYEL5BX0S+S39ZEPkNPrOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521974; c=relaxed/simple;
	bh=VcSInWm+0qp09Vjk0F4GqU+svUe/09zXs0B/seIyeFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiumiuS/YvGK/tAm9nV7wyKLzUd6gjW/BKVFfpAZ6mlVDehFu+FY34NISa2SO1u/OsqAuu+BbycrZsgnX7dV1FlL3EG1+l4f4LN4uOmXzxxleeWkYkzg/XgJv7qV3sE0cH74beqU3p0/nfo4n2g6ZoMvD+16ECQPpNLAq38pSqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2L9+JT5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2L9+JT5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BA7C433C7;
	Wed, 21 Feb 2024 13:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521974;
	bh=VcSInWm+0qp09Vjk0F4GqU+svUe/09zXs0B/seIyeFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2L9+JT5Ob9if3Kk7nwhz2Otht27w6OhwJ88tqf2sRE9qBkOZ3vDMLEmlshD7ujVX9
	 yzG7nzCirqJMBukasrG2HCBJipCCKGQkQINBxT1PLCyD04bvVFWzbTJtiFW/RV0JDX
	 oknJYocEA/iOUFyXtnml2aT+3F4+ODvtCtFOHWNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 042/476] ksmbd: dont increment epoch if current state and request state are same
Date: Wed, 21 Feb 2024 14:01:33 +0100
Message-ID: <20240221130009.490491733@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit b6e9a44e99603fe10e1d78901fdd97681a539612 ]

If existing lease state and request state are same, don't increment
epoch in create context.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
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


