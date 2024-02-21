Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080A538398;
	Wed, 21 Feb 2024 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523398; cv=none; b=oUZqZV/PmFqZbjhf8kCieLCXNfr40Q+rFmsX4n/MwpSfxkCPvVj+0/1qOXrHoEjWZzERkrah30cvNSM802GLDOx18T9GUhvDirb5lEVcZwlCPyVLmKDYSIVFvb0CMzK6Gn6JNoNcn5WZ18DJ592nE2sGzV8e7q7SzRx2l+80Jrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523398; c=relaxed/simple;
	bh=4kfxg9u0mQtEKwHMp1iKGwwqUMySkrUPQgr4CfJuJNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kW3WEA+FD+SwhYb0RDfPiPuzRFJLZJ4hhqGJoP5aBp3OLePlkVdfxiGH3c+P3D8LhZYYuyBBYIiXcHkyppzNU+gtONJNkJfiphvQMkL6J6U0c98sAEqhUgYZrW/S6gAfUdS+oHyg3wUmphlH//N7fX6QqCwsNACrGoCRgilrn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecioJE7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecioJE7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED34C433F1;
	Wed, 21 Feb 2024 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523397;
	bh=4kfxg9u0mQtEKwHMp1iKGwwqUMySkrUPQgr4CfJuJNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecioJE7n/vUFUOOfbesr7A5n+gFk6LNhC4CyNdNqveyx1MmMqOg4Wl85VEw87DIis
	 a1EFtKyAvTi5m/izExEdVMc8ii5q9rAS9mAvHCXuytRgT1YCKug8dIV/evLvUScdUT
	 1Wm8DBFF1KRRmHTtMZfgzhuC4kLM/ba4q1cUo6ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.15 396/476] drm/prime: Support page array >= 4GB
Date: Wed, 21 Feb 2024 14:07:27 +0100
Message-ID: <20240221130022.647455657@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philip Yang <Philip.Yang@amd.com>

commit b671cd3d456315f63171a670769356a196cf7fd0 upstream.

Without unsigned long typecast, the size is passed in as zero if page
array size >= 4GB, nr_pages >= 0x100000, then sg list converted will
have the first and the last chunk lost.

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230821200201.24685-1-Philip.Yang@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_prime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -825,7 +825,7 @@ struct sg_table *drm_prime_pages_to_sg(s
 	if (max_segment == 0)
 		max_segment = UINT_MAX;
 	err = sg_alloc_table_from_pages_segment(sg, pages, nr_pages, 0,
-						nr_pages << PAGE_SHIFT,
+						(unsigned long)nr_pages << PAGE_SHIFT,
 						max_segment, GFP_KERNEL);
 	if (err) {
 		kfree(sg);


