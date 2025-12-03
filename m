Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110BE313546;
	Wed,  3 Dec 2025 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780487; cv=none; b=J2Ez6rXjuZxG1OEwj0+RcvAUT76xaNMYxGnP1qvSZ5hBlLaj5VAk5203SzUeiYWD7Tfzr4c1kaEncFBAJG4jlJTim9lxsBZ3c4qhdQ1w+bgaOeabNCOjMYA5kghyWk0oy00N5SX0bKcbH5oFTbROL9XZ7kSrvvkBqdxphsPZaLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780487; c=relaxed/simple;
	bh=0L6G2WPXbBVLcgM+MKxDJd0iJ2j5YUa1eaN3BAtEgTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeGWTeroyl3Z0YNOoebkEUKsqwrYplFGWM+56MfFU4dDeLBBvYaKI4jfCDRFKCAWxBjURstreaAyFp4W5S0WvbxAHwcOZVbRJdJtKJYay4ev30IMr4imtGU9FlpgC/qDkn57sAEkNqzo524Y7GZFNDBEV9ilnDoaCGOiAwVUFfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKeD57Cf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKeD57Cf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701C8C4CEF5;
	Wed,  3 Dec 2025 16:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780486;
	bh=0L6G2WPXbBVLcgM+MKxDJd0iJ2j5YUa1eaN3BAtEgTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKeD57CfO7d3oomNBMBzf8l7fgMjRIDIRN7oVucnxAKLWTA2WIRrHvX3hDxtFGLzM
	 J+t7yIFIGRQdRxB1wnzDX1htEUShtthNv6ARWbntPXEBbFQ8EBEZd99vFSc34F7nUA
	 p3HhAj5BBHU+6uI5WgwfBO0ZC+vYXIOX48Nvjxls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 528/568] dm-verity: fix unreliable memory allocation
Date: Wed,  3 Dec 2025 16:28:50 +0100
Message-ID: <20251203152500.053959947@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -330,11 +330,7 @@ static int fec_alloc_bufs(struct dm_veri
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


