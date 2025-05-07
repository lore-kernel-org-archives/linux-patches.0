Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC6723DE;
	Wed,  7 May 2025 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644408; cv=none; b=jrwHbq+MxqKH3t7n+Yeh46/aByqNhLpOXdUOIbGYGlfjeqMdnTnoJsN7tkHj8mkiosunQZ/z8bkfe11cEMjs07CTr8PuwmBl5aX45CUB0Y3bx3MwIXQl9o3B8jMpo8gcexXM2bYd2NM2ltqAiLiKlt+ncfd5sia7V3yh2LuPApI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644408; c=relaxed/simple;
	bh=y6eC3AAWEPI/aPqLMqho/jD6ES8DATp+dk26x3BzR1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vx9lo4MLYqcNOdjVBZ2l8gMZbQ/eeXYg1Tp1Ocbl963UKam02/5+7SzP97+FWe9PCet+Jjb8jNWDQzQ/hh0ojETH4ryxKCCSHfSITuM7MVvwevXk6lBcBBP8JLLTGfihtkttIeNcVY/IQWVvbc1U84YYWpH4V2mUWbJEmsSTZOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGN108p4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGN108p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BF9C4CEE2;
	Wed,  7 May 2025 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644408;
	bh=y6eC3AAWEPI/aPqLMqho/jD6ES8DATp+dk26x3BzR1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGN108p4+Bm5Bkh4Dm+esuZKnG+GRQrPnnmcob6zK6bJ7bYOkcLjh9lfQ32p6+T+S
	 KYzvIjdLBDMIN41hZy97ZnbGapQOQf1faSuu3phgOeRlWkYIiePAQ56BkAkip0FNCQ
	 mTceRa54vwKgn6ej5saSz7Ptfn22sLdaG3Qq5W5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 034/164] dm: always update the array size in realloc_argv on success
Date: Wed,  7 May 2025 20:38:39 +0200
Message-ID: <20250507183822.257118622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -523,9 +523,10 @@ static char **realloc_argv(unsigned int
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


