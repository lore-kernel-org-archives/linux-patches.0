Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFB446D2A1;
	Tue, 21 Jul 2026 19:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661004; cv=none; b=q41pCWiAqVEQbdP2Q360LHcy8Ll2CukVgigdyouNNjapU3XEJrCxvOOuy860npSeLz0r/J2+z5doqywolgfkrR+iCrXpUy4irmk3W7e2Sih7Q+q/dcW3z8oAd8ozpaT/+TMfxewd71Pc50cYhdFWpH1PdzAp4dDjNScM3aBTYNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661004; c=relaxed/simple;
	bh=C1MfCd19qVVVazOoDyphIkYYS98BLTX09HTnsk0EFHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qr31E6OMzXtIBICaay29Nu+aDNlhO16k+dG2x9Pk2LDFPk9ECybRMjXKJu0KhmD7EgQc9OnTLkVQnxVPDnWboD4lhbc/jjK/62PiAlgJnKXi0aGeEecYjBLk1ZRiY92SxRHoOqTvMaoGo1t60DSIokpfGPuGOQ5LjS3eZEkI6o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpomNT5v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpomNT5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAAB1F000E9;
	Tue, 21 Jul 2026 19:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661002;
	bh=BxOkLAosURj4KGHpq5Q51Xdm8PhsllgK2h9rZZ0S0/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpomNT5vweJuC3R1tfgzZF7wX+beO6ZicJXSOpPXyHWDhRvFhYqmIsO4IE7xYofGN
	 I4adRJKhNKE9iwIWHxTDRyxgSR32iK5AOd/jsvlE03PZuWXpDqsLFK0BaZLh/3V95O
	 LEiEoHHBIMuZmFlW8uWXCYseO0xdSqMPIKD1xO9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1192/2077] bpf: Fix partial copy of non-linear test_run output
Date: Tue, 21 Jul 2026 17:14:25 +0200
Message-ID: <20260721152620.930982157@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit b5f3534268e3f91c9d3e9dc79ee5a32555880ee9 ]

For non-linear test_run output, bpf_test_finish() derives the linear
data copy length from copy_size - frag_size. This only matches the
linear data length when copy_size is the full packet size.

When userspace provides a short data_out buffer, copy_size is clamped to
that buffer size. If copy_size is smaller than frag_size, the computed
length becomes negative and bpf_test_finish() returns -ENOSPC before
copying the packet prefix or updating data_size_out.

Compute the linear data length from the packet layout instead, and clamp
the linear copy length to copy_size. This preserves the expected
partial-copy semantics: return -ENOSPC, copy the packet prefix that fits
in data_out, and report the full packet length through data_size_out.

Fixes: 7855e0db150ad ("bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature")
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260617093557.63880-2-sun.jian.kdev@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2bc04feadfabed..f15c613aaa4ee8 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -453,12 +453,8 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 	}
 
 	if (data_out) {
-		int len = sinfo ? copy_size - frag_size : copy_size;
-
-		if (len < 0) {
-			err = -ENOSPC;
-			goto out;
-		}
+		u32 head_len = size - frag_size;
+		u32 len = min(copy_size, head_len);
 
 		if (copy_to_user(data_out, data, len))
 			goto out;
-- 
2.53.0



