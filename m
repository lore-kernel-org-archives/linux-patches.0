Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0CE75801;
	Mon,  4 May 2026 14:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903449; cv=none; b=U7zpkIrDE1rLA+5YdzG/DW8aRYsP/R001N1YTGjPUSElQasmRbF5LubGUsj98sa88XuaAjlXjC4fSn54fTe9KTzwf6gN/8rI+BvZmfDIgN4c0f8sV7TKRUJBYulwYx8NEQinDjbDuAU2Ce9/Xb7GqJBcrRjkTYiP5rflaV6mB9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903449; c=relaxed/simple;
	bh=H+EN4AnIptkunN3CefOPh8hm9iUeyQr5a8n3mE5JwfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4spRimKEXTphnYyL4sYR9u3VApDVZGXloy27yRCwc5txTZXe+NsSV3SuWXUtO3zuqGm4MU+hOzj+teAx6qIUZcfEHjcvToWwFakTATwPjHNi782hPwFYyhScmaPfB4lJYh3QzyFJqWl7ZCvUU+dhRPbmpgY4jmy0rj1cg9e6XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n75pHNbU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n75pHNbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E957C2BCB8;
	Mon,  4 May 2026 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903449;
	bh=H+EN4AnIptkunN3CefOPh8hm9iUeyQr5a8n3mE5JwfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n75pHNbU85R0SAmL9SdMZfNunNJiXePw0MSBwLkZR7FmOou+mseYFHBccsg6u+YC2
	 nhyoyYVRAradMbdE9IhkNxqLAs/0xNTTKUPIG77JBZeBd9H06pdqHdprfj9Q3HhNVf
	 UZu8GLb/Vgx3g5jOgsNbls55eNmQmgH3Kacm+1mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 7.0 237/307] md/md-llbitmap: skip reading rdevs that are not in_sync
Date: Mon,  4 May 2026 15:52:02 +0200
Message-ID: <20260504135151.759611026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

commit 7701e68b5072faa03a8f30b4081dc16df9092381 upstream.

When reading bitmap pages from member disks, the code iterates through
all rdevs and attempts to read from the first available one. However,
it only checks for raid_disk assignment and Faulty flag, missing the
In_sync flag check.

This can cause bitmap data to be read from spare disks that are still
being rebuilt and don't have valid bitmap information yet. Reading
stale or uninitialized bitmap data from such disks can lead to
incorrect dirty bit tracking, potentially causing data corruption
during recovery or normal operation.

Add the In_sync flag check to ensure bitmap pages are only read from
fully synchronized member disks that have valid bitmap data.

Cc: stable@vger.kernel.org
Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Link: https://lore.kernel.org/linux-raid/20260223024038.3084853-2-yukuai@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-llbitmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -459,7 +459,8 @@ static struct page *llbitmap_read_page(s
 	rdev_for_each(rdev, mddev) {
 		sector_t sector;
 
-		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags) ||
+		    !test_bit(In_sync, &rdev->flags))
 			continue;
 
 		sector = mddev->bitmap_info.offset +


