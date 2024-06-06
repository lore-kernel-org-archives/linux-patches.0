Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05DB19925C;
	Thu,  6 Jun 2024 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683205; cv=none; b=X4jEoPdJOfHPezXdwyUXMF7xN44wGVEc38sLPPY7sIJ9MnsdzB1dizjQV+bckZE+aJSAUGFNsUco4XuJtxRWU2DnI+tOSNUGpF22XiLkYoA4y3qo+IELslqIyr4ZuH2O2/Ik1hu6TIkFbu1Ne5NWpNzJxMGOCzyGvjvb0uFOBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683205; c=relaxed/simple;
	bh=zaeMdZ/e3mEnIGmnp/z90U8vEsjf7dDAQwf+KMlvCdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrL4EvDvIViP6MNCCHXzHcMi4yUXPaYHxnJMUE3yiztFD5MbBSxjN05WO9IqGjKhSM4A+bFIfOQ8mSAGy7W0GG+qdbM4zngh5TDBY6cgaGfar7gt+0GJnS04bUytOFljPBmUgAbBhyr8ZFZzMdoqI2TFbhPcOCD6LxBD1ptNGuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qsmSx2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qsmSx2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD13CC2BD10;
	Thu,  6 Jun 2024 14:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683204;
	bh=zaeMdZ/e3mEnIGmnp/z90U8vEsjf7dDAQwf+KMlvCdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qsmSx2pHFzAAK0XsS5mHkPcKGMamWL6LD0Tm2XYwJ/VfPmg/Ga9qU/K57cFW3P30
	 PQ8/5Fuxd6m+Giw1oehSQlZCmfbs45/wo3hWe+PfGPbqfQdRcsPJlyDfdtIvrombXu
	 iSPelkWwVnH0T2Qt1wum3dH9SlcB0QH2LxOpL+DM=
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
Subject: [PATCH 6.6 148/744] bpf: Pack struct bpf_fib_lookup
Date: Thu,  6 Jun 2024 15:57:00 +0200
Message-ID: <20240606131737.159558216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 366df8a1a5fc8..fb09fd1767f28 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -6994,7 +6994,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 366df8a1a5fc8..fb09fd1767f28 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6994,7 +6994,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
-- 
2.43.0



