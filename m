Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C749339872;
	Fri,  4 Sep 2026 06:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502198; cv=none; b=oyx6XYm2XV0i7WcAEj55xM4wZMLUcH8poeZLOgeluLRdHIjP+ATIIn2Xrym7vcPqgbZ4or86ytEjj3Un34BKx80s9ETJFljzRb92LqmcaUzJ3EtBUYEHNmSz6o1YhNDa9Nwq9h+OnUq6uhbjq9Jc6rJdwYEh27ORnvSOuGEVlcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502198; c=relaxed/simple;
	bh=oeE2S5CeLlN0JqQUxsiqoquRsdUPeWlebRHtbrvkvhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THu2UvghGnLAI06GVurDIgF3kWHLIb+WTGBC84tYG4to3OisBdanl20dPaW0dWN2wCTeS5ZFeI3StdZ9fVJ4oKa3G84efZenVIMdGMujX81FfjSooXdglEgQmM1ivn7BsmoUuDvc3L39BFOUDffbA8oxscxtmtZnQmTpDtsZxd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUNbi2t5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUNbi2t5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866831F00A3D;
	Fri,  4 Sep 2026 06:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502197;
	bh=xWNbi6dM1O5Hww88LwB2lrzLma8+r4CXjrjeYvDRACo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUNbi2t5fOSbhkcJdT7G5UHoMh4OrUErZR651aeUaOf5suybyMdnDikQW4YUrsL5a
	 i45dG4j51OUZ0w4/qVxYFeUncRGBcPZB+58E8WbJ3V8NqLFU/+MffhXSVUYa2nQkNh
	 WPU9CogEIU1xXjjNjahR79NMi/O6IECet291SVhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 122/403] smb: client: fix ALIGN() overflow in symlink_data() error context loop
Date: Fri,  4 Sep 2026 06:58:45 +0200
Message-ID: <20260904045737.611053711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Frank Sorenson <sorenson@redhat.com>

commit 62656b024efc21c3230eade1a847f25871c3d2bb upstream.

The check added by commit 7d9a7f1f96cd ("smb/client: fix possible
infinite loop and oob read in symlink_data()") compared the post-ALIGN
length against the remaining buffer, but ALIGN() itself can overflow:
for ErrorDataLength near UINT32_MAX (e.g. 0xFFFFFFF9), ALIGN(x, 8)
wraps to 0, so the subsequent bounds check passes, and the loop
advances by zero bytes leaving 'p' pointing into stale data.

Fix by checking the raw ErrorDataLength against the remaining space
before applying ALIGN(), then checking again after.  Since raw_len is
bounded by the buffer, raw_len + 7 cannot overflow, so the second check
is an exact post-alignment bounds guard.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -48,7 +48,10 @@ static struct smb2_symlink_err_rsp *syml
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
-			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
+			len = le32_to_cpu(p->ErrorDataLength);
+			if (len > end - ((u8 *)p + sizeof(*p)))
+				return ERR_PTR(-EINVAL);
+			len = ALIGN(len, 8);
 			if (len > end - ((u8 *)p + sizeof(*p)))
 				return ERR_PTR(-EINVAL);
 


