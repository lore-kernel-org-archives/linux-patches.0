Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4663ADB9A;
	Tue, 12 May 2026 17:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607993; cv=none; b=OkxUcPyY2q3aM9bQzeJpfJyOV5Swe5NgU/8CR29j87ijXy3q7FsfDZb8sqib2IgT78aN3pfgExR9y3NJBqmbce06syI4OUys8SUpSeo5ls18D3/YTYAKgLv13SFI79rvNlY3Xvpkpw6UHCUx2y2ummmjyM2EpDwQl+hgHxjK9Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607993; c=relaxed/simple;
	bh=FqC6exrqdww/ELvGgv3C6hoJybnk5rrRXQ50QDs1PvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRepOyGpG4wriZPUwwcZhsHX6WRs6SxYKUnbtBlIKAPqDUlJrB11qyjZ6mDL8jywccn6sT7BimAvdaictUjemsbC18Fyb6XLBhv7ibCqQSqBqoO0Ql7GpHSDaD0EbOfOCVpIrUEsKJsPwkHm5MafjWarny6zr/YifZZXfkjOO2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHCMBPrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHCMBPrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D940CC2BCB0;
	Tue, 12 May 2026 17:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607993;
	bh=FqC6exrqdww/ELvGgv3C6hoJybnk5rrRXQ50QDs1PvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHCMBPrmqZnBJ9JPjWiKaYapKB5yEoIn3pbO+4FCa7Tuc1PgIv6/cQgfg1Uhv1XtC
	 C4oeQBy+fi6U++lmjkEpRlN2DheGpXov1o3MvrlPjP+HC9jzPdfkqicoG8Sy2itNqH
	 pYOSB7ZZLrS2pBUu16lKyBRCWfrx/hqeCEUgXWdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Zdenek Kabelac <zkabelac@redhat.com>
Subject: [PATCH 6.12 116/206] dm: dont report warning when doing deferred remove
Date: Tue, 12 May 2026 19:39:28 +0200
Message-ID: <20260512173935.313272855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit b7cce3e2cca9cd78418f3c3784474b778e7996fe upstream.

If dm_hash_remove_all was called from dm_deferred_remove, it would write
a warning "remove_all left %d open device(s)" if there are some other
devices active.

The warning is bogus, so let's disable it in this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 2c140a246dc0 ("dm: allow remove to be deferred")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -384,7 +384,7 @@ retry:
 
 	up_write(&_hash_lock);
 
-	if (dev_skipped)
+	if (dev_skipped && !only_deferred)
 		DMWARN("remove_all left %d open device(s)", dev_skipped);
 }
 


