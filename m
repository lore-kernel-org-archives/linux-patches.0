Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C294D20DD7E;
	Tue, 12 Nov 2024 10:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407164; cv=none; b=Mn2C60AodkqT6c6FhdceDtULHoBy99DipCbP2xdYhHysrAclhU/XcwRIEzRnRIq8BK6KjE4M20OaE+RQucegbr8d6aG+yRGILjk20Z8+Ez83pM97z43HGgNumbFXCWit5oJkt6ijAqhIIgRXRnKEYlHL3eML8HqMPiob2btUl1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407164; c=relaxed/simple;
	bh=xxsWqBxU4L0OUFgKO6jn/vW3m3ylluqVF+xkB4L1pH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqgkfi8w/bYSj+UJp5XPAz5PccYBek6pcMlLlFLlRAr0vFNNqXjlnZM0JuynJiJMmrLBq95S9ul+rDDtrtuxLm/jMzUKBDA+mE4FltbtA+YsmIWYvmy3eCDeI4MRyc1sjgXRE+iwWY/BCMgbgB0XwSSRBt8ouNMYYZLQglIRmnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGGXQRvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGGXQRvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ED3C4CECD;
	Tue, 12 Nov 2024 10:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407164;
	bh=xxsWqBxU4L0OUFgKO6jn/vW3m3ylluqVF+xkB4L1pH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGGXQRvriW3mb0FHqoCV49jZcNhNqzNr4mjPE1fOPcm+LW+qRIJsiGDLZl2GhJfeF
	 9Q0gWyTvo18WqZ8xabaq4bvozDyiA7YveGK8qhdMNlHD/lXBa7GjRviGV8OrFk8GXF
	 PJC4qFumu6RDKDQCV8iUuwduE1gDMjy/MMiKZXMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexey Gladkov <legion@kernel.org>,
	Kees Cook <kees@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 70/76] ucounts: fix counter leak in inc_rlimit_get_ucounts()
Date: Tue, 12 Nov 2024 11:21:35 +0100
Message-ID: <20241112101842.445821110@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Vagin <avagin@google.com>

commit 432dc0654c612457285a5dcf9bb13968ac6f0804 upstream.

The inc_rlimit_get_ucounts() increments the specified rlimit counter and
then checks its limit.  If the value exceeds the limit, the function
returns an error without decrementing the counter.

Link: https://lkml.kernel.org/r/20241101191940.3211128-1-roman.gushchin@linux.dev
Fixes: 15bc01effefe ("ucounts: Fix signal ucount refcounting")
Signed-off-by: Andrei Vagin <avagin@google.com>
Co-developed-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Tested-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Alexey Gladkov <legion@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Andrei Vagin <avagin@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/ucount.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -315,7 +315,7 @@ long inc_rlimit_get_ucounts(struct ucoun
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long new = atomic_long_add_return(1, &iter->ucount[type]);
 		if (new < 0 || new > max)
-			goto unwind;
+			goto dec_unwind;
 		if (iter == ucounts)
 			ret = new;
 		max = READ_ONCE(iter->ns->ucount_max[type]);
@@ -332,7 +332,6 @@ long inc_rlimit_get_ucounts(struct ucoun
 dec_unwind:
 	dec = atomic_long_add_return(-1, &iter->ucount[type]);
 	WARN_ON_ONCE(dec < 0);
-unwind:
 	do_dec_rlimit_put_ucounts(ucounts, iter, type);
 	return 0;
 }


