Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C732745E;
	Fri, 21 Nov 2025 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731973; cv=none; b=R6MPPSZStMIFIIKwC9sNB7V8NYiDfR39FMG93haXyU3BCfEwYP5b+a3jIa8GjcIHPXuxif4Q8m87Eusk3C/YbiwTvC42zPLkouwRhEO82D85JDEjWsC0I/9cNSQv8Wh/SL6iiHPSttclXCLBGIa2HsZ/Ume3IH8pMW9g3QK1JC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731973; c=relaxed/simple;
	bh=e9R9ITJ1jSMUxI5pkmYchmOWOlCRwUYROSu0GoibZx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpPuJonnY3yxi0kfyRIrB4KDqxvWhUqyP02MZkgUHk3Y0uQln6rIrqPA2kYsKxb1BzgtKPnfx+s9OtC/EoeJe4DdeimoUcxPDHRZg67qVtM6W4V7dE9j1kvqdCpBfU/UvvnUbigZrHKy8E8w7gJi97ymuAJny8uV+27p1mtWtQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWWVvDWW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWWVvDWW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032F7C4CEF1;
	Fri, 21 Nov 2025 13:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731973;
	bh=e9R9ITJ1jSMUxI5pkmYchmOWOlCRwUYROSu0GoibZx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lWWVvDWWPDovolFVGflLjA8Vnu/ZwhcTDlrVaoPpVhVnqdFCPorVNBdJQzHQrLBxM
	 x/uOzjGlfjU1+ArdsfV/ZUbSq5x3npyNP5s54/VWiii7Tc/GZKJrCHE36jEhqa3Kp1
	 OKW4hwomARcpU7KYvTfvODi5f9RqKt95MHeuUfuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Zilin Guan <zilin@seu.edu.cn>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 145/185] btrfs: scrub: put bio after errors in scrub_raid56_parity_stripe()
Date: Fri, 21 Nov 2025 14:12:52 +0100
Message-ID: <20251121130149.110130783@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

commit 5fea61aa1ca70c4b3738eebad9ce2d7e7938ebbd upstream.

scrub_raid56_parity_stripe() allocates a bio with bio_alloc(), but
fails to release it on some error paths, leading to a potential
memory leak.

Add the missing bio_put() calls to properly drop the bio reference
in those error cases.

Fixes: 1009254bf22a3 ("btrfs: scrub: use scrub_stripe to implement RAID56 P/Q scrub")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2091,6 +2091,7 @@ static int scrub_raid56_parity_stripe(st
 	ret = btrfs_map_block(fs_info, BTRFS_MAP_WRITE, full_stripe_start,
 			      &length, &bioc, NULL, NULL);
 	if (ret < 0) {
+		bio_put(bio);
 		btrfs_put_bioc(bioc);
 		btrfs_bio_counter_dec(fs_info);
 		goto out;
@@ -2100,6 +2101,7 @@ static int scrub_raid56_parity_stripe(st
 	btrfs_put_bioc(bioc);
 	if (!rbio) {
 		ret = -ENOMEM;
+		bio_put(bio);
 		btrfs_bio_counter_dec(fs_info);
 		goto out;
 	}


