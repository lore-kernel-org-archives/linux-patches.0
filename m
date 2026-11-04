Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828908;
	b=O0g+P497kCDX2SZYJfU0+Fe5KpYa0fZR216MkligW4FdW4p+KNB5tbPh+OCaQ7hGJ5G8
	 WNBJTDx2+tj6pEEhnn28RTEXx7gEAkCss3J0nnbKgl9Oa8Hj3bSbjRhJBOwuLWs6fksHr
	 wGPeXuLt/j+VDlwKNWgchtPQ5uSmFJ+Pl7zaH//sbcSXqcewxqKiKeawfnRREuHn9qZu3
	 BAc+ijtBi56dD+IQuLTJG5UeVXG9PBNpzBoENPrc6CvXUa7dQESyzws2aqynU4QZGwK9d
	 LTAbcqg6u2A28iwhf/SJATFDivGbtuO2p+VZPsDxeU7radyz6zX7ROW7i9IR3rPqIvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wMI4V4huViHvdEXBqpy07we5e0+BUihw5GjDWAPReKA=;
	b=gFgfsmEQdvpvy3mh+V4KHGm+zGEOmVWtDNbkPPQ+NHoAkn96Ug/ZdS6MuIikJ8IaENZV
	 +2n7pUIMsi94t4GiP3nSvgBZ+i6Tq84+iE8wqVhqGMrjcNpXM2zQ+aqbtldScNT9qTGH/
	 speE/gVmsuS0GT8MawSTV8vmYcYCo6rcwh94kmPEvz5Hwq3U4UjDhnHxy8pcyumFNSQmm
	 /YtN5j2ZwvFNjz/I6T0KjKPUJFTdY+wdOWqu4JFkbC8IhYfU8Rym5ih+UkbLCP90lWybS
	 jXIjb7n+N8UTU4XswqK5NbgVJc0OTvCy1KrTUyFPhulIg/hF1xnDu6oIJE8KIV11jvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLJjGqJq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281E26072641;
	Wed,  4 Nov 2026 21:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLJjGqJq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707021F0093A;
	Wed,  4 Nov 2026 21:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828907;
	bh=wMI4V4huViHvdEXBqpy07we5e0+BUihw5GjDWAPReKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLJjGqJq3W1sJjD7fgCOBWYdVDy4Hn62X+K5KhdCcXDL97eIyk4wh15bxOTfC7HC7
	 b6JREhq1I/lKY6lDj4T3PB/KPVfM1tgSyJYeR9OyUA6dQaro4d17ubfRMjl6BoaTYD
	 8i7CQAJHzOEZrnM+txzwXDkOetR8l0QKYdLr0eR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 319/547] xfs: fix skipped inode mask handling in iscan
Date: Wed,  4 Nov 2026 16:08:23 -0500
Message-ID: <20261104211047.282001289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 63341d4af16fe850716b454fcd18990590d07d97 upstream.

xfs_highbit64() returns -1 if none of the bits in its argument are set.
In this particular callsite, a totally zeroed mask means that no inodes
were skipped, so executing the if-body is incorrect.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: 82334a79c6eb1c ("xfs: iscan batching should handle unallocated inodes too")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/iscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -545,7 +545,7 @@ xchk_iscan_finish_batch(
 
 	mutex_lock(&iscan->lock);
 
-	if (iscan->__batch_ino != NULLFSINO) {
+	if (iscan->__batch_ino != NULLFSINO && iscan->__skipped_inomask) {
 		highest_skipped = iscan->__batch_ino +
 					xfs_highbit64(iscan->__skipped_inomask);
 		iscan->__visited_ino = max(iscan->__visited_ino,


