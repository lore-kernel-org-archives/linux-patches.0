Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212829;
	b=syV5vrATeepO5d2ETRjqVil6zzzJPZOOPfBqGLlKZaz2ATYJFouAexdhlgXhkCctIQdN
	 ar0zF3UBCMufCmB2G3ofdw07vdexl/Wf15NJbG1yHlBPKRd4Vvb1OSrWreJcb02vHr66x
	 uMycCXfu0i/sOHgmAgZDZ/655khXA9p2IV1l3tEQF0/cl5XlSfh75knTi98CY5X1v930K
	 G+//XURDTY/z+76qhdUPOOdPd5oVubCi2OUjEc9BN74D475Qs/oJe0GB4+4v+z5z5SxdV
	 AALTCbNT3jiZsCjFH3PVWtlfHyj+EVl5FsZAWu0LG74SZRUR9FkEykUZPdrdzPB2RlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u+GpYtDx36P5jREV+OAl5gQUmglyOVbWWuHHAvL5V+E=;
	b=01V/kmlDCLr4I5r18YvdbJgtmIDzL5KzFd7FJuzb1vTmBsmHJWao8c+lP0gSeYka9Rkx
	 O5YGOR0YcjaHzxCiAVEzhn5FPwIb9fyDzjZCzOxrbiUsZs3qCUd5011UGSuko91ZK3Gwa
	 d3Ust3P/M/lKX10V7YLigZQBFv1KEdPUrJBSI5Ro1lDMGX3lHFirwCvvVUEPSglc3UhMq
	 kXZBLJ5R9ycCWfi2tt7uYyJ34nFj8SPqBSFwtBWcq9uF8QZgEfzCjxcRGYxqTsOgzdT1o
	 xT6u5ai6AaGAA6wsRq19chh1WZnidvHJWpLC/oqyb8us1BBhfnD1TU3RMQUQrWUoUeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6sin2b8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1747606A31D;
	Wed, 28 Oct 2026 18:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J6sin2b8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE6D1F031E0;
	Wed, 28 Oct 2026 18:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212828;
	bh=u+GpYtDx36P5jREV+OAl5gQUmglyOVbWWuHHAvL5V+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6sin2b8dxzyiY/6xAPvOqRH5FTGPIyvNPIQ+ouXR9n3SIcSKlcnxuYsnhkLv9pZE
	 HOuoQ1CZRILtEaI9Ec6IjnmMpu4szqSSE3Kotrk1CIsVITABMZiiBAxciW0ayV0P9B
	 1x/p9dt0m8i3NDgllXRwOIbicOKfslTMUh/yt2Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: [PATCH 6.1 0289/1887] tty: vt: fix memory leak in vc_allocate()
Date: Wed, 28 Oct 2026 17:39:45 +0100
Message-ID: <20261028170505.805231364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1160,6 +1160,8 @@ int vc_allocate(unsigned int currcons)	/
 	return 0;
 err_free:
 	visual_deinit(vc);
+	if (*vc->uni_pagedict_loc)
+		con_free_unimap(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return err;


