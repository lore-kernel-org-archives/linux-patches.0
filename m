Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E901DDC23;
	Wed,  7 May 2025 18:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643823; cv=none; b=QU9+Fwxdkoq4GkNEOlREG9ioArLukFs8tig732eYM7vTLwD7nYnVuNu70aiymo3tgeEWka3RPybcO+ATBeBftfwyijmDlxG0237vgqwb/0Ug8HwvDPtbeUM0CI4gEPFztxATDJPfdrzPYkb7rhGuwBqoGSM33rKUoPzNaNZs8Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643823; c=relaxed/simple;
	bh=/LG/14SOcJ9PqBof8v3k9DRHuvbejn1T17hjFMIfYhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFuiKWGVfrH/3GCJtxqmaycnzbctGA0IDBT2lxoNpxIkVGJbPT1jRkZ09uCGKUtzsSkFy+g/F9spjZPn4qNLz9EY3CSlzuaO+fM1adx2PvBaBF1xl3RJ/US/op0MyQYGn0fgZ9FP7BkXxVkVGy7hGDKUUV6tdVGIQ3qCwzH0SyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPi6b2ja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPi6b2ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2849C4CEEF;
	Wed,  7 May 2025 18:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643823;
	bh=/LG/14SOcJ9PqBof8v3k9DRHuvbejn1T17hjFMIfYhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPi6b2jaBjWFg1PEPYy+XRWJo1nIeGMK2W39GdJFF+CGms1/WfRXf4NrOXlIjY9Px
	 no7RiLB8kURpkrxieL5sqESudYKVCbMF1oHVvR5H81HB7eCRDPpuz/gE3nhtC/FtKU
	 z+V4zUFZEk8CIo49bWCl7HNYZsUfpnZVYH3GbZJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.14 029/183] dm-integrity: fix a warning on invalid table line
Date: Wed,  7 May 2025 20:37:54 +0200
Message-ID: <20250507183825.872061833@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5176,7 +5176,7 @@ static void dm_integrity_dtr(struct dm_t
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
-	if (ic->mode == 'B')
+	if (ic->mode == 'B' && ic->bitmap_flush_work.work.func)
 		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);


