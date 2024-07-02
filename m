Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830AD1BE857;
	Tue,  2 Jul 2024 17:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941366; cv=none; b=rP3s+AT9oCL5sK6G2ptjodOs2VvepllyyOsZ670rx2VZt9GJyN/eVsywOMH07LylzSO2EgjZlTpxDQrAqDJMC/gcP/yoj3GtNmysKCJNJKr5mGzRIseWkUW31wRW1w/CQgGTVBA579UgOkT9GWiPJ+oQlBZ5gElFC25sYZI8Y2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941366; c=relaxed/simple;
	bh=TujLTNeHavTXm2STGQT7ihvSD1cjqoW7CuU88jU42ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2dWqYQjl5gljgCM0a+7Y/YsTtx34f2Uf8GGB8QZG7toUiNzw8yTCyqAaXYuitGRktoQMLALXf4gga8Qzg/RNTUnoWe46ErkrNs8iQSiFVaO2nObug1Qb9xny7jDv/Fl2GwN7AEICpqdc6ymuGcIdfVa0LX1pjzXd/iRooS0+As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P40HHeu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P40HHeu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D2FC116B1;
	Tue,  2 Jul 2024 17:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941366;
	bh=TujLTNeHavTXm2STGQT7ihvSD1cjqoW7CuU88jU42ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P40HHeu9WQIm9By2ezMloy4sl/EYHQy6eQcg8b5WIF09djVG9844gMpkUnSGq1IkW
	 tEYD5vWfMVg1SoYRYZkWiOP3PPJ+r9V+xK1Cf0L4WHFeMrA+0vm85jOtlO9UiGlC7P
	 CdIGo3Y9QuTkJXsZ1byWM3YvwvA+REuj5azKg/wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Anton Protopopov <aspsk@isovalent.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/128] bpf: Add a check for struct bpf_fib_lookup size
Date: Tue,  2 Jul 2024 19:04:04 +0200
Message-ID: <20240702170227.863792165@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

[ Upstream commit 59b418c7063d30e0a3e1f592d47df096db83185c ]

The struct bpf_fib_lookup should not grow outside of its 64 bytes.
Add a static assert to validate this.

Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240326101742.17421-4-aspsk@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7a07413913538..dc89c34247187 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -82,6 +82,9 @@
 #include <net/mptcp.h>
 #include <net/netfilter/nf_conntrack_bpf.h>
 
+/* Keep the struct bpf_fib_lookup small so that it fits into a cacheline */
+static_assert(sizeof(struct bpf_fib_lookup) == 64, "struct bpf_fib_lookup size check");
+
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
 
-- 
2.43.0



