Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8F21CE6F7;
	Tue, 27 Aug 2024 15:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772782; cv=none; b=dqJcpwCxzIOGlj3jTOmQNtRdHeXoTLVRrmOxa9myt9gqz313wpQzZ+Xi0j/GNPA7LT+AMYH64xfMLzSu+EQMraDl5P1A2Y0urMB0o1lkt2SThd2e8GOgbaJCGd40z4N1ae86yNvKJk4hA8ioJWDKjsK5YO56WaD8SA2vOPe/Oi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772782; c=relaxed/simple;
	bh=npIllw1nxCX7ScM9Q0GJpMrjntKI+/ZuoIRTHwhZE+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyfBGbc1SsOAEDauLQlhLIyCkn0yRYIHyzbVupk6G3r2Mcs64GZ3Sy0e5+x/LMtq+gm4tmHaJhSgyA99RG3SFweUeGbAKqMwGG4QpuizhYnXR8aXpLI7bWCqxqstRe5U9McdZ95+EN7JmooyOfDFNnxkipeK6WNj+VvXzqcy7tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PY3x2c2P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PY3x2c2P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063FDC61050;
	Tue, 27 Aug 2024 15:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772782;
	bh=npIllw1nxCX7ScM9Q0GJpMrjntKI+/ZuoIRTHwhZE+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PY3x2c2Pb8cv3rQlehl/Y0cZSfMVeTnUc/b0vKXdghPf+arbv4slRAHJYniZV1J4z
	 hE/FxPslaxw4ZVSPiUQCpNBCNOKhUEQx12eHACZXbq4YmHZqGJiYwio18ju8uasJCY
	 sWwSxfKCN6Qm+3UkhWLNZu9STMwftpPYL6Gj/xso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH 6.1 318/321] Revert "jfs: fix shift-out-of-bounds in dbJoin"
Date: Tue, 27 Aug 2024 16:40:26 +0200
Message-ID: <20240827143850.362333647@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Dave Kleikamp <dave.kleikamp@oracle.com>

commit e42e29cc442395d62f1a8963ec2dfb700ba6a5d7 upstream.

This reverts commit cca974daeb6c43ea971f8ceff5a7080d7d49ee30.

The added sanity check is incorrect. BUDMIN is not the wrong value and
is too small.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jfs/jfs_dmap.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2765,9 +2765,7 @@ static int dbBackSplit(dmtree_t *tp, int
  *	leafno	- the number of the leaf to be updated.
  *	newval	- the new value for the leaf.
  *
- * RETURN VALUES:
- *  0		- success
- *	-EIO	- i/o error
+ * RETURN VALUES: none
  */
 static int dbJoin(dmtree_t *tp, int leafno, int newval, bool is_ctl)
 {
@@ -2794,10 +2792,6 @@ static int dbJoin(dmtree_t *tp, int leaf
 		 * get the buddy size (number of words covered) of
 		 * the new value.
 		 */
-
-		if ((newval - tp->dmt_budmin) > BUDMIN)
-			return -EIO;
-
 		budsz = BUDSIZE(newval, tp->dmt_budmin);
 
 		/* try to join.


