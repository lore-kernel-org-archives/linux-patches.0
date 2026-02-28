Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC87342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301793; cv=none; b=eD3Ichv19y41ZHAoS8CXWGyq0qNMT0MrMmXSe3/Z28VnC5dY/IyLdVwTcafDvvlclFJhg3sAb7X8ua9elsTAYPE9cyfPT5Q0McNOT1EYZjX/iliuk+BP+freOSOv8OwRMoZX6x3pyqUKbO4o4t39uwaaWL39ZktsEM0fxaQAsPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301793; c=relaxed/simple;
	bh=mdhO/QLNtmOtR1g9izVh5ZpmzlzquBg9lExynbN7ZUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldilHpFhA0My8X7PW/XsiHU7uXrlLIxaK0f7PyfCY4csLV2mFb5v3NQ1LwRTt0P0DiFmgDiaSy3u5wwxtPZyEIKVFDDL6B9HSoKwJpcfoeGjU7BHrBKyljGUTlvLm045P8jgT8s/XX6fflGQeLOvTqiQNXoYIZMb2f5oSeVtzv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lb+IM6gR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lb+IM6gR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC47CC116D0;
	Sat, 28 Feb 2026 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301793;
	bh=mdhO/QLNtmOtR1g9izVh5ZpmzlzquBg9lExynbN7ZUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lb+IM6gRWEiJWrmjCGJ/DY2y3VIn4nHfeBM9cIWmen3AsC8oOr9+5LLSdugfLBbMz
	 oWdvk3+GZnroRT4e9qBtyBZAusfwYAsO/v5eiI7ymLbkGzt51uBm2/nEA/1ox6KQtQ
	 isSF1yZQ3jU+cNaaKhAiAFw0C/b0Pd4UFB8bI0yBn6PsqRAAiprbv53FA1EFLODxJa
	 0lqAzJTOfFmpJEb3evdkKba7E2Y6KeFXuKyJnMVNDlSSV4EWUbN6owiVhPEOxKhkF1
	 eoykfZ95bfm162BQRdzodTZb5zHWnqSeuKP2ZgZ7WtMHh8jWU1ax6sFzyPm4dvv/KR
	 IMZrDvyjgmiOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/385] xdrgen: Fix struct prefix for typedef types in program wrappers
Date: Sat, 28 Feb 2026 12:57:05 -0500
Message-ID: <20260228180011.1568201-203-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index fd24574612742..49191cd10ab70 100644
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

