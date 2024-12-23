Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BD117A597;
	Mon, 23 Dec 2024 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970799; cv=none; b=HjMCW8vnZs4Hj4bP7xGVcM8LRAsBsHDnRwIQ3WxTFCuIvkPQUN0u1/aWO8TMX9Aa1zRJCEg2ejEvhoMtBlteR/VpaEzRt930K/izIPH/lcCo3fI3xUDwKh1wGAL+YDwwQvqyr9n54lTXkBv1l4R1pFGhq60jB9s8dFmVs5NDNHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970799; c=relaxed/simple;
	bh=mKjHij92LHZuuVLizb4zrXLmo57Z3xbhx1yKW2Uq0Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZpGcpubRADdhep3gj4mHdO19hgHZUtzibyW1qxHTvXCAdQSIAcrrvN2BD4Ptkg3VtvBxSt1GiYk3w4mnATgFf3ZJ2WbILOa1w8BAXOpaSa721Rd2yY3seEP4bN0XE/yctmJrdLNcHlhcpkCAM+zrZcJK7M+WDmmv8ROZiduV01c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lo7833yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lo7833yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ACDC4CED3;
	Mon, 23 Dec 2024 16:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970799;
	bh=mKjHij92LHZuuVLizb4zrXLmo57Z3xbhx1yKW2Uq0Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lo7833yoFwpanRKG57LJVk3qeWUymOA9BXSJ6wUacbzMQnV7ZDyyTWJkADoosesIB
	 OAixOuE+7AnX8jclzO8mj0WkLrMjOMJF5fIswr2+JHXf6/l2m7rAv+SMl35lQVBhjl
	 2O8lcw/C61mDRrL8UIx0wJc+MLH1XCmInbCmLzqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 6.1 73/83] udmabuf: also check for F_SEAL_FUTURE_WRITE
Date: Mon, 23 Dec 2024 16:59:52 +0100
Message-ID: <20241223155356.464607755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 0a16e24e34f28210f68195259456c73462518597 upstream.

When F_SEAL_FUTURE_WRITE was introduced, it was overlooked that udmabuf
must reject memfds with this flag, just like ones with F_SEAL_WRITE.
Fix it by adding F_SEAL_FUTURE_WRITE to SEALS_DENIED.

Fixes: ab3948f58ff8 ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd")
Cc: stable@vger.kernel.org
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204-udmabuf-fixes-v2-2-23887289de1c@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -164,7 +164,7 @@ static const struct dma_buf_ops udmabuf_
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)
-#define SEALS_DENIED (F_SEAL_WRITE)
+#define SEALS_DENIED (F_SEAL_WRITE|F_SEAL_FUTURE_WRITE)
 
 static long udmabuf_create(struct miscdevice *device,
 			   struct udmabuf_create_list *head,


