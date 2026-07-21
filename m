Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DFB3B9D9D;
	Tue, 21 Jul 2026 21:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670197; cv=none; b=pA687JcwXejYUkeSfUeYR5/jkEBOtE9iVPvKoKSdHlIajjuXQsYlSgZXbIN6GoA0oy8XfgeBXxhCnWqC1yuSlGsqTWqN2Yc/PIoMX8xTFzB9fa0yqGr1S1oAoQFFRnYwkw/eQpqxtuL9SHph8+S4dFHsK4No9lwkem7zpZAJT5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670197; c=relaxed/simple;
	bh=q7jsgyrVrtxHpVQZlMTF5IpFTJqOpeoyyKQwSsH+Xhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L30E8/FSV8rcEyakwz1qEQz6cbwZ4eOmKv2FkY+4uDLc0SU7QGZenErSBzUtwyOQJEBWBnBxMMpMWzF3hARVydCs/TZ0hSVS728PTqwrMnUALo0gYKkzAjmwzBOMQM6sXF6Mx1JCJkp4DyOeNcajnVLC4DV3/m6M0VNX+cbrYNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpv5F8y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpv5F8y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4831F000E9;
	Tue, 21 Jul 2026 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670195;
	bh=kxHGSTbDPWnts4bTcZD9C78Wdbzt+YQCBcB83Htlq6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpv5F8y8DX2+cuyclru4nogrp5uFPLpER/o5vpsJOTUy06omV8Co445HU2T5jqtjO
	 dbf0iPwp+5n5q6dsF79P4YwoT5BO15yYv5GpfpzcGr3Zpm1e/ehERr2i/l6uipdMaA
	 /6x1EAKr8tM6fZP+GryS1mW4oJfELDtgnmjV7eWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zishun Yi <vulab@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.1 0798/1067] riscv: cacheinfo: Fix node reference leak in populate_cache_leaves
Date: Tue, 21 Jul 2026 17:23:19 +0200
Message-ID: <20260721152442.412597715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zishun Yi <vulab@iscas.ac.cn>

commit bf4a195f063b0a0805c1417f6aad1dd32ea48f0f upstream.

Currently, the while loop drops the reference to prev in each iteration.
If the loop terminates early due to a break, the final of_node_put(np)
correctly drops the reference to the current node.

However, if the loop terminates naturally because np == NULL, calling
of_node_put(np) is a no-op. This leaves the last valid node stored in
prev without its reference dropped, resulting in a node reference leak.

Fix this by changing the final `of_node_put(np)` to `of_node_put(prev)`.

Fixes: 94f9bf118f1e ("RISC-V: Fix of_node_* refcount")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Zishun Yi <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260509074040.1747800-1-vulab@iscas.ac.cn
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -141,7 +141,7 @@ int populate_cache_leaves(unsigned int c
 
 		levels = level;
 	}
-	of_node_put(np);
+	of_node_put(prev);
 
 	return 0;
 }


