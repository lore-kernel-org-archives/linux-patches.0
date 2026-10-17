Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB42391512;
	Sat, 17 Oct 2026 17:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256569; cv=none; b=WO+NE4avbHLMKIBJ8i66j6ANjqveZMW+gwm31S4GhEUJ92L0pqZnJjBEif0IaGn2zs26VVeASRtdojJ0WbBXfQBXsHEIxprPDYdH8fv2pnTCOfx8E/iTJrvhAbK2U8vgxc1eehhtQKWgw7mG9VLYHYCJx48MW97YkyIenNquGsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256569; c=relaxed/simple;
	bh=aN4FLCTOeVhw6ZP9wB7CkRRzl5GiV4AVE7Gy4VH6Ulo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTGSqbjyHxBRhGtoXhvSOzTzrR4U02xAVof3mGjf7VprEjAggk8jZlF5x3SJetGBimJ9FUkw6F3JNwt0ZNFQZAAz2hIMnwn7o03FdHOTQxH29jc7sTNgYOCdZIGwlWswq6w2EQir2Qzoeg7PBnCj5R9U1XgzEcoib1VqBc0e3NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RW/8B8CE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RW/8B8CE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20E41F000C4;
	Sat, 17 Oct 2026 17:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256568;
	bh=mALh3UsUq0giDUh3pUV9O2/XecPjNW1hHh5fT4u6YfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RW/8B8CEfFEFZBAis23lj+2dbnFVfKQcWmdUOfNkMyyoHdu+5k4TIWoN/TNhd8J35
	 Df8+AXfBWR8qAidyrboKfzTVqqVZvVaQ3vXRaNHgmfCIsHrtcH0bIkGyZcA7HQdyC2
	 SOk/TNGrflyP+nCVJKUP4Ush3Knzz7tXKHD4GkD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: [PATCH 6.6 0279/1674] tty: vt: fix memory leak in vc_allocate()
Date: Sat, 17 Oct 2026 17:42:31 +0200
Message-ID: <20261017160438.278457043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit 5b114bfc1dfd88f9d50822d532f7f1fce0f7388a upstream.

If the screen buffer allocation fails in vc_allocate(), the error handling
path jumps to `err_free`. However, this path fails to release the unicode
screen map attached to `vc->uni_pagedict_loc`.

During the early stages of vc_allocate(), the unicode screen map is either
newly allocated via con_set_default_unimap() or shares the default unicode
map from a previously initialized console (which increments its refcount).
If the subsequent kzalloc() for the screen buffer fails, the err_free path
frees the vc structure but leaves the attached uni_pagedict with an
elevated refcount. This results in an unreferenced object memory leak, as
the reference to the dictionary is lost and its refcount can never reach
zero.

This issue was discovered by DevGen (an automated virtual device modeling
fuzzer based on Syzkaller). During fuzzing with kernel fault injection
(failslab) enabled, the fuzzer forcefully failed the kzalloc() for the
screen buffer, exposing this error-handling path leak.

Fix this by checking *vc->uni_pagedict_loc and calling con_free_unimap(vc)
in the err_free path before kfree(vc). This safely decrements the refcount
and releases the dictionary memory if this was the last reference. The
explicit check is added to maintain consistency with other callers.

Fixes: 34902b7f2754 ("tty: vt, get rid of weird source code flow")
Cc: stable <stable@kernel.org>
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20260803144556.163856-1-25181214217@stu.xidian.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1109,6 +1109,8 @@ int vc_allocate(unsigned int currcons)	/
 	return 0;
 err_free:
 	visual_deinit(vc);
+	if (*vc->uni_pagedict_loc)
+		con_free_unimap(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return err;


