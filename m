Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED840331A44;
	Tue, 16 Jun 2026 18:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635599; cv=none; b=tGPz9gD/x71gbgNZ+lyQ3eYfJVNOhIGBMpEdnqG2ynOUK1DDZEf5mlygrjbrWKYl66JHQeSdOR6pUh0V5UxujPoKVMFxdqOiWfaWyjEP1sU8bD0DwXjElRyLR6j8l038rxTwDLmVQTD3a3LhBvy6RjNFieeh1/MyxHqfP1aPuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635599; c=relaxed/simple;
	bh=IVWyppFMhOkRhAJPe7IZAmT3VteUndcxWg1+NAINq7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fu/nqZG6h1yUSgE1SBXazJzBg2eAMg7Lkybot8bf+5HClGWP3mIziN9WE0RKUiXiXInxQsutyiN1Fv/vHuEdLnRM9mIZCQ2hoQGc+7JOEnY+EFpG/IZTkJjyVw8Rqq5VAh1+Bhv0JNnuusjXWZCVx2xlkfphna8cIH5Mv7jplco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6FXVdIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6FXVdIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F321F000E9;
	Tue, 16 Jun 2026 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635598;
	bh=5IyWNSZdmAP511lDZ2Am4Zk37xQv10hbNHoXPS2/Yvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6FXVdIW54pTdqOynAis6cT0JU3YwUlD4M9Pm2X07wxj2+292cIODAjf31uK6rf5u
	 SksmMX5jDRqXM0Z1yDb3OfiGBr0dIXw7rdWN2Ru01f3jEeeTUcvQFhWEvFAV9MQrW2
	 1hKpE1klCXZMCZmhpUe02x0/VOdIb3oas3CY3UNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>
Subject: [PATCH 5.10 052/342] hpfs: fix a crash if hpfs_map_dnode_bitmap fails
Date: Tue, 16 Jun 2026 20:25:48 +0530
Message-ID: <20260616145050.672410588@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 974820a59efde7c1a7e1260bcfe9bb81f833cc9f upstream.

If hpfs_map_dnode_bitmap fails, the code would call hpfs_brelse4 on
uninitialized quad buffer head, causing a crash.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hpfs/alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hpfs/alloc.c
+++ b/fs/hpfs/alloc.c
@@ -372,8 +372,8 @@ int hpfs_check_free_dnodes(struct super_
 				return 0;
 			}
 		}
+		hpfs_brelse4(&qbh);
 	}
-	hpfs_brelse4(&qbh);
 	i = 0;
 	if (hpfs_sb(s)->sb_c_bitmap != -1) {
 		bmp = hpfs_map_bitmap(s, b, &qbh, "chkdn1");


