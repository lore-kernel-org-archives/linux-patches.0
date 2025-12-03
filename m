Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0F03A1D1B;
	Wed,  3 Dec 2025 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780734; cv=none; b=LmV7UPrX7RmqU2YesTwvbI3VyCVSxsiOw7ZKfKzKjrspOP++O4Px8k0RcNJo9eeHDUFgSfTRIiRr0bA/N5QFg2uI/rsgxSxiQOPlmiHmt5Crkb/ymOIJXWnt2w5YCqctMSEBoK6dYgMot6fNS2H5WgqDxoppp4Lm7sw+W1vFJK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780734; c=relaxed/simple;
	bh=/orQzNU+x7hUGUcBdhAPQ/QgXtL45kjSC0C1wTS/I2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2Fv7IRLGBBLVDz3KJP7+WYreUyNVNRta2d6gsU31D5BddD98YfqRB9hBRB2th255CWxRGhheg5ViZ2znNfAJ51Toq12aTtBd/vvG1YcVVkiGfcckrcKskHu/J9cfM29rEaS7cW4u0bpB3aJpBGmxSv7AqUkJNyvXOIhvdgPmtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPV5phil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPV5phil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1F7C4CEF5;
	Wed,  3 Dec 2025 16:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780734;
	bh=/orQzNU+x7hUGUcBdhAPQ/QgXtL45kjSC0C1wTS/I2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPV5phil0Ceg4y/T11e4gqiIaHEbWopUOgWihel3d6NvB+JUd8iPGm6DeBkS39EiN
	 zs2XPmTF+E61t82o395CaMqYuzdB1HzJSIW1L3MH80AnntEnFgntqUTutIMjirHcks
	 8eXoTFFuRbryXWhy/0HoZqc4I/xogjN+wjtYwS7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 075/132] dm-verity: fix unreliable memory allocation
Date: Wed,  3 Dec 2025 16:29:14 +0100
Message-ID: <20251203152346.072403431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

commit fe680d8c747f4e676ac835c8c7fb0f287cd98758 upstream.

GFP_NOWAIT allocation may fail anytime. It needs to be changed to
GFP_NOIO. There's no need to handle an error because mempool_alloc with
GFP_NOIO can't fail.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -331,11 +331,7 @@ static int fec_alloc_bufs(struct dm_veri
 		if (fio->bufs[n])
 			continue;
 
-		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOWAIT);
-		if (unlikely(!fio->bufs[n])) {
-			DMERR("failed to allocate FEC buffer");
-			return -ENOMEM;
-		}
+		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOIO);
 	}
 
 	/* try to allocate the maximum number of buffers */


