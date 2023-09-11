Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550E51170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C306BC433C9;
	Mon, 11 Sep 2023 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440656;
	bh=zNs9SatSEwXaFDGbxX/ytRZawcLCZfOEXWuSSSIdgKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mE46kBK48QYkow812/Uyf5JrG4atKISzecb6mzKvKQuVHx3NcHcAJulayKRhfOkvP
	 BKs8Lni7ql1orQdZ3rntu0vMA0eok8iiQzKgZokos1AbGWLKrzWieCUSCXcNLmh1vP
	 HQr9/ZOnSMmOzeHZBGpi8fZ1RraMWsHUbTxsE/oE=
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
Subject: [PATCH 6.5 111/739] bpf: fix bpf_dynptr_slice() to stop return an ERR_PTR.
Date: Mon, 11 Sep 2023 15:38:30 +0200
Message-ID: <20230911134654.200582684@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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
index 9e80efa59a5d6..8812397a5cd96 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2243,7 +2243,7 @@ __bpf_kfunc void *bpf_dynptr_slice(const struct bpf_dynptr_kern *ptr, u32 offset
 	case BPF_DYNPTR_TYPE_XDP:
 	{
 		void *xdp_ptr = bpf_xdp_pointer(ptr->data, ptr->offset + offset, len);
-		if (xdp_ptr)
+		if (!IS_ERR_OR_NULL(xdp_ptr))
 			return xdp_ptr;
 
 		if (!buffer__opt)
-- 
2.40.1



