Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE623152DE3;
	Tue, 20 Feb 2024 21:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463032; cv=none; b=j/s1q/NwyEZQGDzrD3ykx2VtS5EsqwEwjQ6bJPpMX/atfb9WZPwjm+XVsWSRNysOOIUItnUnAmAxbue8JzqIvhvXE5ofYdea/rBrYlmwUXPa7i7LMBD9BRYyojP0VEHanQUfNcoaJyomNEDfYVAgveuFyKwOFsjhdHQqrvY45vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463032; c=relaxed/simple;
	bh=FXN4SFkEifng+2rNGKALXsfd+mi7sjhBq9c1kINZCh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sk9715gLSUaHSB5Ubd014SuLIgXhR2YrokBKvygt5i9AllRUaFZNbuSaI+yetN/sqemYyCMzjohOt1rx7PasITlUxZxvrYSD2qOjR4Ueo5GT7KVVEp3MSh+s7UxfpKKg1BFkZwN2W87pesKLpUG/ynIpikaGVd8moD4J0BdXeHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHRX+WQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHRX+WQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4025C4166C;
	Tue, 20 Feb 2024 21:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463031;
	bh=FXN4SFkEifng+2rNGKALXsfd+mi7sjhBq9c1kINZCh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHRX+WQNmKK/aTTaD2kc7Ou1Kf7DE9zRyA23GjduVe5oUfru2Yoq7h+COr81tRe0C
	 jbNt212fCmZKk5g6wRB8YzYH9PSOZAJk53LXacnI0iY3z+96RA2uDNKIjb29piUrvv
	 1rIImJeyqlZjNA9cPA0knJ3CEDr9kdc3V8F1EAng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.1 114/197] drm/prime: Support page array >= 4GB
Date: Tue, 20 Feb 2024 21:51:13 +0100
Message-ID: <20240220204844.489497944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -828,7 +828,7 @@ struct sg_table *drm_prime_pages_to_sg(s
 	if (max_segment == 0)
 		max_segment = UINT_MAX;
 	err = sg_alloc_table_from_pages_segment(sg, pages, nr_pages, 0,
-						nr_pages << PAGE_SHIFT,
+						(unsigned long)nr_pages << PAGE_SHIFT,
 						max_segment, GFP_KERNEL);
 	if (err) {
 		kfree(sg);


