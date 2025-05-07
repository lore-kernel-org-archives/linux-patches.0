Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE6E1DE4C4;
	Wed,  7 May 2025 18:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643470; cv=none; b=ktQ22rZh+wzluiLuoZWJltYjt/AQCo30sb0kTdurzETWHVGZff9+X+64USYrNId4U918tFLYQm7XgL2Shx7wDjhzr+Y+FC/zGwBs+tbaqFhoPVFkeJomJQparMmAkjF3v/TbhsgyUo0mOuBsvxnQ1Ek0kcCvIfaANZbuHSf46qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643470; c=relaxed/simple;
	bh=yNlzM0a8qzw31Q1j9nei2fTBjhJ98ooWcfMZFxHTkBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sW199Y1zxZhcugR+u5ccs4Y2jEChuBZyuK37apRDpjFhWm04xLe8E6DErLAvqSc+x5c9Gf4sZu1G0f/QrSl9r2qVC7dV0NPTOykgnAZ3FykqbEfJTQ9sZZRVcN+GG4G6x+9eztRpjpGSayCUETXB8P5wDFM6erL6LPjKXLbfMSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJUffbJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJUffbJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E637C4CEE2;
	Wed,  7 May 2025 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643470;
	bh=yNlzM0a8qzw31Q1j9nei2fTBjhJ98ooWcfMZFxHTkBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJUffbJ6PQpnOZqs6x6DQt3+oTM7TyukUf9H0NE3nHFCCFM4wao/H+IlQwuUXS/by
	 iaStl7pDQwUPMrQYDS4lcwHaY47HVUxuzYzs/+U5VAjgDcalNodRBuJQ2MmvdoHfo4
	 gMpROCBWdA5L2p7e0bCE08HYrlHCTbmoksMe7rWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 15/97] dm: always update the array size in realloc_argv on success
Date: Wed,  7 May 2025 20:38:50 +0200
Message-ID: <20250507183807.602111045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -502,9 +502,10 @@ static char **realloc_argv(unsigned int
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


