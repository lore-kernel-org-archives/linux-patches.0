Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1141A2FDD;
	Thu,  6 Jun 2024 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683226; cv=none; b=EswLgdOFJdPh8IcQHlFEEq9FuP17cGz7p3a1XUUJGAHxUCjU3Y3IXGUZCXdloAfwQ8kOP9rbqlJrr2slIxkladJ0kNr1DD2ybdSKLsMGbkEixKKuvuGj/zwed4G+WbLgN0bVrSMNG1WYldb7SHVpaVH7FBj+VX8VIe/RxPBR3k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683226; c=relaxed/simple;
	bh=cQvc9C2dRiidzSUpwsJNOXL0Qv6A05TnjUdOJZVEc0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoJS18gCtGILbgYe3RwTt8Qc1WAgZYYe688/Uk2hR+m+1CzJEKKsk0WbQBs/VJK9MRCUjq2AJN55PgRt17Z9iA41SlKw5Pescikl6UyTkyaEn7ieu0ujzvBww2DRmfMjvflcC8cjfaoqOmLTgmC84eMXLEFarlo1Ke7aRzS801c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmTDcQXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmTDcQXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8C6C2BD10;
	Thu,  6 Jun 2024 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683225;
	bh=cQvc9C2dRiidzSUpwsJNOXL0Qv6A05TnjUdOJZVEc0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmTDcQXExInNgxXJPdTC7d9Rpk2AcyFhD1zFN81JxZcT+YsdmW9kxZkgKIsWTX+Y/
	 UvcNn1sdCeX0yHlHr9Un1IFoT7QO3QeynKWC94umePo9z2luHP4yaCReP232j/2iWS
	 21yruXaf4ecnaWi5yljbQ1WkujXNLMpzzTL5QYIM=
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
Subject: [PATCH 6.1 102/473] bpf: Pack struct bpf_fib_lookup
Date: Thu,  6 Jun 2024 16:00:31 +0200
Message-ID: <20240606131703.275665221@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index d5d2183730b9f..a17688011440e 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6730,7 +6730,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d5d2183730b9f..a17688011440e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6730,7 +6730,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
-- 
2.43.0



