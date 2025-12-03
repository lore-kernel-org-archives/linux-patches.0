Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC973AA181;
	Wed,  3 Dec 2025 16:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781102; cv=none; b=t+Gcj4V8KmWIayRm9bu7Gh2+AybQP5g6VE57aWXuzMOXA8GBxsBs7Mk0dZeaFH2wmyjps7amF7oHnMHLhy4JoXq8sRzgkfkDJ1W7e1wdzAMKf+3RgoualEmiR0jX9j7GrsbgZJrAOjd1ABsLbwfhSEpAyNB/HfZe2HmwnIVnf/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781102; c=relaxed/simple;
	bh=bPTi/kcJCaN+P/s2btBa+vTgN5Y9FdXl9D2MwcN9Piw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0wPsv7V2sOmpdOMrxoDQgsG2bDJ1vJ9PP7oM5mgLFfrBYr3E/7SW7NwHfyRhxE8K2gsdL6IuCfViB3XS6g45MLre+2pMknrN4uxXrL/JZkqy4NtABV12btUKSnsGOgpkR0P+vzukezsxCiOcVgE15ESMmcLFPhPfI0ZN0cdCjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSF1iyB+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSF1iyB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B67C4CEF5;
	Wed,  3 Dec 2025 16:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781102;
	bh=bPTi/kcJCaN+P/s2btBa+vTgN5Y9FdXl9D2MwcN9Piw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSF1iyB+lFzlpSBrLRpQIvWs8v7VNEm5xUs9H61US3Ssjx35+gl82vubNLvhpKJQE
	 2ZfsyuWsGEYtkxE/0uc42Pn4jJBg5QtjH0TC1krl3Q0+yMCBTjyxJy/2VI6jSxefQ5
	 fgV6s97gVyJhjqCPbLDHvRmz5viIWhquXLORt2bM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 48/93] dm-verity: fix unreliable memory allocation
Date: Wed,  3 Dec 2025 16:29:41 +0100
Message-ID: <20251203152338.297994317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


