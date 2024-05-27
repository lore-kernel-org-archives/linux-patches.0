Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D731AD518;
	Mon, 27 May 2024 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836618; cv=none; b=uMquMYaGtIRCYLt31wYQw5oJvx1w7aPWm1nO0OHgChCC+tE97B5ptiT/tWMIPVhiPZFFWJ1LKzbB6ZBUWUhEsxAwUpV+6m7raMqjzpsrc7XVHACJnErXNIp6rSv9jBeeK5ET53wJu/SpB4QLVPrTskCOg1DF3qs5L2BhftjZ8cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836618; c=relaxed/simple;
	bh=oLP21jpOf4sdHZpPtex5PxYk19XtKD4Ts/LV5PMqoeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1wpyhrkL6FelGpJQ9GiqbMF8l5wN9WI/36eShdnMDR68QdI61WJBtlgcDt4Zneiw/hpouXeRibgZaJEHRwdPcuCBpMCunRc+4kn5UubWXHSUeV8L+jZbPjp1e6BNj0dp5ByaEGPjQdIDOnWyoI+chRW0OtGCti1KUWIJPMtypc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OStqidG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OStqidG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10CEBC2BBFC;
	Mon, 27 May 2024 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836618;
	bh=oLP21jpOf4sdHZpPtex5PxYk19XtKD4Ts/LV5PMqoeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OStqidG2gnJXLZpR0GC2YPM5uIdDMe2tNSv8FHj5tUbwyiEHcKGlTIFn/oPGoqTcF
	 aFVCqoeAzjo+7msFW/NIGCNiiULcHtJylRKPpkFtdaX+PV8U/9CQ8WJgHGXC/08c1G
	 p+gTMCMfo6Op/hl4Xu2gXc+crN9jP/1TM2v4eK/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Anton Protopopov <aspsk@isovalent.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 123/427] bpf: Pack struct bpf_fib_lookup
Date: Mon, 27 May 2024 20:52:50 +0200
Message-ID: <20240527185613.370057376@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <aspsk@isovalent.com>

[ Upstream commit f91717007217d975aa975ddabd91ae1a107b9bff ]

The struct bpf_fib_lookup is supposed to be of size 64. A recent commit
59b418c7063d ("bpf: Add a check for struct bpf_fib_lookup size") added
a static assertion to check this property so that future changes to the
structure will not accidentally break this assumption.

As it immediately turned out, on some 32-bit arm systems, when AEABI=n,
the total size of the structure was equal to 68, see [1]. This happened
because the bpf_fib_lookup structure contains a union of two 16-bit
fields:

    union {
            __u16 tot_len;
            __u16 mtu_result;
    };

which was supposed to compile to a 16-bit-aligned 16-bit field. On the
aforementioned setups it was instead both aligned and padded to 32-bits.

Declare this inner union as __attribute__((packed, aligned(2))) such
that it always is of size 2 and is aligned to 16 bits.

  [1] https://lore.kernel.org/all/CA+G9fYtsoP51f-oP_Sp5MOq-Ffv8La2RztNpwvE6+R1VtFiLrw@mail.gmail.com/#t

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: e1850ea9bd9e ("bpf: bpf_fib_lookup return MTU value as output when looked up")
Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240403123303.1452184-1-aspsk@isovalent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/bpf.h       | 2 +-
 tools/include/uapi/linux/bpf.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 3c42b9f1bada3..bcd84985faf48 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -7150,7 +7150,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 3c42b9f1bada3..bcd84985faf48 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -7150,7 +7150,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
-- 
2.43.0



