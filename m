Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C05F51E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A6CC433C7;
	Mon, 11 Sep 2023 14:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442897;
	bh=yNO1s/m6GoOGn7CueTssnayVx5bg3QY6hUC/ce0PnRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lODSXDRHbD5ZuReUezvEph9PO7vC7H4ShNjZ0JRidWMgU5OvSJuVm4DTkPIifnc/f
	 TQ7nxLBg8BpiVe2lpDeepM60gs476cnEXj+VlczXKOmXugtsL9b+JmRINHuBWeios3
	 FnK3rWmF5ZpdjLk7OU9n44P7hMDwji29rn/xQfLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Kui-Feng Lee <thinker.li@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 187/737] bpf: fix bpf_dynptr_slice() to stop return an ERR_PTR.
Date: Mon, 11 Sep 2023 15:40:46 +0200
Message-ID: <20230911134655.799687171@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kui-Feng Lee <thinker.li@gmail.com>

[ Upstream commit 5426700e6841bf72e652e34b5cec68eadf442435 ]

Verify if the pointer obtained from bpf_xdp_pointer() is either an error or
NULL before returning it.

The function bpf_dynptr_slice() mistakenly returned an ERR_PTR. Instead of
solely checking for NULL, it should also verify if the pointer returned by
bpf_xdp_pointer() is an error or NULL.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/bpf/d1360219-85c3-4a03-9449-253ea905f9d1@moroto.mountain/
Fixes: 66e3a13e7c2c ("bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr")
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Kui-Feng Lee <thinker.li@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20230803231206.1060485-1-thinker.li@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index f12565ba136b0..8c5daa841704b 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2218,7 +2218,7 @@ __bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u32 offset
 	case BPF_DYNPTR_TYPE_XDP:
 	{
 		void *xdp_ptr = bpf_xdp_pointer(ptr->data, ptr->offset + offset, len);
-		if (xdp_ptr)
+		if (!IS_ERR_OR_NULL(xdp_ptr))
 			return xdp_ptr;
 
 		bpf_xdp_copy_buf(ptr->data, ptr->offset + offset, buffer, len, false);
-- 
2.40.1



