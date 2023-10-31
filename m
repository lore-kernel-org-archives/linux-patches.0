Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5E208CF
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIf966C0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5623C433C8;
	Tue, 31 Oct 2023 17:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774586;
	bh=iOsyg6n+q7ITCbgxSl0zwfG6hk4SjuAlJ81JKdHPdDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIf966C0JKWcxZjo31EmZq2E4ONCXGY7v9OsE0EnsU1mKbWyA3nw2ZwoslVL/nyPc
	 jyyLQ49LDG0nY9ou0wk6u/iNabGh7UWY/29E1xBWdZOFZJyghdxWoRrIEVvxsr8mSJ
	 96X1GRjszSA9/Jujzu4JbZJUZKrhapG19OwWIguo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.5 095/112] misc: fastrpc: Reset metadata buffer to avoid incorrect free
Date: Tue, 31 Oct 2023 18:01:36 +0100
Message-ID: <20231031165904.288118865@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit 1c29d80134ac116e0196c7bad58a2121381b679c upstream.

Metadata buffer is allocated during get_args for any remote call.
This buffer carries buffers, fdlists and other payload information
for the call. If the buffer is not reset, put_args might find some
garbage FDs in the fdlist which might have an existing mapping in
the list. This could result in improper freeing of FD map when DSP
might still be using the buffer. Added change to reset the metadata
buffer after allocation.

Fixes: 8f6c1d8c4f0c ("misc: fastrpc: Add fdlist implementation")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231013122007.174464-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -957,6 +957,7 @@ static int fastrpc_get_args(u32 kernel,
 	if (err)
 		return err;
 
+	memset(ctx->buf->virt, 0, pkt_size);
 	rpra = ctx->buf->virt;
 	list = fastrpc_invoke_buf_start(rpra, ctx->nscalars);
 	pages = fastrpc_phy_page_start(list, ctx->nscalars);


