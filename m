Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DAB2144DA;
	Tue, 12 Nov 2024 10:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407837; cv=none; b=YJU1ci0lSXy8XstLbA+PYEe5dN09tu7pjNbVKCaPhKdXT+t/pRLjUo7r4NVvTpue+WQqwZ7p/4A+Ajf3MbkUtUIhXqTmdGl/+9qgXaEEetoyMIFxN2yRdHX6Qsu0xAYZ82o0giFW4LP6mXh3YpClFtw5pTpdkBG+ZGbAPPXMkMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407837; c=relaxed/simple;
	bh=4o6hVegmvJfRIk8tClDKNGsVR7QN8JX4mjhU2CmStN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dadKBxaL0dOEdF8V94h+hKw7euOe8V29gKdprxLulcIS5aebvsGnEj7bCGm6dSVBhXrOZ6BuZ/vCaB1oxzg2HiTpV75v054SGRA4CeaPazAy3J9D+fcsdjDD7Tei9tE6otneXjOdD7k5CCaT++o04CZgpwffldmsuCU5lNzPEuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyCygQx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyCygQx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A637AC4CED6;
	Tue, 12 Nov 2024 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407837;
	bh=4o6hVegmvJfRIk8tClDKNGsVR7QN8JX4mjhU2CmStN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyCygQx9ERAtk1Gl5i6xdCCq6y0Tooo2EarO8Uti6EbhqOjBz/thdBn6ly755LERC
	 PnfqUHn7p7+hzWxPWLWFgyLZtoxd2Gm03dIsTSTslhPXuGZ78gGHe2zMYZpaDYi/9f
	 fBdrbNgOVnSTaUPh2fhOaOcdgS+QDf8TrIVixc2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 066/119] media: v4l2-ctrls-api: fix error handling for v4l2_g_ctrl()
Date: Tue, 12 Nov 2024 11:21:14 +0100
Message-ID: <20241112101851.234837004@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


