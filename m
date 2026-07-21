Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78313C1098;
	Tue, 21 Jul 2026 21:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670032; cv=none; b=ZA52hYAqqNIwThqzB4lCGyE8UegaEjLO8bL+2f9K+ORPHlgu8MdvsaKPs1+TZyEbal4W1mhDDCfWNkbFqiW4FSjgjoIq7YQSWo7aONoalHV6rUOO7B20HE/0KtW4UA6XH/vxjbAZgYUhKjXop3z1rSGIa/ijgOlEDdJZjptqVtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670032; c=relaxed/simple;
	bh=q2VXUAhTwnSmDZJSWK2ZLN0AsZxcCAq5VChkubV1aJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+dNlxZZPRam/oVIefUOHdl+bCKFH26Y2cMrw0ayZOrOh5PDgZ5fvhgfL7AKFUrThXX+hfnBI/P13+PkZFr2tYoR/Y3/GdFoG0wqNMT9Yr4j+Aqeb4Zf3LZjOhvBeLzHuhV9aIQJpopi1RXV60jGF3OW3LY/yJQItDuTwr6Vnvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhbzXUVs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhbzXUVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494CD1F000E9;
	Tue, 21 Jul 2026 21:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670031;
	bh=4lWITNrpni26xwKLm9BqVMvCbT0dM45QJ4nBRKkK37A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GhbzXUVsy51LI2giH39fCwmbiQs2lhR89PpYMwy9yeJP4X4oMt1K/7PYP2efXF9Fx
	 bTVMhnt9vBUAxqbz9VAPKrmnYnFy8uKWuF+JSUeXs9jVPkFMffBqmAwmzGF1ZPzgir
	 p/dFDeVF/i9n/is1o7vQYqrDNfJy1suIOso9Y0NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [PATCH 6.1 0778/1067] nvdimm/btt: Free arena sub-allocations on discover_arenas() error path
Date: Tue, 21 Jul 2026 17:22:59 +0200
Message-ID: <20260721152441.975122824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 13fe4cd9ddd0aacb7777812328be525a11ea3fea upstream.

Memory allocated by btt_freelist_init(), btt_rtt_init(), and
btt_maplocks_init() is not freed on some discover_arenas() error
paths. This leaks memory when arena discovery fails.

Add the missing kfree() calls to release the allocations before
returning an error.

[ as: commit message and log edits ]

Fixes: 5212e11fde4d ("nd_btt: atomic sector updates")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260519-nvdimmleaks-v1-1-592300fb7a43@cse.iitm.ac.in
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/btt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -923,6 +923,9 @@ static int discover_arenas(struct btt *b
 	return ret;
 
  out:
+	kfree(arena->freelist);
+	kfree(arena->rtt);
+	kfree(arena->map_locks);
 	kfree(arena);
 	free_arenas(btt);
  out_super:


