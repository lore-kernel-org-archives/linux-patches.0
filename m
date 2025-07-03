Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CA21AAA1C;
	Thu,  3 Jul 2025 14:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554419; cv=none; b=NCB+vi02yZxJj32VM911wDcNX0vSUKfAdaAaWjXhy2Q0D4vKq1el4GuCBzLZfDno6ko++oyYAyeCuE5DXA7eLEzN3Ikm13BKutMjjqP65eoMcxGQN6JIdXNU7TfwXQOQJ1WN/jrYEArx/FpW+OPykI66U0/b6wG/PO6OQlJW0Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554419; c=relaxed/simple;
	bh=uu2VlWvUkrbRgBXrvFMfCoAFqClTZ3H0HboRy7h5fwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0xqM/hap63ScE0zrIW6LN2Wbu16G7INCAaYJ/t+4PiNijkixHG8KM5xpua/sNq6ike04reQBC4+r8Gs4A/leGkiAtM07FOlFSIIcOzcGFvWYSfFX4Pkse6WbUvHfwGig+U7ZAG8N6UysOlFDbu4CVaK/1Mj8WUIMSxdmIgcEQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8Yg7v0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8Yg7v0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32375C4CEE3;
	Thu,  3 Jul 2025 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554418;
	bh=uu2VlWvUkrbRgBXrvFMfCoAFqClTZ3H0HboRy7h5fwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8Yg7v0oKP2D5LrAtPFpiSYMs1PWzupXdUxLMahEMZ+qgQrHInJaljVRtM3yzge6l
	 EVyrOQ/HycNDvKsgUhJFCE1pLRx3dWx1PtPlHzXjutKKkvyBUSiNyeGrSgQhCxu82X
	 NSZadipRQp2YkNygng1nYfn05JQCpJDIM/pr80Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Penglei Jiang <superman.xpt@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 181/218] io_uring: fix potential page leak in io_sqe_buffer_register()
Date: Thu,  3 Jul 2025 16:42:09 +0200
Message-ID: <20250703144003.411401986@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Penglei Jiang <superman.xpt@gmail.com>

Commit e1c75831f682eef0f68b35723437146ed86070b1 upstream.

If allocation of the 'imu' fails, then the existing pages aren't
unpinned in the error path. This is mostly a theoretical issue,
requiring fault injection to hit.

Move unpin_user_pages() to unified error handling to fix the page leak
issue.

Fixes: d8c2237d0aa9 ("io_uring: add io_pin_pages() helper")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
Link: https://lore.kernel.org/r/20250617165644.79165-1-superman.xpt@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -983,10 +983,8 @@ static int io_sqe_buffer_register(struct
 		goto done;
 
 	ret = io_buffer_account_pin(ctx, pages, nr_pages, imu, last_hpage);
-	if (ret) {
-		unpin_user_pages(pages, nr_pages);
+	if (ret)
 		goto done;
-	}
 
 	size = iov->iov_len;
 	/* store original address for later verification */
@@ -1010,8 +1008,11 @@ static int io_sqe_buffer_register(struct
 		size -= vec_len;
 	}
 done:
-	if (ret)
+	if (ret) {
 		kvfree(imu);
+		if (pages)
+			unpin_user_pages(pages, nr_pages);
+	}
 	kvfree(pages);
 	return ret;
 }


