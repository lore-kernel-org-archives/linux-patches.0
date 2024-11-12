Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B272101A7;
	Tue, 12 Nov 2024 10:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407454; cv=none; b=K+3rWzs22kS26vXCjef3ApEIOxQlSKtYG6GIDz8LAn+EhQNovsQg2ig8sFqqbcp1HXfDztGU1BzoTFYMdZOBp4ANIVQCs9IffEmTt2AxOIKT5kNybc7A7KxOMMDdB+RyotXeX35Laocyyfrq0o4St6ADiHk1JE0mo5CBX/9Ne9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407454; c=relaxed/simple;
	bh=pPj3jYbGNusZ2O80Yh6BOu9GFGcxRDBXvgOJbhFNTWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbd1woFWJiuqdTjK5sjM1Koo+D0d0CsiL3UZYPdja2ZsYicQO2A72LWSGM4yeuFFmM/vkMCGGMwPWbljLTgdr4y9U5uEGvg3lOVtSByl8Jc4//hnLdcFhR6OSPEQscP1wPVTyn4N5vBCVEx3O6ueFBXB6KCu1rETogciOMpDFcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAEKpddo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAEKpddo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7795FC4CECD;
	Tue, 12 Nov 2024 10:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407454;
	bh=pPj3jYbGNusZ2O80Yh6BOu9GFGcxRDBXvgOJbhFNTWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAEKpddoXIE7CHsFaGsu7MxIu8B2pxL7fd+jwPjJfcahmyPBjXaZBHEdvtl/IJc4K
	 wa3En94TNsKAg3HL+2ei9dc3wRiz2dkteLc4mmaeGPnoqpnQqiVGOg+ZeRgGou4D+e
	 CF9yVrRG8ioZv0thcRvHWsod3asPrfAt1aRqe3sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 49/98] media: v4l2-ctrls-api: fix error handling for v4l2_g_ctrl()
Date: Tue, 12 Nov 2024 11:21:04 +0100
Message-ID: <20241112101846.138046891@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 4c76f331a9a173ac8fe1297a9231c2a38f88e368 upstream.

As detected by Coverity, the error check logic at get_ctrl() is
broken: if ptr_to_user() fails to fill a control due to an error,
no errors are returned and v4l2_g_ctrl() returns success on a
failed operation, which may cause applications to fail.

Add an error check at get_ctrl() and ensure that it will
be returned to userspace without filling the control value if
get_ctrl() fails.

Fixes: 71c689dc2e73 ("media: v4l2-ctrls: split up into four source files")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-api.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-ctrls-api.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-api.c
@@ -753,9 +753,10 @@ static int get_ctrl(struct v4l2_ctrl *ct
 		for (i = 0; i < master->ncontrols; i++)
 			cur_to_new(master->cluster[i]);
 		ret = call_op(master, g_volatile_ctrl);
-		new_to_user(c, ctrl);
+		if (!ret)
+			ret = new_to_user(c, ctrl);
 	} else {
-		cur_to_user(c, ctrl);
+		ret = cur_to_user(c, ctrl);
 	}
 	v4l2_ctrl_unlock(master);
 	return ret;
@@ -770,7 +771,10 @@ int v4l2_g_ctrl(struct v4l2_ctrl_handler
 	if (!ctrl || !ctrl->is_int)
 		return -EINVAL;
 	ret = get_ctrl(ctrl, &c);
-	control->value = c.value;
+
+	if (!ret)
+		control->value = c.value;
+
 	return ret;
 }
 EXPORT_SYMBOL(v4l2_g_ctrl);
@@ -811,10 +815,11 @@ static int set_ctrl_lock(struct v4l2_fh
 	int ret;
 
 	v4l2_ctrl_lock(ctrl);
-	user_to_new(c, ctrl);
-	ret = set_ctrl(fh, ctrl, 0);
+	ret = user_to_new(c, ctrl);
+	if (!ret)
+		ret = set_ctrl(fh, ctrl, 0);
 	if (!ret)
-		cur_to_user(c, ctrl);
+		ret = cur_to_user(c, ctrl);
 	v4l2_ctrl_unlock(ctrl);
 	return ret;
 }


