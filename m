Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4010233C18B;
	Sat, 12 Sep 2026 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226880; cv=none; b=EPGJR49+gILsUtpLKhu6PeiHRDZcAZwvguyNMhlMNMdT9ub/r6y3oGcMmjxqcYzd9J2Nn5drUJPdhjB3UigluxaIXf/cCkDbI9LIvuFcY/vNWGw3/VP2nEA15jIODGxTE2f55acvCyAzQO0rQfslamGiLHkGrl+d4SudVdcwVco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226880; c=relaxed/simple;
	bh=TNxe5PikoIZpbxOmxD33gAgRtI5C/UcbnxNrzY9ES2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlulCjdKz1exURiDtpB/tzlLzGUJCDI7w0UmqIiq+7MDbpAtKYyRshwgPcvQPJtsRnFL7/xyFZBBcAmGMEnJO2WKV11jgUvPs1E8h0vBrNgZWTff3381CmCKzS/Nk4vfMtAHnTH5UHKCNsUt/v3JFvgQ8ViGx1kw8uOZ0xEMV88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BueBIbr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BueBIbr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D541F000FF;
	Sat, 12 Sep 2026 15:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226879;
	bh=VR3O8JQ7JYw3i823YGR79MxoupT+V1W4tbJUHPlT6bM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BueBIbr+hiw7zYtfcqRZQ/4UbVtFjyWSAyXgkNQtzbzQSMYgPD/oX07w75Zqzdigc
	 hGN5qXBQ8VKzKRaprWnLK06Y2i1rMO4iY4eXUdQDnIAhD8g0cUPxo2BHUt2Y0OaQ9Q
	 YNKB+8Kg8OySCFyfdRE1DSS5Rdvkg0HMtrVoY5rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 0068/1191] smb: client: fix ALIGN() overflow in symlink_data() error context loop
Date: Sat, 12 Sep 2026 08:46:36 +0200
Message-ID: <20260912065549.688508080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -47,7 +47,10 @@ static struct smb2_symlink_err_rsp *syml
 			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
 				 __func__, le32_to_cpu(p->ErrorId));
 
-			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
+			len = le32_to_cpu(p->ErrorDataLength);
+			if (len > end - ((u8 *)p + sizeof(*p)))
+				return ERR_PTR(-EINVAL);
+			len = ALIGN(len, 8);
 			if (len > end - ((u8 *)p + sizeof(*p)))
 				return ERR_PTR(-EINVAL);
 


