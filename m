Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE064CDDE8;
	Thu, 17 Sep 2026 18:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671182; cv=none; b=RH4gg80VayoL3tJCwcx6Nrr6xnXyAp9mPWhnRb7mxHxciRbv0O1RfYNsvXUlsbmJTCoVv9bKGJCmSabspitGudoz1Li3JzQymoaWAd4UVHVbjBJAlGV4ao2Q9x8P5ngbe7ZdQ5mA6n/c5m4UUpNFlwDLiXwEJ2Y6SKXoVj9+bKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671182; c=relaxed/simple;
	bh=HMZYDNWxAAZlKDC6L2Mn7YbrrVLB5KXdJQL6RUZad3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pStd3mQRWmHOXM02LKlKOnLIO8amxboDhrSz0WdbRBmsPaQxL6YFh8GpHSlXWbZ28/XuDZa67nH58kmkxmXcJd8mI/nbZB6nwTEfRLSXhoAWLEfft8gpCtrS0pZwlwiStKXyNO719u269ZQe/laH9zR8tambfHXdPpbeqjGOSDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqVdh12N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqVdh12N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A0F1F000FF;
	Thu, 17 Sep 2026 18:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671180;
	bh=DuA51amfJXlFkfmTDoReOZYD/TzUkwF8qIura98IcRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqVdh12N7is+f6GKROQ8GQsogHkJhAze84J6O3qlP9GeVrMw7Eb5RgRa0VdD+NxpS
	 T2H5NgPUtrjwbQfgLfWo1CLF0qI3qFFcLv0breNK8uZRGwIxKIQHEIL2B2uht0679a
	 KPiY192opvf/n9x/Xx93qEHc/Ktatmljxm81f5LU=
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
Subject: [PATCH 6.12 0893/1102] smb: client: fix file type corruption in wsl_to_fattr()
Date: Thu, 17 Sep 2026 16:13:56 +0100
Message-ID: <20260917151603.006189346@linuxfoundation.org>
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


