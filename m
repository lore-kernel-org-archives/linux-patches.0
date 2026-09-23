Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6175328A6;
	Wed, 23 Sep 2026 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175314; cv=none; b=pTo9H+HG6vFgGY9SCIpHzXvqrCYLrI43UuUjsTC2zcXgbbxPpKKG5tOcmmEWrah+vgnhUcIrNN4Po89x8Awf873J2Wrxd1UJuRgGj/DSgDltDel+DxRqF/V+7RMukDqiG03bMWJB4DcIG+nqCFInlgcX5T3YCiPGa+dTaCL9hWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175314; c=relaxed/simple;
	bh=iydUURCmBKSHYfK19v4a5L+6Y7ST3aBOdmrxRS5JuC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GdyBJxXh+UzQWtjVDYnfadSMD7mC5DCHDKaIWoiWslVBrpw6t57kmhT4cnI/QOToSTWxUVSbk5qyYI7e1iVCbc5XyhiK76JjByLK9RX0tV87zTRUX4FCk3JZ4LheLEIwKAKK/J9YNQIYQHLDLte3Sb4sZOROYU27zZ98ajF0CQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSe8IgKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSe8IgKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0DF1F00893;
	Wed, 23 Sep 2026 14:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175313;
	bh=molLXTXtqWPmuM0oPWvwY3k75QUK3yrAQyajr5udb9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSe8IgKwCVMOab7UidQ6QGChjcl4ABl6QByEgW9BraeXK0MqiXeD3FlrnMkZ2bXRZ
	 5/2uSY+WL/ruu0xe2e0kmsYe3g/S+qRbwzFczSZdjgHGsLlpmwk52E037eVj1Ie2ZQ
	 xTwzqVUUNnumfmfYtH9D76+ZnG+gvvkG3yP2zNUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Elizabeth Figura <zfigura@codeweavers.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 359/398] ntsync: reject wait ioctls with zero owner
Date: Wed, 23 Sep 2026 16:07:13 +0200
Message-ID: <20260923140652.731707868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

commit 61611481f7b599e0526a3782c626b1a9deeb48bd upstream.

setup_wait() already validates pad and flags but not owner, while
Documentation/userspace-api/ntsync.rst requires EINVAL when owner is
zero. Reject early before queueing waiters.

Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Signed-off-by: Elizabeth Figura <zfigura@codeweavers.com>
Link: https://patch.msgid.link/20260723201301.11826-4-zfigura@codeweavers.com
Cc: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/ntsync.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/misc/ntsync.c
+++ b/drivers/misc/ntsync.c
@@ -884,6 +884,9 @@ static int setup_wait(struct ntsync_devi
 	if (args->pad || (args->flags & ~NTSYNC_WAIT_REALTIME))
 		return -EINVAL;
 
+	if (!args->owner)
+		return -EINVAL;
+
 	if (size >= sizeof(fds))
 		return -EINVAL;
 


