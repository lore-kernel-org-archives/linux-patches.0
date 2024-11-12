Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27DF2101A9;
	Tue, 12 Nov 2024 10:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407054; cv=none; b=YX/TIj6Kp/sVe2zxBaBNjG+A2yNwIqWK5GPbTu2bXeNCBTaes6o1TVtZn7VyiUJPhY6pEs/fE+4rZn75HeFKX/fIWzHkd23VwAfJ5MQLSgLCeEfLxri3J0VnJ3aeiwAaP52+0/qrKo/ou7wHJa1Qvw84Pi1G5zqaGB284US1SLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407054; c=relaxed/simple;
	bh=d0deCBXWdsLjIlgGccxH/BZ1zPG2DBVCGDD8yhnbsSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPi+QfpRrccOMIJZrG1UJqTOq/ArsRJnK2xvGzoKTEtljNDSiq3PreUeCoCaDnTaMm+hs7vKPBwORzjwmmY3uvDWo4yluGwdCBB8LphADEVdY64hoZ+Lg7MDNI94Tp99R2Tk4TPxBga2oZvzxXna+OJVy7qzl5jcPBjb0hcqOpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3juIucm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3juIucm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBD6C4CECD;
	Tue, 12 Nov 2024 10:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407054;
	bh=d0deCBXWdsLjIlgGccxH/BZ1zPG2DBVCGDD8yhnbsSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3juIucmit6n73zD9Tuy8fwuuYvQZqzPfPEYwAEkTQ3rUnHecnvdGGxvTuoV9ZNYR
	 6Qn58yafewWH6HLkAdQiogg4nRa/IrKTPgWoyKHxMMOGDv90ugsmHNNj6Odr6awxhE
	 32qf0tUS60FzjPo+ZIJLzSHd63hD2hdGnDqhWIok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 37/76] media: v4l2-ctrls-api: fix error handling for v4l2_g_ctrl()
Date: Tue, 12 Nov 2024 11:21:02 +0100
Message-ID: <20241112101841.198640636@linuxfoundation.org>
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
@@ -712,9 +712,10 @@ static int get_ctrl(struct v4l2_ctrl *ct
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
@@ -729,7 +730,10 @@ int v4l2_g_ctrl(struct v4l2_ctrl_handler
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
@@ -770,10 +774,11 @@ static int set_ctrl_lock(struct v4l2_fh
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


