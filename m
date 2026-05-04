Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A977B3DEAC5;
	Mon,  4 May 2026 14:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903693; cv=none; b=ovXHA5/duh/iHDBq0sjb7yxX38fRi5VFcZGB6py6IXUaOcbWDPH3zaYUVrJIq4TORby6NTL/fVLvD7NJDqGY4Q+rDKaO/LIhwiyRddWmI+2GQxon7qWgGcvpA3LKiSBM2pzk/42y/3Pqfn3Xc2nKmeUCzDsgDVNtMZhvoujq0Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903693; c=relaxed/simple;
	bh=fxgdKJWQj6gx42yh6c5t1wlIFrJ/bBsQW4oYoGUuBIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6MfuuQh40gVh2DTGnuqBGlz+Z7xBPPA862jOc9rEbM3NH268ghSY4szBEmGvTzUYiMQA1DSY81W/Y5aGhCiyXwoHpAr13bUspUnLPY6CPMD/HdD4k9JDuFDfHyJp9t3KwMelibajXeWwA1/FF7wbbxp4QdLAa1Fy85v0nB5OaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpfkmS28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpfkmS28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40263C2BCF4;
	Mon,  4 May 2026 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903693;
	bh=fxgdKJWQj6gx42yh6c5t1wlIFrJ/bBsQW4oYoGUuBIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HpfkmS288dyxtfAWqaDeT1TVXAtE3vC5mF73sc/8QsHVtQOtWpp45pNpt8WrlQh+g
	 z+LDKt037B0LSbB7O3TKfsLe+VgoUidoxoCeDY16ewO/4BlGmZpXEDUbXr9jvWyqXP
	 qYaQl0xHVr/qVhSy9zXJtY3Uy4/DoYQtSA2WUWNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 026/275] Input: edt-ft5x06 - fix use-after-free in debugfs teardown
Date: Mon,  4 May 2026 15:49:26 +0200
Message-ID: <20260504135143.910894780@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit f5f9e07060519e2287e99019a6de1eb3ebb65c37 upstream.

The commit 68743c500c6e ("Input: edt-ft5x06 - use per-client debugfs
directory") removed the manual debugfs teardown, relying on the I2C core
to handle it. However, this creates a window where debugfs files are
still accessible after edt_ft5x06_ts_teardown_debugfs() frees
tsdata->raw_buffer.

To prevent a use-after-free, protect the freeing of raw_buffer with the
device mutex and set raw_buffer to NULL. The debugfs read function
already checks if raw_buffer is NULL under the same mutex, so this
safely avoids the use-after-free.

Fixes: 68743c500c6e ("Input: edt-ft5x06 - use per-client debugfs directory")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/adnJicDh-bTUaWXP@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/edt-ft5x06.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -829,7 +829,10 @@ static void edt_ft5x06_ts_prepare_debugf
 
 static void edt_ft5x06_ts_teardown_debugfs(struct edt_ft5x06_ts_data *tsdata)
 {
+	guard(mutex)(&tsdata->mutex);
+
 	kfree(tsdata->raw_buffer);
+	tsdata->raw_buffer = NULL;
 }
 
 #else


