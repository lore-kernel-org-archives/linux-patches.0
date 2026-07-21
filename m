Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D49405845;
	Tue, 21 Jul 2026 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655067; cv=none; b=qCLkk28B2gxiywM/MO973cfqtzViVhuFjx3ZeGFdH4BRHbmOfrje/u37Pc4tTazAEgTHigsEh139CJ77YcyfRWblqrTdvGLQZvTrOFmhPlWzZjLmgYEfOFVc2V3k0ka8hQ6Uc3lJ0mARnJnOFNjpLUCogOOt/nx6UyYATk9ciFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655067; c=relaxed/simple;
	bh=Ge9Dq/RwSkjopRASlBqI1FLmWYd3iT+c2oXSyv3B1RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEL9hl/ykvTHnx0MjgvcJxHLzcBOCtMr8giJiVK0MUa/iPcM/Faf8CF5BtsVFwfqfbhm+d1MtOhow+ggUN8qQ0K9DEeE+QApYLZAKUdgqFThNP3PFKxIuSf1Lu6FI4nSJAcgYly2rrUCCp5pvEZQawYVTIM8GhtvT3f5rmbSDiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiPJP0om; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiPJP0om"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA24E1F000E9;
	Tue, 21 Jul 2026 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655066;
	bh=RkjjNCScmmS6S7FvQ/KLAyA+T8mIxuSSKz9DkaQ/Dk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiPJP0omSATkKAklAVAxfuobD0MD+FPbS99Jf1IlRjflFW48tVskUBlpL9l2fP58b
	 1BBZ5RupauQsPfOly/gvu0m5NaNABFFAFLyBCKTnRMw6DwWEgFOWGQpG8PCn6YK4dr
	 SZj8OK+LtBex0VbhmbgObknk6yx9BLEYTxlxVGa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1890/2077] Input: ims-pcu - fix race condition in reset_device sysfs callback
Date: Tue, 21 Jul 2026 17:26:03 +0200
Message-ID: <20260721152637.301966636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 411b8c4b274737c3bf08e1e025801161603cfffc upstream.

The ims_pcu_reset_device() sysfs callback calls ims_pcu_execute_command()
without acquiring pcu->cmd_mutex. This can lead to data races and
corruption of the shared command buffer if triggered concurrently with
other commands.

Acquire pcu->cmd_mutex before calling ims_pcu_execute_command().

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1186,6 +1186,8 @@ static ssize_t ims_pcu_reset_device(stru
 
 	dev_info(pcu->dev, "Attempting to reset device\n");
 
+	guard(mutex)(&pcu->cmd_mutex);
+
 	error = ims_pcu_execute_command(pcu, PCU_RESET, &reset_byte, 1);
 	if (error) {
 		dev_info(pcu->dev,


