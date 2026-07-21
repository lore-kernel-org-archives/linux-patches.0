Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324FA4418E6;
	Tue, 21 Jul 2026 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668381; cv=none; b=Y3w+9NPepoIj3uFQ+LcZOxA1WnWuU4BHUPhZJvuZgVF8JQZJUbrazHtsegm+JB4aTl1/mktZlgrc0yN/ePr52opUwWU0od2iZVYv7jmzcVGXk+qDSfpY7RAdr5/NbVWrmGbMFI6b4TmGAsDfcp1OxryUOUrUTLoMgqQnH0nzDGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668381; c=relaxed/simple;
	bh=TFyndKZKj1ArmmSfbLDFvsV7JcIETKOHXmF2k/0BNuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lf4g8qvGqhjFBdeYKDHpbcZN+1bSLW0Q0j1BEIPiRPI9iukkYQyn3ELsErYKWR49t/O29CK/U+1BnmRdvwlS4X92QwxwZ/gIOWUAXT0xIQMGcJIYtDUoMQpucn0As+9OvHHe/9nYhZaG6mNiT4g4N0kPmh89MQ3nFUVSuSe38PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXP3gqK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXP3gqK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 872C31F000E9;
	Tue, 21 Jul 2026 21:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668378;
	bh=5mphpRG1Ht9YZslsU2ouGxZ/JvGzOCdPdo5g7feubyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXP3gqK2k3aTd42m9wdek4+WyAb/oqi11K+5WFBgtGt9F+PWJlIR743ih0SF/bncy
	 KBPn22L8WpEg5qh+UfyIO3QctwMh11TjEDsFSUVm5VpszwCfQj4CYW8gvMubzjR0iq
	 RzTD1VLi7+lC+BAwGjE6QlRrxJJjsMSf2lMRdQTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Manthey <nmanthey@amazon.de>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0146/1067] smb: client: mask server-provided mode to 07777 in modefromsid
Date: Tue, 21 Jul 2026 17:12:27 +0200
Message-ID: <20260721152427.861434952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -887,7 +887,7 @@ static void parse_dacl(struct cifs_acl *
 				 */
 				fattr->cf_mode &= ~07777;
 				fattr->cf_mode |=
-					le32_to_cpu(ppace[i]->sid.sub_auth[2]);
+					le32_to_cpu(ppace[i]->sid.sub_auth[2]) & 07777;
 				break;
 			} else {
 				if (compare_sids(&(ppace[i]->sid), pownersid) == 0) {


