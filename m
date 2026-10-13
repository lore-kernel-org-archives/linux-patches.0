Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7871E367B6D;
	Tue, 13 Oct 2026 12:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895094; cv=none; b=cgFx/Od1/XtPdFJVTZhFX314L60od3zvRt+82dKsxinRUhCzZdl1N6yzoB11bp07L01K3+qDcXSdXRsYbMfYLBAwFev9ao8+pRg+Zlktg9l6T42HkGzYdgeR7+9TkbGzAQqAsCLe9kUS4YoByfz1HHb8kiwfvjFlmNgYpnlhZtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895094; c=relaxed/simple;
	bh=xpiutFsD59SZN4w9qY/qYnH3tGtC7Ra3+7wbyvk/ELs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1MyC1koFotzROu6YwMPa3zfny11YB27/l2lwDUwukARDfkJLrPu8zwgu1eQw5gWy1PeAzxFAQlAnOE/WEIziZ3ELhboaVhnypz1Dcyn/FxYrnYpB2NsVCx3/XGRnAvGE1G+hLJ4i64pNtGQNBdOea68ApFXYVwO/CzOnChEBwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzEMOu+n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzEMOu+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC791F000FF;
	Tue, 13 Oct 2026 12:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895093;
	bh=64ory+kw2m64+wkwNZHfybamTyQht1wsAFYhO4VJIN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzEMOu+nl0GfXUacgUdyLsCPR8uiJi0NqbiNq2SsLwK5EM+TOXtvPrYBrkfPsP5Go
	 5j8na3roA2AAChpqR+9On0VBpXDu91c5OwgKxDfFUdz3iNVIbUPqeEIeLVmSyyocSU
	 syhsSpgRPHN1JmHK2psjTzyDX5OnCZJZIMlar2eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: [PATCH 6.12 159/497] tty: vt: fix memory leak in vc_allocate()
Date: Tue, 13 Oct 2026 13:35:26 +0200
Message-ID: <20261013112911.662514328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1097,6 +1097,8 @@ int vc_allocate(unsigned int currcons)	/
 	return 0;
 err_free:
 	visual_deinit(vc);
+	if (*vc->uni_pagedict_loc)
+		con_free_unimap(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return err;


