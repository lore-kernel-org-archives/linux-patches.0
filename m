Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22490224B05;
	Tue, 21 Jul 2026 22:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674707; cv=none; b=Dd6TAjgG1DksSPaBNQem7io8lWmAqP1pbYwtMS45o+lKo8Wi41pk3kVyQPZngak6p6ubYKbinnkjEd/7M8eXFwVtI4w/w6U7TrQLoRsQvKzkhK6XyAskmR9UFKovIKq0hq+CU2l8qsCHtoauz0gabfr9CARThX2fDMBtkeRuh4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674707; c=relaxed/simple;
	bh=6bB7eo1Z64+Jq7uOmAZFdER3IaorzBcDMqZxELHfKXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRTq0QzpCZG6JGTi+ieYG/hiiimwWoSz72jbRO/yz16GrIZ1e0BZlDLsFOIzkCy88RnwlUH0MZ7FmtQKpyFiytuqjHvxirIwcPuv0wYQNV7T3EtAoxuEGFGi1kFY4Dsa4v770VZNqL84KXCNoqNpy6nuHxxPauHx+cMTwHy3+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvz5pmhc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvz5pmhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893141F000E9;
	Tue, 21 Jul 2026 22:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674706;
	bh=XvKW2jI9eIDT74Sb0QJsoC3fxH/AEEchTzJ96t++i90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvz5pmhc5XSA7I8w4UDbkedGiEXOYlM63LEQvlcHHFMWVXDkTJD84hCb6dl7JQycS
	 960yu4vYjpHyHPFicUD7aEANqOr156bN0rDJ+2PKXofBels/EwDkPYqF9psye8Pxlv
	 UbmevsObeHHdAZU4HyEny1XoUkOaOSgSIPA24l3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Manthey <nmanthey@amazon.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 643/699] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Tue, 21 Jul 2026 17:26:42 +0200
Message-ID: <20260721152410.255966148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Manthey <nmanthey@amazon.de>

[ Upstream commit e3d9c7160d483fc8f9e225aafad8ecbbc43f3151 ]

When modefromsid is active, parse_dacl() applies the server-provided
sub_auth[2] value from the NFS mode SID to cf_mode without masking to
07777. Apply the correct masking, same as in the read path.

Fixes: e2f8fbfb8d09c ("cifs: get mode bits from special sid on stat")
Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
Assisted-by: Kiro:claude-opus-4.6
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifsacl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -767,7 +767,7 @@ static void parse_dacl(struct cifs_acl *
 				 */
 				fattr->cf_mode &= ~07777;
 				fattr->cf_mode |=
-					le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+					le32_to_cpu(ppace[i]->sid.sub_auth[2]) & 07777;
 				break;
 			} else if (compare_sids(&(ppace[i]->sid), pownersid) == 0)
 				access_flags_to_mode(ppace[i]->access_req,


