Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F1112EBEA;
	Tue, 25 Jun 2024 09:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308674; cv=none; b=jgDl6A7KKbfQuM3X8OKHzbyDZiXY6rkCp1GnwhwDWCAUGIgj6iiVzQF6Zz2EbHZKf7VkWg630i9Xgxbpn1Tb8chx2uJvNuQFFWw9jLSu4RDB5FFGPcECm2hHEah3D7zTSWbqyyX10cQ+11xB5bJKW6bYOwJ9f99g3OiVCDVjETI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308674; c=relaxed/simple;
	bh=vZhC+AshlBeMeSglfdm9W0ERb7B7Upra0hHkejzdZqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t35WWEgLacrER4Jt/nYd9w2vCklRYyI8n8RldiJuuLLL4vHqhCoIik2JA+9ZhCGA3VvSTEW75ageX+fwxnPJ3GKKz9ESt5qPOOAK3+BJusBqJ8/IUqXo9JnY1bvb6PtQTqCj6RGgELURQRQ6O6iNnDTULX1LqVifM9P85TCeCOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/F+URKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/F+URKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16E9C32781;
	Tue, 25 Jun 2024 09:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308674;
	bh=vZhC+AshlBeMeSglfdm9W0ERb7B7Upra0hHkejzdZqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/F+URKUIDkCm7oCdIZGSL9wDFJ1pfuJeq6LzMI8HCe3GGDNi8fFRDGWVkAmmGI8h
	 93JWPMhTdxHbGnfWBsK8UGab4s+c8jLZnbS/qGvUqzMvwvkhNpjRrmtcRAf3mOS2BY
	 GmD469mKoVEySvwsHp137QqUcblCow4LSh7t/FwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenliang Li <cliang01.li@samsung.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 171/250] io_uring/rsrc: fix incorrect assignment of iter->nr_segs in io_import_fixed
Date: Tue, 25 Jun 2024 11:32:09 +0200
Message-ID: <20240625085554.616669633@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenliang Li <cliang01.li@samsung.com>

[ Upstream commit a23800f08a60787dfbf2b87b2e6ed411cb629859 ]

In io_import_fixed when advancing the iter within the first bvec, the
iter->nr_segs is set to bvec->bv_len. nr_segs should be the number of
bvecs, plus we don't need to adjust it here, so just remove it.

Fixes: b000ae0ec2d7 ("io_uring/rsrc: optimise single entry advance")
Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/20240619063819.2445-1-cliang01.li@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rsrc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 87f9aa7cf9255..956e2c715eb48 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1105,7 +1105,6 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			 * branch doesn't expect non PAGE_SIZE'd chunks.
 			 */
 			iter->bvec = bvec;
-			iter->nr_segs = bvec->bv_len;
 			iter->count -= offset;
 			iter->iov_offset = offset;
 		} else {
-- 
2.43.0



