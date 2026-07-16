Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5F31ED7C;
	Thu, 16 Jul 2026 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210939; cv=none; b=KTkbFyRCXNZk9306aG0eI+pgT9dSwj0PaiVTxcuXH5rEcP10eHjmgVKJif8svOv+MWgU0RTnC+nOGBbADzJ8vsRBleHR+XRYg5R7iLXpVKun0N8ugFJOE7Dmnx9JD2AWEjn9Izd9Ot8eBphbi6pChmCqx66QOAVECckXjpJiJ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210939; c=relaxed/simple;
	bh=ZI6GWPwulg3vzhpnD02FozoHKIB9qbzb5rR/Mxstf5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dg3cuScK/++RgBftxCZYawz1troprWWmswXczOfXFoIV5jfPJ2oWAXrttBfjGqlScnXmhmtGuHxDsZbLJ2qesqN6l5L34PEdT2UU3jKb4YZcCzevljQwM6Ma/VyFIJf+w/jl9hRAcA2tsNX5oadJTtp1qc3XsiRikrvM9wy+Dj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TpandXZF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TpandXZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435281F000E9;
	Thu, 16 Jul 2026 14:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210938;
	bh=1+YVkPP44UICQCk1Dq/th4nsmjy4AOq9hp5SgwTBikk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpandXZFpg7tKySEtnQzI8Ii1ErW6XXsDHxKpc3LrLer2fZI21lO5LLcWjSz5ObIg
	 peFTxxIgHhwmCsydztgz5iC9qXbXHKatHIs4PEA48918RcSRF3gCZgQrQc1pwe4ZRZ
	 si8kPuiYiKd+RFE5Kj3x8HD1p2sg/UbtItqnU4rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Manthey <nmanthey@amazon.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 239/480] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Thu, 16 Jul 2026 15:29:46 +0200
Message-ID: <20260716133049.991554453@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


