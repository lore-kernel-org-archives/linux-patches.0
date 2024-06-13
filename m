Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EA4384;
	Thu, 13 Jun 2024 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282035; cv=none; b=fba269qOooJsSTwQKHnB4vgdjdkT39JYYBu+WTM5gx3/uSnz6DDQWN9gnne7ezMsUn1mxCPbIZzpYgLAfZbxCowVSyd+l9n+5Qbk/wWiZ1DGb9Za8Y5R0V6tyoh1L1Ii1RPXZp/KpjxNVKtXsy2j4AhD/sfj5Cw+NwcEM5k531Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282035; c=relaxed/simple;
	bh=5HNA+wufl/VXthcEeMOHzVRdwtI7yJSSzGAbfO0jJ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPvaXLgD8AC6PsobPWZiu5fIt4UtSB0Nk9enqRe6wju8fDJOELbLfL9POUEu0DVxrgxJFmm0JnMlghE0/GzFq2vraJBSVXDNmrLz499shyD8CyAEWr3wWNJOrLrbCXrzLczonCOvyg8dxM/vSbC23f+pMYGE6P+X8vJudGgynT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXp/eNJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXp/eNJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62688C2BBFC;
	Thu, 13 Jun 2024 12:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282035;
	bh=5HNA+wufl/VXthcEeMOHzVRdwtI7yJSSzGAbfO0jJ4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXp/eNJtUE5cvjEw9xKbHptTAdd6W1gruehq6oXl2JTXB1c2lI7sLb2BAwyg4nBAx
	 IzOMnxyFl8b6Uo/sO+SzuxLpGist9CBPDFvhPwNdsh/SSCj9jrGkBad7yelENnaorB
	 563X59TTSjHZgTMdgWD54xqJQhHZtcBSaaMHd3CU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/402] media: atomisp: ssh_css: Fix a null-pointer dereference in load_video_binaries
Date: Thu, 13 Jun 2024 13:31:37 +0200
Message-ID: <20240613113307.597410955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 3b621e9e9e148c0928ab109ac3d4b81487469acb ]

The allocation failure of mycs->yuv_scaler_binary in load_video_binaries()
is followed with a dereference of mycs->yuv_scaler_binary after the
following call chain:

sh_css_pipe_load_binaries()
  |-> load_video_binaries(mycs->yuv_scaler_binary == NULL)
  |
  |-> sh_css_pipe_unload_binaries()
        |-> unload_video_binaries()

In unload_video_binaries(), it calls to ia_css_binary_unload with argument
&pipe->pipe_settings.video.yuv_scaler_binary[i], which refers to the
same memory slot as mycs->yuv_scaler_binary. Thus, a null-pointer
dereference is triggered.

Link: https://lore.kernel.org/r/20240118151303.3828292-1-alexious@zju.edu.cn

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/sh_css.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/media/atomisp/pci/sh_css.c b/drivers/staging/media/atomisp/pci/sh_css.c
index ba25d0da8b811..feaec4cd96361 100644
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -5322,6 +5322,7 @@ static int load_video_binaries(struct ia_css_pipe *pipe)
 						  sizeof(struct ia_css_binary),
 						  GFP_KERNEL);
 		if (!mycs->yuv_scaler_binary) {
+			mycs->num_yuv_scaler = 0;
 			err = -ENOMEM;
 			return err;
 		}
-- 
2.43.0



