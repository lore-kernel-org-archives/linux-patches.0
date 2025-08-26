Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34A5284678;
	Tue, 26 Aug 2025 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214007; cv=none; b=rcY6eMneh1+XXbHf7LRPtjCJH9FUgezmo3MIJJ+QhmaIGkjXQFqqOVVXoqZ7BXAE7dRlblnGhLdYt5yiSeKZGgWYbUWJa1U3NblzqPPFHbA8Kw1PfIvKf8ZdQeBYo1UUhbJE6IL/39bk6GJuvE8Hok2HrL6EeOyI61iGn+nFLLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214007; c=relaxed/simple;
	bh=lDHwiCOYCZzMV1wDVsY8CUf4uxdvQqtQVf5Uvm8VDJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wsn5tv+4BKs4CBIK/BGLLtbcD6NntsW6UjSrI1rqn7x6QzbR53R8+suWwbiwOw3eA0NKmhD6cGRXPbdvRaZyBqRBW/Lp+0CUJV8WyRkXBUFrny4/tfbkRJYqtKtar4+Ch83z+Nns31ozkegGwzm9cIHpHkD2mngXPO4zvaw83jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1k05KEAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1k05KEAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207FFC4CEF1;
	Tue, 26 Aug 2025 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214007;
	bh=lDHwiCOYCZzMV1wDVsY8CUf4uxdvQqtQVf5Uvm8VDJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1k05KEAvYJswxkrGVe77Mz5N/FOaXXMoX3XsYE90TNkdvxV+raipp1b4pyYXygrH9
	 DavKKJK99EmLSzju2NKktUcbYK+m+occcK9DLNOtkS/HFimJVF9xUTEk5wA0KhYq53
	 4B7/XP/DLaX/+CG45F6LKM7SHQcHj7bFxwwIS764=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 563/587] ALSA: usb-audio: Fix size validation in convert_chmap_v3()
Date: Tue, 26 Aug 2025 13:11:52 +0200
Message-ID: <20250826111007.348135817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 89f0addeee3cb2dc49837599330ed9c4612f05b0 ]

The "p" pointer is void so sizeof(*p) is 1.  The intent was to check
sizeof(*cs_desc), which is 3, instead.

Fixes: ecfd41166b72 ("ALSA: usb-audio: Validate UAC3 cluster segment descriptors")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aKL5kftC1qGt6lpv@stanley.mountain
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index f5a6e990d07a..12a5e053ec54 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -349,7 +349,7 @@ snd_pcm_chmap_elem *convert_chmap_v3(struct uac3_cluster_header_descriptor
 		u16 cs_len;
 		u8 cs_type;
 
-		if (len < sizeof(*p))
+		if (len < sizeof(*cs_desc))
 			break;
 		cs_len = le16_to_cpu(cs_desc->wLength);
 		if (len < cs_len)
-- 
2.50.1



