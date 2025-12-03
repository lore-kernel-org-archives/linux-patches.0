Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6232032FA07;
	Wed,  3 Dec 2025 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777118; cv=none; b=Tr8DAvMWnk8quSTW2ZhDB9MABzedbAzchnxwKG/5dhHEPeO2wYdD3SSXaKHu2VEbV/SA9Gl7qD7G/VlaFXQNDkShbYAsiedUM+HreXNpG2DPSGva4WLbC7oCnY+n2YThft7MoTQCZlTkKV6VDpZiF+z+CJFipdMqCdYz5UphCS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777118; c=relaxed/simple;
	bh=wRZxs/4gLxM3mQq7Kl7hc13bEStyFhM/ZXtiDzrUSMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b77iBZAyM6uZB6LBK8b3i9vEOxJxpsIQfauk7TsE0wrIMryIydqrdXj25z0iNHD3lJk6H6B2Sf7X7xh+RmeVfDLz6Y3MLZTnPcM6/NoMNZVHP+TIFj7zIqkYcg34ENSFzCLKzcKuvwg1aadE9hloUX3y0DaU+ysvrBYTjUaPJr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZKEpj4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZKEpj4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE348C4CEF5;
	Wed,  3 Dec 2025 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777118;
	bh=wRZxs/4gLxM3mQq7Kl7hc13bEStyFhM/ZXtiDzrUSMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZKEpj4uxtstRwrDlsfJFgGGt8hw9g47xjn6wq05GN/rg46fc/UZID+/hB+RlRt3J
	 4NIFF9bd2no+mPlBnPX6NfTlwY0uOPBw/rzmmqYp9v2uPv+/AVFGjSKzU5TNUPN8SS
	 d8frktzEzfEA46j+UovbbQX0X0gtN1nbPpihONqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.17 088/146] dm-verity: fix unreliable memory allocation
Date: Wed,  3 Dec 2025 16:27:46 +0100
Message-ID: <20251203152349.682058889@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -320,11 +320,7 @@ static int fec_alloc_bufs(struct dm_veri
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


