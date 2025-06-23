Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F5B223DD7;
	Mon, 23 Jun 2025 21:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713409; cv=none; b=XziLc3alX1H0m+GS7bsRZjcjMCXEZTohx+QsKj4c8n4JBHIR2ILEg2T8ZO6clIalOXwp1+Q1lxWl9dJPj064e1ThMd1S0FYVlEJMBBuC8QT4rKZhVIELH+a3BsWVxSq18aVpCKdpYo5bj1Hau7IxmQsVgHPV9oY5VIHJz0n1ktk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713409; c=relaxed/simple;
	bh=LhMju5G9g+4JnQY49X3FT6QMxcDKuB2CswnS0kR6H4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID+xWOZ0CN55pfS2YuNJ3HM3s5wMAFOjAVSWTTKkLW5Uty0JiKAajYTHf3uYph4l17O3hiFrRoETYId2tjsNJSI00PIeSpTzDkmXtCYpgEQfSu5jdOdoHgyo+DHR5GL6J+mQeDzZNuFC/N3DivLNU3Im3P/dnxd0HOffYloFONo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IiCGbBtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IiCGbBtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38324C4CEEA;
	Mon, 23 Jun 2025 21:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713409;
	bh=LhMju5G9g+4JnQY49X3FT6QMxcDKuB2CswnS0kR6H4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IiCGbBtzfAOzlIVOMtUgs2XM8f21e6FldKkenXx0g2WcEH0GkuPWWWLGqwXKgFdFZ
	 EfAj9OAbwOLJydF3VgSggg6IXPVIkIUioW3EjwaJx+XtRSn9VCwIXOqW60D7uQ/Hq7
	 tWrMvKGV38QuwqPNuU2BQa0lUG4q+kEHbg6GZkRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Greental <yonatan02greental@gmail.com>,
	Haren Myneni <haren@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/411] powerpc/vas: Return -EINVAL if the offset is non-zero in mmap()
Date: Mon, 23 Jun 2025 15:04:49 +0200
Message-ID: <20250623130637.262043326@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit 0d67f0dee6c9176bc09a5482dd7346e3a0f14d0b ]

The user space calls mmap() to map VAS window paste address
and the kernel returns the complete mapped page for each
window. So return -EINVAL if non-zero is passed for offset
parameter to mmap().

See Documentation/arch/powerpc/vas-api.rst for mmap()
restrictions.

Co-developed-by: Jonathan Greental <yonatan02greental@gmail.com>
Signed-off-by: Jonathan Greental <yonatan02greental@gmail.com>
Reported-by: Jonathan Greental <yonatan02greental@gmail.com>
Fixes: dda44eb29c23 ("powerpc/vas: Add VAS user space API")
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250610021227.361980-2-maddy@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/book3s/vas-api.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index 4d82c92ddd523..bfe52af0719eb 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -367,6 +367,15 @@ static int coproc_mmap(struct file *fp, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	/*
+	 * Map complete page to the paste address. So the user
+	 * space should pass 0ULL to the offset parameter.
+	 */
+	if (vma->vm_pgoff) {
+		pr_debug("Page offset unsupported to map paste address\n");
+		return -EINVAL;
+	}
+
 	/* Ensure instance has an open send window */
 	if (!txwin) {
 		pr_err("%s(): No send window open?\n", __func__);
-- 
2.39.5



