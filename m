Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7F321312A;
	Tue, 12 Nov 2024 10:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408180; cv=none; b=stlTVlyLiBqQ0DjkI7qkBR+1QXuFrWKoKstuBIV8NqzI8bHMRRelmeBeL4znJ2niAnq7FMtqsi9dKq3VsoUV3dRnNQdH/p5RjPlBHnbLCOXFO1DHa94nYwe8V0ZzfDOR9Ildk4Hsa1u2itrZVyZMdUt9uG7UkDarWmj3CanyRuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408180; c=relaxed/simple;
	bh=gjPp3pwbweBpSmLGasau3o1OO0c9mrlMXYh7jeQgd38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWuH4cx8ttqUU73NnOKd3xKYpyD60PzWjYlKJdr57InXFtyaWNMfXFYoKQyikpeTjositcCNlCvL+MnRByTCZveo+R9NKK9/78n766KGn2yn2tbcxHqNP8oC66AVfFLA8gLjWh5OsRVdjBKJ0ZymTElcN1EGE9KAH/e8Muh9RJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5i+RLVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5i+RLVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B2CC4CED4;
	Tue, 12 Nov 2024 10:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408179;
	bh=gjPp3pwbweBpSmLGasau3o1OO0c9mrlMXYh7jeQgd38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5i+RLVzzUiC5mC9RAK5AkWbyAkju/q9yhRVtVIzaK5LDAUMnkzW37r6K/0Qk/Pfh
	 G0mK4cfcR0u220s6aWZuR6mUd+En/3+xUutM/5Ckhy/IU5N/eOnNO9HzQ5Oh/QPeyi
	 ggRV3ZQscNyqBYdrYEKJSNHIxY8Ol6rJ1RKYehpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.11 084/184] media: v4l2-ctrls-api: fix error handling for v4l2_g_ctrl()
Date: Tue, 12 Nov 2024 11:20:42 +0100
Message-ID: <20241112101904.083340827@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


