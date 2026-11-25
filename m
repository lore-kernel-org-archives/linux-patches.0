Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623669;
	b=iXZZyZGbOAItwFUoPeVygoBlbL3+vkIhOCHDjjwhMqV/iOcJx3p+7F2ZBMmhDC7w/14S
	 HAK34DH6eU4Ww/kTnukj3nwGSx27jawtTuJyaB4q2HpOOzeRH2Osem/gZfit1cMixeSK4
	 go8+JAdhZJ4In0FJVOvdmQfr8wzn0k++AcrsGNDG6qP/NayW92LZweH/1urLQ+ReHra5n
	 Rjsn13wzAYR0O4QSz31kaG40DPvGmiFWVs3mWb/L83URc1Gpbkh7QfHrKlmraUJpKiCD0
	 Q4YNgpjzuKHdSFSW4hRxuLW65NdD/sTPGqv/KQ7Aaw90N2Jo+pzv5S/HlKaDhgLrOYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbgV9badz7z59x86EiwjaNHoH2lZxp8B6wvOnfTOGTU=;
	b=BgYgkZE7IoTcTfK9zvywZRF+CUu+Atin/ftBxoe3s028E02LuMX0FRn9hdM0mERzxq4A
	 6NxIeaNydc3fkp7BustWK3+K0hI470EuyQwbcgsxjnr6IXQXsyeokcJCNrbO+OOu567iV
	 ny4idXnNIpwopHYJR229aPQWX91/ANc37ITSPXrozQcMEMO29HzUyq4V2m5ZGSFJ5Q7cZ
	 y2XwUMWBovpGXBO69QnCgwUnYhm+MMmX1IBJn2hA+AbHpSuo5P+IHg83JKcSbqATq01gq
	 PPgUj/6r6i9gvK7KXOfMikGTookO5YTkH2bc6P8yZfM1n2cyV5s8kWQgtVl0pXbn/fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tx5SBiQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201D5606A333;
	Wed, 25 Nov 2026 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tx5SBiQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50A91F00A00;
	Wed, 25 Nov 2026 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623668;
	bh=FbgV9badz7z59x86EiwjaNHoH2lZxp8B6wvOnfTOGTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tx5SBiQwf7WNDcHjrck/XRCBBw69qCIbB2NQvUPuoW+HYRkPk4ySJu+11DvY/ohij
	 kzT5TPdnmyu3rxVyJLVoHYi/qOZrVZchaHvUfysb34qRVhMqoo8F4jHkNp+wLFa6jL
	 1xCDmyvpJt5tQ6m+bfZSHnc1o0Qu8qOlp9pl7q8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 879/990] dm-thin: fix leak if __set_snapshot_details fails
Date: Wed, 25 Nov 2026 15:37:26 +0100
Message-ID: <20261125143842.605765242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit dfb95816cf6f2f2660af2ec64c65dc204c60b5e7 upstream.

If __set_snapshot_details fails, the variable td is leaked - this
prevents any other snapshot with the same id from being created.

Fix this by removing it from the list and freeing it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-thin-metadata.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1225,10 +1225,13 @@ static int __create_snap(struct dm_pool_
 	__close_device(td);
 
 	if (r)
-		goto bad;
+		goto bad2;
 
 	return 0;
 
+bad2:
+	list_del(&td->list);
+	kfree(td);
 bad:
 	dm_btree_remove(&pmd->tl_info, pmd->root, &key, &pmd->root);
 	dm_btree_remove(&pmd->details_info, pmd->details_root,


