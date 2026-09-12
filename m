Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03EA28B4FA;
	Sat, 12 Sep 2026 08:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202959; cv=none; b=Y9XOXyLG4O1WcbWw8acDJQk1gzj426JR1oCpYzoUhUINMq9+Fb0DtDn+/TXanwdrwlGp48rfkzJIfAZQs52lrJ88ve7Tqg24JidFCV5C9eIzNCQYiixTmcR2NUPDqTOjX9En7Uledohgj5/BbpjxoEvvNc6p6pPlD7hJlxnkE2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202959; c=relaxed/simple;
	bh=L/lsSoqNOdbPiu4LDykcdV2ynRCJjZgoCyncLFUqEJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOZWBDqiqaYGrUAVszUCPmoqKeJ/qxQ4tIflpC1pqFTlDicYts8MVNyJLqT6orMqeTxyN6yJEX42orNtDP2MAXxUuv0soilNK2dMm57uS1iaKVHTrnxTwxGGonHAbhvVzAZJpKuBCQKOSk3+jLmB3ze3FiZhhoTI9ajsfkexwZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqxVwtC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqxVwtC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE821F000FF;
	Sat, 12 Sep 2026 08:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202957;
	bh=5B5wP3jCsTGRAEi024vLJr//R89i0rh19WL4BIzLpKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqxVwtC3Ubmo3vTVqUbQBpFqBRpQxLoemnM6WQWRsuZ5ZblbFcrN/bigOOGleIWZU
	 krhSZ4wPvCxdgu5gUM7tyiDeeradPZGJ3YBHvqK5o0Rp9FbOfpPlhcIQJG70vjKM+f
	 e7FivZl2uZ71KVrVDYNLAEwWZDhOlYIZR3BAeSzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1309/1815] xdrgen: Fix opaque and string encoders for unbounded members
Date: Sat, 12 Sep 2026 08:50:59 +0200
Message-ID: <20260912065719.748269272@linuxfoundation.org>
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

[ Upstream commit daa52e37851a5a1b5890e7a250a27e94a8b9f273 ]

The variable-length opaque and string encoder templates emit an
unconditional bound check, "if (value->NAME.len > MAXSIZE) return
false". XDR represents an unbounded specifier (opaque foo<>, string
foo<>) as a maxsize of 0, so for an unbounded member the check
degenerates to "len > 0" and the generated encoder refuses every
non-empty value.

The decoder does not share this defect. It delegates to
xdrgen_decode_opaque() and xdrgen_decode_string(), which treat a
maxlen of 0 as unbounded and skip the length check. The sibling
variable-length array templates already guard their bound check
with maxsize != "0".

Guard the bound check the same way in each affected template -- the
struct and pointer forms of both the opaque and string encoders --
so an unbounded member encodes a payload of any length while a
bounded member keeps its limit.

An explicit zero-length bound (foo<0>) parses to the same maxsize of
0 and so also skips the check; xdrgen does not distinguish it from
the unbounded form, matching the decoder and the array encoders.

Fixes: 4b132aacb076 ("tools: Add xdrgen")
Link: https://patch.msgid.link/20260712193122.116845-6-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/string.j2   | 2 ++
 .../templates/C/pointer/encoder/variable_length_opaque.j2       | 2 ++
 tools/net/sunrpc/xdrgen/templates/C/struct/encoder/string.j2    | 2 ++
 .../xdrgen/templates/C/struct/encoder/variable_length_opaque.j2 | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/string.j2 b/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/string.j2
index cf65b71eaef39..7ddc2bf3edacc 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/string.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/string.j2
@@ -2,7 +2,9 @@
 {% if annotate %}
 	/* member {{ name }} (variable-length string) */
 {% endif %}
+{% if maxsize != "0" %}
 	if (value->{{ name }}.len > {{ maxsize }})
 		return false;
+{% endif %}
 	if (xdr_stream_encode_opaque(xdr, value->{{ name }}.data, value->{{ name }}.len) < 0)
 		return false;
diff --git a/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/variable_length_opaque.j2 b/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/variable_length_opaque.j2
index 1d477c2d197aa..5bf00070ae959 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/variable_length_opaque.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/pointer/encoder/variable_length_opaque.j2
@@ -2,7 +2,9 @@
 {% if annotate %}
 	/* member {{ name }} (variable-length opaque) */
 {% endif %}
+{% if maxsize != "0" %}
 	if (value->{{ name }}.len > {{ maxsize }})
 		return false;
+{% endif %}
 	if (xdr_stream_encode_opaque(xdr, value->{{ name }}.data, value->{{ name }}.len) < 0)
 		return false;
diff --git a/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/string.j2 b/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/string.j2
index cf65b71eaef39..7ddc2bf3edacc 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/string.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/string.j2
@@ -2,7 +2,9 @@
 {% if annotate %}
 	/* member {{ name }} (variable-length string) */
 {% endif %}
+{% if maxsize != "0" %}
 	if (value->{{ name }}.len > {{ maxsize }})
 		return false;
+{% endif %}
 	if (xdr_stream_encode_opaque(xdr, value->{{ name }}.data, value->{{ name }}.len) < 0)
 		return false;
diff --git a/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/variable_length_opaque.j2 b/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/variable_length_opaque.j2
index 1d477c2d197aa..5bf00070ae959 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/variable_length_opaque.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/struct/encoder/variable_length_opaque.j2
@@ -2,7 +2,9 @@
 {% if annotate %}
 	/* member {{ name }} (variable-length opaque) */
 {% endif %}
+{% if maxsize != "0" %}
 	if (value->{{ name }}.len > {{ maxsize }})
 		return false;
+{% endif %}
 	if (xdr_stream_encode_opaque(xdr, value->{{ name }}.data, value->{{ name }}.len) < 0)
 		return false;
-- 
2.53.0



