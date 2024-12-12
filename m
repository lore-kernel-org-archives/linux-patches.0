Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5A3176AA1;
	Thu, 12 Dec 2024 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023613; cv=none; b=HXG40UkZJQxouig5pflM2+z7Ca8vEshqWYruXF+rZu9BI3P91tTVv2jP178v6kw85K6orOL34lXrceuRq1mZJsUoi81v2L8g40vi4XvL/knf8icpa1WE9sUVodCWVJsjDuvqambbnrtVvriXrLvcREjKrljXoRU7WwsZEqKEAGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023613; c=relaxed/simple;
	bh=kw6Vz1YBUyi11newayDzzmrT0/cYlfKNiXdt22AyFQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAUVTtogTbluodve5qN3mKSQ9Zpuj8z8qFEQgWbcoqOdS+9rS3eBYm5QIUwMEiBQVFyQWTd8qu6/tXEPnQLgP9cwBjWLgQUNAmrLm74Ev7lofmqxEmufNBjG1lYBcWAxMj7xIBc9DJEqjE4JugYmqHgPoQTAG104V4rKN4nDQsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GXiVBWKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GXiVBWKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87489C4CECE;
	Thu, 12 Dec 2024 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023612;
	bh=kw6Vz1YBUyi11newayDzzmrT0/cYlfKNiXdt22AyFQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GXiVBWKYzvS5KSChEirMJPJpIrmcA1T9xZIVuVQkWeeKAGesNFo21mSM46kDYDwTr
	 UEYdhx6R/nQ+fjEMR4DtH75SqG+nduSYEZF4UONWfQf+aZpObYx6X7pVi0aTVzS99A
	 Zgr/GtQejDf4pd06OKJIjA1tknWEI6Ns2tK90Dv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 008/459] ovl: Filter invalid inodes with missing lookup function
Date: Thu, 12 Dec 2024 15:55:46 +0100
Message-ID: <20241212144253.856709025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit c8b359dddb418c60df1a69beea01d1b3322bfe83 upstream.

Add a check to the ovl_dentry_weird() function to prevent the
processing of directory inodes that lack the lookup function.
This is important because such inodes can cause errors in overlayfs
when passed to the lowerstack.

Reported-by: syzbot+a8c9d476508bd14a90e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=a8c9d476508bd14a90e5
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-unionfs/CAJfpegvx-oS9XGuwpJx=Xe28_jzWx5eRo1y900_ZzWY+=gGzUg@mail.gmail.com/
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -131,6 +131,9 @@ void ovl_dentry_init_flags(struct dentry
 
 bool ovl_dentry_weird(struct dentry *dentry)
 {
+	if (!d_can_lookup(dentry) && !d_is_file(dentry) && !d_is_symlink(dentry))
+		return true;
+
 	return dentry->d_flags & (DCACHE_NEED_AUTOMOUNT |
 				  DCACHE_MANAGE_TRANSIT |
 				  DCACHE_OP_HASH |


