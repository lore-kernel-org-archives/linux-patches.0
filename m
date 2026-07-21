Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1886C44AB6A;
	Tue, 21 Jul 2026 22:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672853; cv=none; b=rNvNYMaHuR5borujLR+lsz0DolIXR8GNKuf5aL7XVFqYOX1vZOicSNDDwVzb4Cg9zrw+Mn6V7pAv7A5AuvpnTBNukW42ILiWlihBi+NLQeM7r3PLpFzx2RvUBZyRI5Pe2h5JS3sBVLViYTjQ4x2p0m1Rj8I94DZ5QLGrTOihNpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672853; c=relaxed/simple;
	bh=/MhIxEX25B2Ag6sEk927r9N35Zz0pRiFHCPXXPwNAxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TbAAtfYNpv2ro0pwlCCOmEeDeIOuGyP97Q/lFpnh7mOhV5XpolBQOp3oY2shF+Dq9Jq9OylhGxVV7TPyWAh6x3uOnPnjxZpVYJosaMoOIMC/epJcBNNrxEidt/0O1pdyi9z20jwKv/ooXIMCWzplspfXniouZ2qPYFQ8wW6i2ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsO5MlY9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsO5MlY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246F91F000E9;
	Tue, 21 Jul 2026 22:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672851;
	bh=jNklT/7nhOQjR/MipxVYM2OivdxU7+FRl6qW9alKITU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsO5MlY9EYFq3m5EAEaQ6vTppd/RvKQzse+4Wk+xM05kj1PKaibQU3UAOMfEa6Es3
	 Ln09xy9eAlQIvkJqXD0/oa4nTPlRt/tZ2ugEEhICR7kjNpkhQ5zV2lI4VTqwzbV93F
	 3QH78eMeLrT386Hf8+VlgByOJTgxkeYnbdd0MUb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Manthey <nmanthey@amazon.de>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 782/843] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Tue, 21 Jul 2026 17:26:57 +0200
Message-ID: <20260721152423.648483052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -887,7 +887,7 @@ static void parse_dacl(struct cifs_acl *
 				 */
 				fattr->cf_mode &= ~07777;
 				fattr->cf_mode |=
-					le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+					le32_to_cpu(ppace[i]->sid.sub_auth[2]) & 07777;
 				break;
 			} else {
 				if (compare_sids(&(ppace[i]->sid), pownersid) == 0) {


