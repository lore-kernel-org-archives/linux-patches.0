Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A82153CB;
	Mon,  2 Jun 2025 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875041; cv=none; b=il03T0rkHTSGCLoQsS1M3W+IYKZ2Ybvjp2L/5fgnoCybtcJSsWXuFxoYc8E5i4pv9vCK0JXvJQfncmMZ1G4F6Tup1cBXhxgAgcpV7Tbo7AuYJ7gByHffhKzCUcBbfcpR0VoQgDlKO6VuwmsKghaMIKuLVKpQ4XodmJxLLXbV4Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875041; c=relaxed/simple;
	bh=DdRJA1nrTASAIKbku4dfOKI3fPNxStKCbA2G/jU8BBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gch18xkDlrnXlljs+n35wLM9ypGMx8IBevZav5yr2oX5onRYYwMh3h9BPMplvUtN+p4NdX6YKivR+Nq54MGfAHmUhTjWSr5ll3WcxY81rzKFldFkNMqm6rUXNAiHNFyoBtnU5dLvUan4cDLy6l98OsOpSzCM4eRkzXjAwJcB/Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydZbJlrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydZbJlrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F076CC4CEEB;
	Mon,  2 Jun 2025 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875041;
	bh=DdRJA1nrTASAIKbku4dfOKI3fPNxStKCbA2G/jU8BBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydZbJlrcOBuv/hYo9PLU8XCpW35DTp/1/x8SUfJYNounyLIS04eibOvK7s0yVG7oh
	 95nnP6ggBe8c7jHE/n6c5nB+agN20u9JxokxOm79keMkfXqVHi28Hgt0NoXI0b6fpO
	 46Hu19IYeE2U6vZXoGC5pd4yY071rdmDYd7T9nys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 010/270] dm-integrity: fix a warning on invalid table line
Date: Mon,  2 Jun 2025 15:44:55 +0200
Message-ID: <20250602134307.618308598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0a533c3e4246c29d502a7e0fba0e86d80a906b04 upstream.

If we use the 'B' mode and we have an invalit table line,
cancel_delayed_work_sync would trigger a warning. This commit avoids the
warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4392,7 +4392,7 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
-	if (ic->mode == 'B')
+	if (ic->mode == 'B' && ic->bitmap_flush_work.work.func)
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);


