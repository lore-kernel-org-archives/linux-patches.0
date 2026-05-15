Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FD93E00A7;
	Fri, 15 May 2026 16:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861968; cv=none; b=Fzh6TXwkz8uvZekenxEuGG7IpnIjHRXUQFFwcmaRAkLdlWvOGpXJVVNhUMYDw3c4F7VlssJGs62V2ji+VUqtSas3iPsgSIzCOw7jB0ZIY4skLZjiu/dxtzPdcqxiYy8QWxOGIiqbW5nzGQgp3lyjVji6wB+tBL+mmoiqadqYytg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861968; c=relaxed/simple;
	bh=4pMSBJFFJcecKa6j58PYZxFwOcX33BDPHRdBuyUTCNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7qoDLqQ7G5N+MlEN4fpi3vvUlR+RnfVSPLUr8PrWe668BuSkZryzEYrcLWvLNjDSjGnY9jXVj8nmq+7lWZ6gkBfBVtCg/Qrv+Krw42GOroctlH4/mikK2ZxznpWy0KEepYNV8fBCraOU8jfMcikW5T9aQEkephKv29bEmQVR9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsgED+d6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsgED+d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AF4C2BCB0;
	Fri, 15 May 2026 16:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861968;
	bh=4pMSBJFFJcecKa6j58PYZxFwOcX33BDPHRdBuyUTCNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsgED+d6IjHsqEdVQIybqG1SQb58J2VS/6IYvcs4KpsyGHagv4NCF4FVQCPAaMxAU
	 BVsZX2uAalNFJzbwWeFO1nkkkJMulrTUkox/FtNN5iYU3FxxiLNYF98I3szch2LdCl
	 PU4VPfOhz4hgXEQet6KUtJofUNof9sfERCNzFJGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 056/188] media: iris: Fix use-after-free in iris_release_internal_buffers()
Date: Fri, 15 May 2026 17:47:53 +0200
Message-ID: <20260515154658.529960861@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

commit f27cfdcfc916bb59297825805f4c3499f89f9e76 upstream.

The recent change in commit 1dabf00ee206 ("media: iris: gen1: Destroy
internal buffers after FW releases") introduced a regression where
session_release_buf() may free the buffer. The caller,
iris_release_internal_buffers(), continued to access `buffer` after the
call, leading to a potential use-after-free.

Fix this by setting BUF_ATTR_PENDING_RELEASE before calling
session_release_buf(), and reverting the flag if the call fails. This
ensures no dereference occurs after potential freeing.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Closes: https://lore.kernel.org/lkml/aYXvKAX3Pg3sL37P@stanley.mountain/#r
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Fixes: 1dabf00ee206 ("media: iris: gen1: Destroy internal buffers after FW releases")
Cc: stable@vger.kernel.org
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_buffer.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_buffer.c
+++ b/drivers/media/platform/qcom/iris/iris_buffer.c
@@ -571,10 +571,12 @@ static int iris_release_internal_buffers
 			continue;
 		if (!(buffer->attr & BUF_ATTR_QUEUED))
 			continue;
+		buffer->attr |= BUF_ATTR_PENDING_RELEASE;
 		ret = hfi_ops->session_release_buf(inst, buffer);
-		if (ret)
+		if (ret) {
+			buffer->attr &= ~BUF_ATTR_PENDING_RELEASE;
 			return ret;
-		buffer->attr |= BUF_ATTR_PENDING_RELEASE;
+		}
 	}
 
 	return 0;


