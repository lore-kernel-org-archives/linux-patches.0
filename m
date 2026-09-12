Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FCF455622;
	Sat, 12 Sep 2026 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219964; cv=none; b=Ok1oxrjbmFhZ1V8ndPV3RCzunTBAsG4CZXN92malu08jIQjDecKBOx3Sfl2IQF13ZxLwsQnv2tGRacOKIFAfg/dVotpVfyDCdhWRPeLaHNCjfybuCOMEDwCVTr3WU29L64U5OTWIMu7A3E16+lxGxugrKs9VdG6ddB1Mx9KqHjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219964; c=relaxed/simple;
	bh=BcxQja5PqyVrEO6zCCr5P3X4wL2CnRsuQzAND027n94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/0lVUggmXAknsMmALyl0kFLCsJMXNTwv/AGuH0qsUcIgGKEWZLSWjxpLY4uIv4sEHvdYC5JEJE7aVvLK8YaNOei4fwDC+UQDadCJAPERzfIgbHCz1YzsLcyp9Y+EwO8IiWMhf0F5G+vgkblp3cAOetpmYoXXaWQZL6WNyz56bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gt+qb7ma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gt+qb7ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850A01F000FF;
	Sat, 12 Sep 2026 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219962;
	bh=7uvvKgNU5NGUcV9vTjtOVW6BTWs/6KpN8ee7oHdBn7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gt+qb7maJlWYRnkM4l3xn0dnAfn47EzSpjBLkiItyyZ8sCIIOWpo2UwQUzw1P/Cy/
	 VrF0ZF3y+o2DzDc3uZNpn7TqqqleVTTxZ4H+Ss8c3c/MnIw/44kg8yBjH45TUK01he
	 O9yKdVC+t3r1oALBDIFDU5N6UZFol43iin65RJGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0081/1424] smb: client: fix ALIGN() overflow in symlink_data() error context loop
Date: Sat, 12 Sep 2026 08:41:53 +0200
Message-ID: <20260912065609.123426690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


