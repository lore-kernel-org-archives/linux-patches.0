Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7053934752E;
	Sat, 12 Sep 2026 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210661; cv=none; b=X2B5AxSzMOJzEQ0Ny4979NtB1G5nszXylz0DZfoYltXeKjx/ZsZXVm7S5WNK3J+nSgednJjuJZZvavQVU+rOTShChfDodaaVaJwhF6F7Lx7wWwTn6WaZ5SVvdVZ0gZg6b9wXIYyRvaA3u/ZAPtCb+uJ4UXi2XF4J7LV1NcVJT+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210661; c=relaxed/simple;
	bh=2TAUYsN+1ksLIqovhA2d8gahja3ZfTQH1jkt1c6/zwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dx2oOq+ScQUI4Rkrr2j9T5K2mjLahRofGLWPiRKsVrRj8mb0boP8eHUqGsRPN9mBOGKopTSd18nQgCVhdnnf9bcfb2JWsa5bcjCGQd0RartSnseJ2znvJ+F9fsAC/cUN+ocWsTM+V/aTxYqgdIVp1tx6/jjL4jFRiKYOfgDn86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeeWeIuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeeWeIuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2958B1F000FF;
	Sat, 12 Sep 2026 10:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210660;
	bh=/uswm93zYIgR/z0JpYoMhouHOMjWo+nwF70qKXg+FIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeeWeIuW3LNzMCEkpPBV4XPXwIvgxHBmrj3egf6tmBvQc325h4lbTA5UC6EYynEYq
	 0sT8kaSUm+/gff6nZrwyPt/e2koj9uE3799x8I5SdlJ2SftRoXHOToDiYiNYvSMpgo
	 SsnyErSlwGrFfqlKsZyK+syKko+R6IYpiKTR1xh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1073/1518] xdrgen: Fix opaque and string encoders for unbounded members
Date: Sat, 12 Sep 2026 08:54:02 +0200
Message-ID: <20260912065647.721233555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



