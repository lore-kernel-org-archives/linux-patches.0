Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE091E2834;
	Wed, 25 Feb 2026 01:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984024; cv=none; b=ga/KHS5vhbuNqubprXV6Zrsy4c2CP2qOUJ1ndHcer4FQxhHOR7zQF+9FXkJ4P8KMYaJCIuyES4P7HTY1QU4xB1Bca81XMxX3F7VveZWLa+G89D+A3CpybDNx3eseylY+MpPwF4G9gMMtiIQOo2lpjUjB8zZeAvHbKfu5L8tAoBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984024; c=relaxed/simple;
	bh=/b4ChQdiy+Iq7W5LNdHAvPreZEdO5CJvmHBHP6lIaLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSmvYP3zmkYku6VQz6CzITaFmY/jMBqUJLtg3667dg81CD1GzuiAYz+ran8iYFKxYkxvxbpTCN/EgQBaOoUnrEccuqrApNuMxol93XJb3NkACNEnYzUrFneZ+zXslabWzu2ckqkl+IwoI0VqgGcknFLLr83jreMfmoNGZj6mR6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4VL3Uyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4VL3Uyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE88C116D0;
	Wed, 25 Feb 2026 01:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984024;
	bh=/b4ChQdiy+Iq7W5LNdHAvPreZEdO5CJvmHBHP6lIaLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4VL3UyiF/zvd4mHwdZOXk0WXSDLS0pmfc0cXgYFjK6HcbEL0uf9HP2RqpYvMY2n4
	 puzPKe3OItzBX1k02xo1P/qYvecVk5uhNGuyqDhC1PFh/1wiIgSTb88e5iA8X8Kl3h
	 a1H5rwPIpJvUenPdxjc2lq1AJCUisRRjv1FHIZw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/641] xdrgen: Fix struct prefix for typedef types in program wrappers
Date: Tue, 24 Feb 2026 17:19:56 -0800
Message-ID: <20260225012355.341333261@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bf0fe9ad3d597d8e1378dc9953ca96dfc3addb2b ]

The program templates for decoder/argument.j2 and encoder/result.j2
unconditionally add 'struct' prefix to all types. This is incorrect
when an RPC protocol specification lists a typedef'd basic type or
an enum as a procedure argument or result (e.g., NFSv2's fhandle or
stat), resulting in compiler errors when building generated C code.

Fixes: 4b132aacb076 ("tools: Add xdrgen")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/sunrpc/xdrgen/generators/__init__.py              | 3 ++-
 .../sunrpc/xdrgen/templates/C/program/decoder/argument.j2   | 4 ++++
 .../net/sunrpc/xdrgen/templates/C/program/encoder/result.j2 | 6 ++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/net/sunrpc/xdrgen/generators/__init__.py b/tools/net/sunrpc/xdrgen/generators/__init__.py
index b98574a36a4ac..a2eb6652ac900 100644
--- a/tools/net/sunrpc/xdrgen/generators/__init__.py
+++ b/tools/net/sunrpc/xdrgen/generators/__init__.py
@@ -6,7 +6,7 @@ import sys
 from jinja2 import Environment, FileSystemLoader, Template
 
 from xdr_ast import _XdrAst, Specification, _RpcProgram, _XdrTypeSpecifier
-from xdr_ast import public_apis, pass_by_reference, get_header_name
+from xdr_ast import public_apis, pass_by_reference, structs, get_header_name
 from xdr_parse import get_xdr_annotate
 
 
@@ -22,6 +22,7 @@ def create_jinja2_environment(language: str, xdr_type: str) -> Environment:
             environment.globals["annotate"] = get_xdr_annotate()
             environment.globals["public_apis"] = public_apis
             environment.globals["pass_by_reference"] = pass_by_reference
+            environment.globals["structs"] = structs
             return environment
         case _:
             raise NotImplementedError("Language not supported")
diff --git a/tools/net/sunrpc/xdrgen/templates/C/program/decoder/argument.j2 b/tools/net/sunrpc/xdrgen/templates/C/program/decoder/argument.j2
index 0b1709cca0d4a..19b219dd276d3 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/program/decoder/argument.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/program/decoder/argument.j2
@@ -14,7 +14,11 @@ bool {{ program }}_svc_decode_{{ argument }}(struct svc_rqst *rqstp, struct xdr_
 {% if argument == 'void' %}
 	return xdrgen_decode_void(xdr);
 {% else %}
+{% if argument in structs %}
 	struct {{ argument }} *argp = rqstp->rq_argp;
+{% else %}
+	{{ argument }} *argp = rqstp->rq_argp;
+{% endif %}
 
 	return xdrgen_decode_{{ argument }}(xdr, argp);
 {% endif %}
diff --git a/tools/net/sunrpc/xdrgen/templates/C/program/encoder/result.j2 b/tools/net/sunrpc/xdrgen/templates/C/program/encoder/result.j2
index 6fc61a5d47b7f..746592cfda562 100644
--- a/tools/net/sunrpc/xdrgen/templates/C/program/encoder/result.j2
+++ b/tools/net/sunrpc/xdrgen/templates/C/program/encoder/result.j2
@@ -14,8 +14,14 @@ bool {{ program }}_svc_encode_{{ result }}(struct svc_rqst *rqstp, struct xdr_st
 {% if result == 'void' %}
 	return xdrgen_encode_void(xdr);
 {% else %}
+{% if result in structs %}
 	struct {{ result }} *resp = rqstp->rq_resp;
 
 	return xdrgen_encode_{{ result }}(xdr, resp);
+{% else %}
+	{{ result }} *resp = rqstp->rq_resp;
+
+	return xdrgen_encode_{{ result }}(xdr, *resp);
+{% endif %}
 {% endif %}
 }
-- 
2.51.0



