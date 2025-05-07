Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DD921504D;
	Wed,  7 May 2025 19:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644971; cv=none; b=OFMT+WbLAicAbOIc7BSEf48UnzhGJBN3EYn4jiQTUNkhdeLHcl8+46Zxix4HhpByR6CvHsvNMvCZi5z+7iPsHeQAugVpEmsokYadXHJg0V/f68GCJt50xwKa9CX/dDEbhgYvTxR35CLG39eQfcW14yjsSN5WNfFtVLimtkqJYTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644971; c=relaxed/simple;
	bh=/boOmsE+v4ZFhossTPNaGwLOKLjaItxUSeFtj4YLxps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKWo+ZRaAA5CSpCHa0K5O8V38hwzBz3iwGBOci4fOVR1p7L3RsT0fCKD/S3p7DIWtlOE/Py691H5iu7KC2/+vvEjVtjVIlcFO6I/hkYVuNRgkoZLqUsBjwiE0/LawYqp2uWzYb+X+vD72HIvChv/fbXsHmHJrLvtPasqNACerV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q99wA0rC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q99wA0rC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3209DC4CEE2;
	Wed,  7 May 2025 19:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644971;
	bh=/boOmsE+v4ZFhossTPNaGwLOKLjaItxUSeFtj4YLxps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q99wA0rC9h4gQstSnidBCe8MhLXqfsj179qfgcTAa7Yag9R0Ych77sjeXFfDm1/R/
	 nOvEoOzyfYsR7fEWtsxH9xcwxxUD9XgNwQbdnePyKVUVp92+O5mQ1SVucZRVDO9HI6
	 aMNbAiTdZxcYjHHa381ezWEDl7l6MgBz64FguYkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 023/129] dm: always update the array size in realloc_argv on success
Date: Wed,  7 May 2025 20:39:19 +0200
Message-ID: <20250507183814.470243951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 5a2a6c428190f945c5cbf5791f72dbea83e97f66 upstream.

realloc_argv() was only updating the array size if it was called with
old_argv already allocated. The first time it was called to create an
argv array, it would allocate the array but return the array size as
zero. dm_split_args() would think that it couldn't store any arguments
in the array and would call realloc_argv() again, causing it to
reallocate the initial slots (this time using GPF_KERNEL) and finally
return a size. Aside from being wasteful, this could cause deadlocks on
targets that need to process messages without starting new IO. Instead,
realloc_argv should always update the allocated array size on success.

Fixes: a0651926553c ("dm table: don't copy from a NULL pointer in realloc_argv()")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -500,9 +500,10 @@ static char **realloc_argv(unsigned int
 		gfp = GFP_NOIO;
 	}
 	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
-	if (argv && old_argv) {
-		memcpy(argv, old_argv, *size * sizeof(*argv));
+	if (argv) {
 		*size = new_size;
+		if (old_argv)
+			memcpy(argv, old_argv, *size * sizeof(*argv));
 	}
 
 	kfree(old_argv);


