Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D934FC8D1;
	Wed, 23 Sep 2026 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174137; cv=none; b=r9qhXzM/tAIYoz/vEEVWybhaB/8Zl8o+fzjOdNRC1GvtMv/iwZKU16E7rE84INeDaPDMsC6H46zl+8TGYUuqmfTfZXuP81sdS6J2rT4040YfD/EEf/Brm4IaS30lKTGX3/Ka6fK3zaj/wWVHPuLM4ZgVqjpxBpvmNfYS31Fe9eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174137; c=relaxed/simple;
	bh=ZJEsE3Hiui2MoWHkOyaIMoKCOXl9ZQrPIxQ0+ZpIKcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYB90Oqke8O9rR0dXHg/PR+q9FMEpbnHmsxkVQ2OSicnhLbiG2H4yyN4rJVzoqlrFNSihBmPqcm7yJjskkjktPxKIW4GOmCQLfhc4H6f8UGlPlY341esjjsklUU+QEaQ2lqAtLdi9Fe8syCuzCRdyZ7JO/L8BKZqHy4zWHUzm3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QS/wojHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QS/wojHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E15B1F000FF;
	Wed, 23 Sep 2026 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174136;
	bh=j5lz4MDi0E9v7DF2hufhexsyAGnULDss3eUOT6ORlWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QS/wojHD43HR/pGdSxqcvEq6eqQVQNTf+AeaCcCVFVjU3jpHYvlwCTX6nqBxklklg
	 itVCvTnEtIX2Rc0wewVYVs65TFijMo5N3VlMSgyL9WAOGRu6Hd4skY8iMKL/J4RmZf
	 8qf5JLCms9mhg7UvaFKNrAGDKSS1xfDaihaVyFtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Griffin Kroah-Hartman <griffin@kroah.com>,
	Elizabeth Figura <zfigura@codeweavers.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.2 435/438] ntsync: reject wait ioctls with zero owner
Date: Wed, 23 Sep 2026 16:07:36 +0200
Message-ID: <20260923140656.214685961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -875,6 +875,9 @@ static int setup_wait(struct ntsync_devi
 	if (args->pad || (args->flags & ~NTSYNC_WAIT_REALTIME))
 		return -EINVAL;
 
+	if (!args->owner)
+		return -EINVAL;
+
 	if (size >= sizeof(fds))
 		return -EINVAL;
 


