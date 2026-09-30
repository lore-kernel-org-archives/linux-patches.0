Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808F33D25B2;
	Wed, 30 Sep 2026 19:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795868; cv=none; b=UHOaXAOTwaL+puKzLB/E7z4H2qUDI0rlrSDud6nl/XsGuPggZmoGe1wcOTTE4vWQDLDzLTmLnqfclxqtGAx8HV0KkFGrEX3thIZQZWU8/P0GWk3sJLdNo2jm/0VadnZg5Kc1wySd0xLKkzaSHbACNDgfgCUBXX3N0WfDF4gV5qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795868; c=relaxed/simple;
	bh=sL3zlehDHAw5vMmAAJy7C4TNBqEm5yklOLLbTn4imCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMvYsccKgwKogqwZha/TvoouGzOAzMNCGJ197i+DybhXAoVXLelhWROJiZozVnBZC6vARGQB2SAszHWEYLFopE0V2BeAwJctQmhQwhnTL6fll6C0s8VOQt4xZOby28qCf/VzsxOmip2eG5vpZ0OYJn847j0fnRJjyK0wnONzjOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shLEOmxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shLEOmxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15461F00898;
	Wed, 30 Sep 2026 19:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795867;
	bh=NvDh5v6KeUeGn+2fb6tCpf+U9bX+Ho0gehbRFRlx1VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shLEOmxzyQHI1YoxMIKfppaueIdYHqnVkmMqx0wGjdUe3WbLsq4/2Oyl786fKXVSH
	 b+Pmgo9AlFUQFOpStY7vv4eGm2Z6YrVwcYlyh9MPAzg1LRDFPovy/C6+aZluzKnBDG
	 J0uh/RanALbAhb8JdlrArnup8fsq//sSZV18880I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6.6 0667/1193] smb: client: fix file type corruption in wsl_to_fattr()
Date: Wed, 30 Sep 2026 17:22:31 +0200
Message-ID: <20260930152449.058126775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit fa7a2cfcf1e6117fc478cae6809c66c518740969 upstream.

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Clear S_IFMT before the switch statement.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -683,6 +683,7 @@ static bool wsl_to_fattr(struct cifs_ope
 	bool have_xattr_dev = false;
 	u32 next = 0;
 
+	fattr->cf_mode &= ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;


