Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E95337699;
	Sat, 12 Sep 2026 08:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202944; cv=none; b=Z05J5d/NW8I07ZRDFzxGwcoBi72W5hmctCuJx9fib7f510ovkF+9linlYzXwzBhHmvjAiiojhJJ3ln0fR4v8cEYVW2zCeqp8xFrLv9iLuRTFim60gjVpoAtd2khbFcHDK+xj2+aYckIUf2BLWfn0W13xVp/RfkP3mt0aZ6NQrj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202944; c=relaxed/simple;
	bh=I+rKr57/JrHQLgNYhB6k09DLM0vqSNDAv5m/6ppQrwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mf1y2lJXx2xhAr7Bv0pWJSpJB9LHmywwxiJ4TjEc9fJa7qx0Vah4sBh3H1Lp6OxJw6viKVDW9/ZDyDAkWEfd/VqkCOjLgcad7HiOhnQWi4HJUT9onL3xez+BBuIKX+4oiPj6Y8CXTksn/++fo8Wne/weEC3+Y9Y7e32oXPgLmtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWoDNHGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWoDNHGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54BB1F000FF;
	Sat, 12 Sep 2026 08:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202942;
	bh=pmcsfFFjH6REkGunN/DpnakPzlkotmRwAgTUbHjsXX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWoDNHGC+w2FkaxXvkR6K8aXQcAlCP7GrOhvMPnrXJbE8+2ImyyuhexNzVf/Okrxy
	 bju/W/JpE121JorGSmyRJZG7YdEnBlIh8G72eANv9S4j3MShrpjcvXqlE0SK7VMOV0
	 /MCocrivD16fL986829iWKWqhYZGB0+qjzrhsDkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1307/1815] xdrgen: Do not declare union XDR functions in the definitions header
Date: Sat, 12 Sep 2026 08:50:57 +0200
Message-ID: <20260912065719.701603398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit d4ca0b0a6c62bc12407060754df11b23a90f3e57 ]

Unlike the struct, enum, typedef, and pointer templates, the union
definitions template also emits xdrgen_decode_*() and
xdrgen_encode_*() prototypes for a public union into that header.
Those prototypes name struct xdr_stream, which the definitions
header neither includes nor forward-declares, so any translation
unit that includes the definitions header without xdr.h already in
scope draws -Wvisibility warnings. The same public prototypes are
emitted into the declarations header, which does include
<linux/sunrpc/xdr.h>, making the definitions-header copies
redundant.

Drop the prototype emission from the union definitions template so
it matches the other type templates. Public unions keep their
encode and decode prototypes through the declarations header.

Fixes: 4b132aacb076 ("tools: Add xdrgen")
Link: https://patch.msgid.link/20260712193122.116845-4-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/sunrpc/xdrgen/templates/C/union/definition/close.j2 | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2 b/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
index 5fc1937ba7744..19ee759d70c6a 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/union/definition/close.j2
@@ -1,9 +1,3 @@
 {# SPDX-License-Identifier: GPL-2.0 #}
 	} u;
 };
-{%- if name in public_apis %}
-
-
-bool xdrgen_decode_{{ name }}(struct xdr_stream *xdr, struct {{ name }} *ptr);
-bool xdrgen_encode_{{ name }}(struct xdr_stream *xdr, const struct {{ name }} *ptr);
-{%- endif -%}
-- 
2.53.0



