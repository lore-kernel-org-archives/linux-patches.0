Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3304D1798;
	Thu, 17 Sep 2026 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671178; cv=none; b=eJCwK999nr7PgVNrgkLjtMbFtVxQ4IZcQogWe0mf6MLWDf1g2gq/699aAOFy0dtnaAptqJbjNLLV2kCmt0rCWCZv8pf7r08yl+xRVttzCJWm662QM+YBUQ/p148nXxRwIW/tnCZuLQWp0PuVonfQOSrIHsbdbJ/Q1+p908StfKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671178; c=relaxed/simple;
	bh=Y631aeT12PFKVBcnexxP6wM0NlYgSukcHbf8eIqCxdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dc66RITgGvNK+/G/DuVjGoqWO8NXviWJ0Ep0+6vijUdKe6qmd3KCEAXvtSMvyl1sOLg+KaJ7yRHJ8d4Q4jF/Sgtd0KqiYT4wWCK6+XUeLZ5/nBrDk5H7M/5iyl0duVy61hrejnqSduT5Rc1Hu9NsBN+BEmLcivKVvWTgd43TLn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wssz5SRb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wssz5SRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0943C1F000FF;
	Thu, 17 Sep 2026 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671177;
	bh=y5U24j/2FLyT8snMXQo2UcZ250biiC5MDEfn2ety7cA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wssz5SRbvoJRMsH294O8q815ASzLawJU9h66hLxWthEm5T6HnpUjvTm6ZBXE4/FCR
	 uDMXVmnGjWlWMqwR/DnR2ComgIts0UwIV6s1HYh07FJnP16wx6aBVjyddhIXsP30CT
	 nUTt8yaeQofCqqXOLzHqZLxo3ijjHwQkNHEIhSJ8=
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
Subject: [PATCH 6.12 0892/1102] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Thu, 17 Sep 2026 16:13:55 +0100
Message-ID: <20260917151602.977082641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

commit 6bd360447941357e959414a525aa62576a448116 upstream.

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFLNK == S_IFDIR | S_IFREG).

Clear S_IFMT before setting S_IFLNK for native and SMB1 symlinks.

Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
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
@@ -824,6 +824,7 @@ bool cifs_reparse_point_to_fattr(struct
 		break;
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		break;
 	default:


