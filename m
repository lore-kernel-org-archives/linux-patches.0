Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE7A446839;
	Tue, 21 Jul 2026 17:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655294; cv=none; b=RG+roEuISkU7fNhdLQrj4sd9vomANSZZX1barxvSKVkb/qDW9Mgc3Ajh6JBu3L4S+KdPeoruPAIyjeiTYNgigk2avzGH/AhtXAWK+yq8+TP3G8PP9YflxQxQKQvlRpcgNRyOYsZHvMvnKg3ZF+Pmownp8hInodHq3BWbK9+DlYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655294; c=relaxed/simple;
	bh=ukdvUkj7dBopYGpHkAfWwM8864zbLH/85x1/ElGN2H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEzplRZ2/8NzW2tEsLOLiLqsHXM9muwGxNZmCwjySICuBTr73wKPtwNUkyt6JTz9Gks79slvKW2TrlnT05HfHWHm5MkFXhWTO9DovSVNeNNoBsHgsXvnKl0xFOVQXJrKRB9LIARBagSWBPlkBQOpW5Jx9bTUVOd5kSle69doXUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HIwISEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HIwISEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35351F000E9;
	Tue, 21 Jul 2026 17:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655293;
	bh=Xs30q2d7asZRmj68EEJ3O5RDbnhgwBNf734qr4Ctbnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1HIwISEBSQcp9OrbkhgVesiGe2yCu6x+N1FSgnWDYToGhh7AVSnm7/rHHffRzMGuy
	 LM+miRxLRFGNwEhXKdYydZPQHOhVWfX9+6kaytUSeVT8uFIKBTegIy4eW6Qbd+rU07
	 YJTNFY6ydnHW3FJtobWxt3P+VA1xObndBYXUc4Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 2027/2077] mtd: virt-concat: free duplicate generated name
Date: Tue, 21 Jul 2026 17:28:20 +0200
Message-ID: <20260721152640.508009569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit caa0ecbeff4f7fbf70f22bd8ca598918bffb1b78 upstream.

Every MTD registration runs mtd_virt_concat_create_join().  Once a
virtual concat has already been registered, the function builds the same
name again and takes the equal-name branch.  That branch skips to the
next item without freeing the newly allocated string.

Free the temporary name before continuing.

Fixes: 43db6366fc2d ("mtd: Add driver for concatenating devices")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtd_virt_concat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtd_virt_concat.c b/drivers/mtd/mtd_virt_concat.c
index c872a8827718..da4277ced4d6 100644
--- a/drivers/mtd/mtd_virt_concat.c
+++ b/drivers/mtd/mtd_virt_concat.c
@@ -321,8 +321,10 @@ int mtd_virt_concat_create_join(void)
 
 			if (concat->mtd.name) {
 				ret = memcmp(concat->mtd.name, name, name_sz);
-				if (ret == 0)
+				if (ret == 0) {
+					kfree(name);
 					continue;
+				}
 			}
 			mtd = mtd_concat_create(concat->subdev, concat->num_subdev, name);
 			if (!mtd) {
-- 
2.55.0



