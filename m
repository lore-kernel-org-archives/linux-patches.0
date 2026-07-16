Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D3D42BE9B;
	Thu, 16 Jul 2026 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212070; cv=none; b=XfgiKpLsEZCEUkRG3FVPnVQYTw94IcR8RBlr2hAOeqn0Wtom+ql1f9sb6hXx6crBUPbsp6ldQwQGSICSmARQqAmf35FBkS/cw+j6DMouiRmh1/wMKZFW5y98hv18LkUZgxO9lBF2mqhXrAZZwcoRqJBd7rCfiQ/ovLAIcHOVeIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212070; c=relaxed/simple;
	bh=LRVAMNfzk+oNRTmNjWFNbKN3JHeGlDjvBoXIfH03RRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MiH/H18a0vE2V4eBp0on3gXb2DpuEjQKJqs0/DVBTC83MgAJBNOWWAM6nTYHydF5EJBaW07yZgWsTjsu1aidnZ7dbHqY78FT7lJ3M9q7x/LE60LQAQiLGl6QnnwoOKisTJXfjw5Qf0J15uhYAbQcv6TItnHW8EguAA+MG1B3Xm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pRNKBKtR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRNKBKtR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B483E1F000E9;
	Thu, 16 Jul 2026 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212068;
	bh=BKudBQxAtr63v445wXP+NmS5eZmiGeikBdldGG1lBY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pRNKBKtRnhW+VeALjRcChVU6A2Q+4lR6jII2owh/iMFBRmWCAdkT8I820tKxrZMu/
	 tnsxO7zpkx39eNXx6Gv1xZbaSLmaZbEt8rsrxS0nlbMjtIxM86wpXtV2YVLHd8zzzD
	 +UrcvdTXUO1hF6KDSEMnzgB0tRI2Kd0ykkQoJFhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Manthey <nmanthey@amazon.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 185/349] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Thu, 16 Jul 2026 15:31:59 +0200
Message-ID: <20260716133037.522519448@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -890,7 +890,7 @@ static void parse_dacl(struct smb_acl *p
 				 */
 				fattr->cf_mode &= ~07777;
 				fattr->cf_mode |=
-					le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+					le32_to_cpu(ppace[i]->sid.sub_auth[2]) & 07777;
 				break;
 			} else {
 				if (compare_sids(&(ppace[i]->sid), pownersid) == 0) {


