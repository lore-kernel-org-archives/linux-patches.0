Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D901A0715;
	Tue, 18 Jun 2024 13:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716183; cv=none; b=afsav2CMGO/ysjNXH008zLDzkaPg+6wn81Ea345r7s9VAcdfX2WA1SPwo0I7Ul1QyWzZeBLc43JfmWBZTbLYhlFEdhc2AnesuU+oghEi6OyXLXjqelwv4R5K1lTeZhQqkgHkG8Baz6sfs8OTVXrGdcp0CTYqne+5DLM0Nkxwfx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716183; c=relaxed/simple;
	bh=cHWV5lOtISfMZrjhofAU9SAxa/0+046OFwakJvImC0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dua/BCMFy0KRg3ZJlTox0Za9DsvmPTN16fuOPgv4ochnt1qBRphAZI5D7hssmAAnz0vWtf+VO01lButuICRbdkoq9wJmu4EE3iD/2rRNaI2WxVPnUJ3kPrDdXC2l4RNECxCJuNh24l9gk/ZuS2yYuYN3mGJV2vLU7e3welna1/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfOfQfRI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfOfQfRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CAFC3277B;
	Tue, 18 Jun 2024 13:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716183;
	bh=cHWV5lOtISfMZrjhofAU9SAxa/0+046OFwakJvImC0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfOfQfRIieK9vrLQXshzs0MpNDZjBm3kul0jVZGRYao2ijilFo/EIltKmNZysyHdb
	 7oPI7mPwlg/Qy3Zpo+pTKZFv1PTp0Gw1i7ukqijbfaxzheVVPE/wERntvJTPL9whYa
	 9Io79ZkITrcfG2fQkmpDPNo2/OhmU2yyo6e0tg1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 561/770] NFSD: Refactor nfsd_file_lru_scan()
Date: Tue, 18 Jun 2024 14:36:54 +0200
Message-ID: <20240618123428.956443890@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 39f1d1ff8148902c5692ffb0e1c4479416ab44a7 ]

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 656c94c779417..1d94491e5ddad 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -471,23 +471,6 @@ static void nfsd_file_gc_dispose_list(struct list_head *dispose)
 	nfsd_file_dispose_list_delayed(dispose);
 }
 
-static unsigned long
-nfsd_file_lru_walk_list(struct shrink_control *sc)
-{
-	LIST_HEAD(head);
-	unsigned long ret;
-
-	if (sc)
-		ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
-				nfsd_file_lru_cb, &head);
-	else
-		ret = list_lru_walk(&nfsd_file_lru,
-				nfsd_file_lru_cb,
-				&head, LONG_MAX);
-	nfsd_file_gc_dispose_list(&head);
-	return ret;
-}
-
 static void
 nfsd_file_gc(void)
 {
@@ -514,7 +497,13 @@ nfsd_file_lru_count(struct shrinker *s, struct shrink_control *sc)
 static unsigned long
 nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 {
-	return nfsd_file_lru_walk_list(sc);
+	LIST_HEAD(dispose);
+	unsigned long ret;
+
+	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
+				   nfsd_file_lru_cb, &dispose);
+	nfsd_file_gc_dispose_list(&dispose);
+	return ret;
 }
 
 static struct shrinker	nfsd_file_shrinker = {
-- 
2.43.0



