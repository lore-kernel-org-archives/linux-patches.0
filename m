Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042841;
	b=SN2OO6/Z6P6NIWMOXg31k1L7DtlZnWj8IMjSmGlifycZbZFMlFJpn1/637UKzrZFBlRn
	 aR+Rn7Urdmff3HvjdFVUYpNvHnlnqJPS7IPKqaMvsKZPAOloWOp5vgv8378clUehUOVJn
	 XaYH8F1xyaMWnAcC+60ZKXD4jovFRrjy78a67a8tHI8nUAKQZRxBtChxsWxPZoSmZ6J8I
	 uYSPX/XHUOVINEiCN2R9D0+56jID7vCV+86R58rp8b2fnxJHCPvtOecEOXyIZCvWLlEoG
	 jKMhLZ6/+egkWvrCm7uKJ/a+DZW4ToQfm3F+02sPWktAch70t+JZVaSC0sWzCZJiRfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sUNC9Tn75oXfePeI56CSji6gT7S/iewBfG5GLVGQqXo=;
	b=KxAjJLjWssUq32ldAMRpllVOEbL1YmtOI6McSd4fZlOCBHWSIbDoFH/5ueED/ZCeBw1Z
	 +jC6MkKQM/njYrWutTwhoAPMXLzEj0cRNGoFeXLnAae9iaXZ87vGKNbKIXM1126rub46g
	 mEI2kkHtnBRrIW61ToQmCwvUCwUFD1YaYoNhxCYNE4Hw20K9ru4ZkTAH4RoN5Se6huLbF
	 kXhlx++9/clNiUmMUdzl8zgaZ6bxkCMZf1up/BOkyR/LQ35xIL2Ho0O9/t5XyC9Zg+TCC
	 ezE89c016MpgKd84RAutBP1TOD3cj9G3iZEIZClA5DXJBKgagU1EarXdeVQ1eDFCIxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aTFy6/EM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C3606A31C;
	Wed, 18 Nov 2026 23:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aTFy6/EM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C402D1F000C5;
	Wed, 18 Nov 2026 23:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042841;
	bh=sUNC9Tn75oXfePeI56CSji6gT7S/iewBfG5GLVGQqXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aTFy6/EMpLYyPvVxS6TsTZajFnpYQs8tshZS5pbjin8j14Z5WFKBEU4HmpShlI/y1
	 2A85M8alLFlfprcSABPE+FyVYRnwkIUyRPD5XuBTHblki/JvhA3dgU3v9jCSKfcmzl
	 wu5SRjcxAnY+kTFqiZtn0yyqsd0qlZbrBsR8IP1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Quentin Monnet <quentin@isovalent.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 3314/3318] bpftool: Fix wrong free call in do_show_link
Date: Wed, 18 Nov 2026 16:05:36 +0100
Message-ID: <20261118150458.992774487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 2adb2e0fcdf3c6d8e28a5a9c33e458e1037ae5ad upstream.

The error path frees wrong array, it should be ref_ctr_offsets.

Acked-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Fixes: a7795698f8b6 ("bpftool: Add support to display uprobe_multi links")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240119110505.400573-4-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/bpftool/link.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -962,7 +962,7 @@ again:
 			cookies = calloc(count, sizeof(__u64));
 			if (!cookies) {
 				p_err("mem alloc failed");
-				free(cookies);
+				free(ref_ctr_offsets);
 				free(offsets);
 				close(fd);
 				return -ENOMEM;


