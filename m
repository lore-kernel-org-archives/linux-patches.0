Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF4717A597;
	Mon, 23 Dec 2024 16:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970810; cv=none; b=T2gePjMR0NyWMjC7jQZLs4pT8ZeFXvAFQGJq4B3QqTd4WAoV69IO3zXICrOdp/4kaA9HMouS3ofK6Rhi+AwCZI/2cqW1PQUdUkCofeeTOoAOO3NwaY2tdz6dNkaqWAfhM0hu9rI5CQJQ5BO+YzZiyE3Jg0+a9L4Rb7qmCTxNuKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970810; c=relaxed/simple;
	bh=pLiUuSK5gVhVbuCrBDs8FnHsohW4aCO85U3PKNofvxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTIm8VBiBMI2v3x7gYVSpqu8lPLIG6MEO5pDMvOSVcuw4kKv1Dmd0JxKIi0VmbrdOS/lwGgX45e0Ltq+NOnU7LCkXU1nS/MiwT+r3LRT1ZTQHs+sdiFtfFZQVWkvo9Q0k5FwNB2yITaD9qRxy/PXGYnRihXRRORnSHEsKBIIf2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dgj+ryro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dgj+ryro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0929C4CED3;
	Mon, 23 Dec 2024 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970810;
	bh=pLiUuSK5gVhVbuCrBDs8FnHsohW4aCO85U3PKNofvxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dgj+ryroUofuM4i98HUIPonILHAuCxxQ0C8RtcxvGoVC9I6pN5j87L6dK/zPEt3s7
	 7BeY0MPSN9rhw/+eQA5RuGl7J7uRqepDAr6gNEnhAIHGH1S26HFspMFsp3hub5Fg9R
	 SqoibQCJZhUE3PvCSgib9M2QrtIl60nfqPRihuHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.1 76/83] ceph: validate snapdirname option length when mounting
Date: Mon, 23 Dec 2024 16:59:55 +0100
Message-ID: <20241223155356.588766322@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ilya Dryomov <idryomov@gmail.com>

commit 12eb22a5a609421b380c3c6ca887474fb2089b2c upstream.

It becomes a path component, so it shouldn't exceed NAME_MAX
characters.  This was hardened in commit c152737be22b ("ceph: Use
strscpy() instead of strcpy() in __get_snap_name()"), but no actual
check was put in place.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -420,6 +420,8 @@ static int ceph_parse_mount_param(struct
 
 	switch (token) {
 	case Opt_snapdirname:
+		if (strlen(param->string) > NAME_MAX)
+			return invalfc(fc, "snapdirname too long");
 		kfree(fsopt->snapdir_name);
 		fsopt->snapdir_name = param->string;
 		param->string = NULL;


