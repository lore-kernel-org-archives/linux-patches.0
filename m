Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7DE4E0216;
	Fri,  9 Oct 2026 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556203; cv=none; b=gXU1PmxQMWfzVXS8dJObQdrw9MIRTq0u5v3oUkQXCmxdKp3tR3WJV3dMvLv7bTPNA6Ov3QNW+Ihb7PjKhl+7aujs1WzUS2xRK7LLLDaayieFVVJrcb40UAsPKcVibovhyTI9bhdn1E7MRMEqfMWaMaSRbFQrWSYHPdXHqnzC9DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556203; c=relaxed/simple;
	bh=Q4gz3eKj/maavIFWHoP2LCE7BooAwzgl05sb97saBWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fmv2YQdKhvQGF2V+MDAKXDMyrTixDY9QQdcbtu6VgisDQq3UEdwNrLnWE14lfy4q0xBQ91v0Fzpmd2TELgLVyqeoXIUuUbpNSgd1sgVG7aidG0R0gQVCVqZnO8kELfxm908rNnQdaYMqhZcWPj24j/4wVCGyFi3Td/b4uSIMbAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZrYgLc9i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZrYgLc9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E081F000FF;
	Fri,  9 Oct 2026 14:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556201;
	bh=bdf1w/Cpo0YJ/5tCjjoTZP94rSInSsFyDgZRX3qN76E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZrYgLc9iWsrY+QYqCMv9g6UnzXpkM9OzhZi3ayrGDG6LK5y9plzGr6wevoxwmqKvh
	 gED+q+wjPnNcN4lP3z5gu4gP8ynDLLEEJUuVJcS3tqyRaP+2/STQtdL9OxVuDzsJiV
	 WRNdfHfymkaLa0NGdoPxxMkYUQ9qzHtqqSPbdL4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: [PATCH 6.18 190/403] tty: vt: fix memory leak in vc_allocate()
Date: Fri,  9 Oct 2026 16:09:11 +0200
Message-ID: <20261009140956.569205935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1106,6 +1106,8 @@ int vc_allocate(unsigned int currcons)	/
 	return 0;
 err_free:
 	visual_deinit(vc);
+	if (*vc->uni_pagedict_loc)
+		con_free_unimap(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return err;


