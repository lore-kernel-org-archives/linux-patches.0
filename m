Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FFF377A9B;
	Thu, 16 Jul 2026 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209596; cv=none; b=kXcYRMCdicfZlU6/QryI0DJRPbV+cD0EboPCDQHV09qPV5KgYqUxIDcbodEkvSCvgufyxK3CaF3cQhv0yRcLtd3pCYomLhXTpIBbxQ+jxbaP/yzvNq1c3Pdy7ncFCb05tvYPhkmlx6mN68Z4rOS6SDbmgpsGaHMjZ0NX0zyNsBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209596; c=relaxed/simple;
	bh=0gagzX9wyw54jUJVbgm4A0RZ6ccF1w5cWoVuHGfn4sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otzcgGien6YLNWVZOE+vhtujheizowzqEnaJAUjtjJz5t8Z4t9b41lFjMcsTO96cKX3rgdmP4G4F7E0fSuMSbilTP20eVg0xnHbaRnxTmsN5fXxRvwEu6dxLddZOW3pzx5XDs7Gi7v1/JsLb56U830biR1pQHFp+8ErDzpwxQqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXxjYzQ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXxjYzQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF251F00A3A;
	Thu, 16 Jul 2026 13:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209589;
	bh=RQfSZsIYfBcM7ANCqgmwsVk6SWhVsvEnZ0qlPm54iUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXxjYzQ9gy6CnylRIzm8LNlL4LeuMUs3L9btESuZy4WoqJnK4CNtl5XX2vb7brztP
	 ZgIjdKB3Og+6XhLgk7YRvD8Vf9xspYzrM324m5WxeG1Qp1SA8shz6jnd/a6j6byy8d
	 8UCTF3zPq0W+QM+LWVvaVPxcP+MdFMn4Kn/1Ulxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Manthey <nmanthey@amazon.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 242/518] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Thu, 16 Jul 2026 15:28:30 +0200
Message-ID: <20260716133053.114802855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Manthey <nmanthey@amazon.de>

commit e3d9c7160d483fc8f9e225aafad8ecbbc43f3151 upstream.

When modefromsid is active, parse_dacl() applies the server-provided
sub_auth[2] value from the NFS mode SID to cf_mode without masking to
07777. Apply the correct masking, same as in the read path.

Fixes: e2f8fbfb8d09c ("cifs: get mode bits from special sid on stat")
Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
Assisted-by: Kiro:claude-opus-4.6
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsacl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -889,7 +889,7 @@ static void parse_dacl(struct smb_acl *p
 				 */
 				fattr->cf_mode &= ~07777;
 				fattr->cf_mode |=
-					le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+					le32_to_cpu(ppace[i]->sid.sub_auth[2]) & 07777;
 				break;
 			} else {
 				if (compare_sids(&(ppace[i]->sid), pownersid) == 0) {


