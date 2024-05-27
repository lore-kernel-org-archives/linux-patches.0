Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234B0168C4;
	Mon, 27 May 2024 19:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837909; cv=none; b=FJocMCnChGcj+05dSLIM3SVYyTfR+ICgww8x6onskU1NivhTvzEtbg/5E7uV8ChuSIwDQ+5ZWPqjkEVmbgZfFZ6H8fOfhBWjEkzl5u3gC3PFYqBy1onHE8wFtpG/niiFn8vm2RNBw5X49sUOy4uRY8H6PFbEdQjOWjv1Qf4Mtzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837909; c=relaxed/simple;
	bh=qOI7sc3+MoRv8CRgDDsk/sqHexesgQHN8P8QdeYxVPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOFWtyZaubRmj62a5mGWyRmI+HSK1de1bxVnKMRofs6Pbv5+MykRU09keOcxvbVDEpDGNBFUktos03TfDcs+8g4EhM93sox3FUIZc5gZkcNYXBUduE2ecLsrKEqkFOCH4tO7jcgc4HvPq9s24p+IdRyrr6aI8OWNBxYXySQD4v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSf+vrtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSf+vrtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8A5C2BBFC;
	Mon, 27 May 2024 19:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837909;
	bh=qOI7sc3+MoRv8CRgDDsk/sqHexesgQHN8P8QdeYxVPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSf+vrtxRA1A9LAtg2tWg5y3DPDzVf8OSNAxM6v+mqrzZwjPpeELvb/Wr15WlFJRh
	 yBCv4R+vvk/Og4VXOK6aKT02Owfaxejcvl91e+9Xnt8ta7JaIoVK6ffok2ppdzKI0T
	 PK2zLjpDNfia16mZJ9VKYE+j5ZHcxjxZD1Wv0ZL0=
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
Subject: [PATCH 6.8 192/493] bpf: Pack struct bpf_fib_lookup
Date: Mon, 27 May 2024 20:53:14 +0200
Message-ID: <20240527185636.628054022@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 754e68ca8744c..83f31916e2635 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -7040,7 +7040,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7f24d898efbb4..a12f597a1c47f 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -7039,7 +7039,7 @@ struct bpf_fib_lookup {
 
 		/* output: MTU value */
 		__u16	mtu_result;
-	};
+	} __attribute__((packed, aligned(2)));
 	/* input: L3 device index for lookup
 	 * output: device index from FIB lookup
 	 */
-- 
2.43.0



