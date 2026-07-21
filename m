Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6566394783;
	Tue, 21 Jul 2026 20:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665165; cv=none; b=OpWnrLZ+DhAdRg3Cf1q67LLCLP1vspzoNhyQpVzx8obAIpjGvAm9vdh4DUdeFyqSeL36FTal7HYUL0dkwPYCennb677DRCZ0MD2yENxj9TAo7vt3wCQKrtnYenIlAtL+7F/6Cg4Y2k5FkbxRTpfb0p9O76PFLEGrc3cUOG/L6oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665165; c=relaxed/simple;
	bh=utxD2elbkoEwz+Px4rUGko3rIjAj7eoWC0GX5+OtTpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXpf94NCqdrxT+0+uRHLNQsFt/TOyqWdBbmHwmNKfcBWvqOmcoJMiv+5/NS1+ZaMbVdrqH5jUvDINoHdphSx66ZApep2eZxyXfpDBVZsuA/ebgUhI/Q6BHLpao21VHtSs6fd5KWpgRFApVUZ50uqfggNS142nJYR09jrgUxIhJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HL1j7ygb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HL1j7ygb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D325E1F000E9;
	Tue, 21 Jul 2026 20:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665164;
	bh=r+8k6ZH01ztCv3TOLqBc2Es3+Xby8xl+ejK6Qdxu7B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HL1j7ygbOSFc4At5MbRadjaKUy6l0CNVKiSJzDU8EZD9/E9p2TvL1OMFXABXZpZLJ
	 VcKeRzcDCdKALShQOw1ECDba9lvmaWDvodQmACiDxbHWPYG0mctpLY3EAV0+aGmaoF
	 Ye6S0j/Omjg/B4Iyg0C3/f08fB4bNABwYOzzAT9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Manthey <nmanthey@amazon.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 0201/1266] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Tue, 21 Jul 2026 17:10:38 +0200
Message-ID: <20260721152446.306020420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


