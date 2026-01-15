Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E052D94A7;
	Thu, 15 Jan 2026 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498608; cv=none; b=hW3mlEFx/L6YHUF8GmnFDGp4fMEld+QhCDNoP5x0OT3KS5dw0uC1qT9/XBlCJQ8FgBn/IEmQZFJQvWKg44fw84EtS1UglY+R03tiJ6C6x4BWzE5Gh2w1H4A91t+c91gM76ZYD5Ab6PFgevTVRlu/8F198Zm7grtZ3ktbUcQhtOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498608; c=relaxed/simple;
	bh=9bUmgauIGTCi4FRzA989/c4lB93afrdvfB2J0SvF2wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxbwm/ezMvBtbe+BzgmHg7GWGWTuswE6dRIK7lwJLMrCPpNf0Oh58i24xDFHwqA8ubIPOcrpVTOeSy4JRaElBvSmFeCTbJQ+JFCsH0lVgOK+/0Y0J3efV+3NSGOySTiK3I68leAMcECtWnfHLOac9gqdfdnMNgPOnicz7j3LfMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iotBB1U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iotBB1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B4DC116D0;
	Thu, 15 Jan 2026 17:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498608;
	bh=9bUmgauIGTCi4FRzA989/c4lB93afrdvfB2J0SvF2wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iotBB1UCvkqt93zLdoCJbZY30uFBSAIxy/FznWpzr6WFAXqNNmNUBtOJJwP6CZbt
	 IoUSdotUEfdu1LBhl5ubpeGOFQJX09QOv8VZ6at8w9XqLJMhpDHhqx3YkOSNTKxFFm
	 nT5dBNC6po2N3bBI8BknqdpaBP1AeDBoGR4BxkbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Couderc <aurelien.couderc2002@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 459/554] NFSD: NFSv4 file creation neglects setting ACL
Date: Thu, 15 Jan 2026 17:48:45 +0100
Message-ID: <20260115164302.894178001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 913f7cf77bf14c13cfea70e89bcb6d0b22239562 ]

An NFSv4 client that sets an ACL with a named principal during file
creation retrieves the ACL afterwards, and finds that it is only a
default ACL (based on the mode bits) and not the ACL that was
requested during file creation. This violates RFC 8881 section
6.4.1.3: "the ACL attribute is set as given".

The issue occurs in nfsd_create_setattr(). On 6.1.y, the check to
determine whether nfsd_setattr() should be called is simply
"iap->ia_valid", which only accounts for iattr changes. When only
an ACL is present (and no iattr fields are set), nfsd_setattr() is
skipped and the POSIX ACL is never applied to the inode.

Subsequently, when the client retrieves the ACL, the server finds
no POSIX ACL on the inode and returns one generated from the file's
mode bits rather than returning the originally-specified ACL.

Reported-by: Aurelien Couderc <aurelien.couderc2002@gmail.com>
Fixes: c0cbe70742f4 ("NFSD: add posix ACLs to struct nfsd_attrs")
Cc: stable@vger.kernel.org
[ cel: Adjust nfsd_create_setattr() instead of nfsd_attrs_valid() ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1319,7 +1319,7 @@ nfsd_create_setattr(struct svc_rqst *rqs
 	 * Callers expect new file metadata to be committed even
 	 * if the attributes have not changed.
 	 */
-	if (iap->ia_valid)
+	if (iap->ia_valid || attrs->na_pacl || attrs->na_dpacl)
 		status = nfsd_setattr(rqstp, resfhp, attrs, 0, (time64_t)0);
 	else
 		status = nfserrno(commit_metadata(resfhp));


