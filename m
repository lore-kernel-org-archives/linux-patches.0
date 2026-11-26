Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704418;
	b=D5UF9VXIAHsxyHampZGqO4hYVqBngWeoCkF6F0S5wuD+pqPmWERWy98Z8g7cbel0OZSV
	 JXdepc5qcopIFWpoOyJwcouMfGsDPtlA4aGbEsyqQOVBYrijklxerSYoCUubIfw+01JGo
	 rj2DphMJxySY1dwEC0ctYVhbRK64LTGM5SWvbdtBNR4c56QzCEDlv2xZrfzBIH/aO91ux
	 SHgz0D8FggE7a3YcNNS45LeGjd8b+5lshRJxVwpZ5JniI1G11VVU40IDVQPG330dY5WnZ
	 TepH4lfUBQ3EjnymFL5rplLpTXFTaFbUp5Ki6j+VcRa+VRBzF/SUmLaGezTxrt2pu4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVhb54Go4XSQOduzcTGER192U5xb4rdLHaWUmBMU3Z0=;
	b=wY45JHOSUK0ZZDDAOCnW7mAPis3b1HDwHZaxdwGh6VwBQb2fZxaC33mUD0eDxiwAXkwd
	 eoCAV1a/korHLZpkgNhI2lnunntvIePLxK8fTO8OI3YBL0Uwr29jtS7aC69k+9IDE8RRn
	 Y3Cqmtv8DgVYPEniC0nDpPe1DuR4rxt3IH7TllEx+ACSDwFr1PNoLILcreSnMQ5YHEMiJ
	 ycx0/AQtVR9qTKAaiI8OurRApMdShcZ7s7TEYoWcUZFvtQxPUsFU07VF8pii0y5hZKOyD
	 syX8hZVi7+tUcNIlnJSIa9lTpm1sXl+xMR6OV6fEefTm1oqunEf2FGgwFZCYoWzV9Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1KwND7S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAF8606A31E;
	Thu, 26 Nov 2026 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1KwND7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44391F000C6;
	Thu, 26 Nov 2026 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704418;
	bh=dVhb54Go4XSQOduzcTGER192U5xb4rdLHaWUmBMU3Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1KwND7SM3BFydIIBVOj82ptdrlroaemr8RwKhdSbqtJBm8SGpIO6JXVdBErGi9eJ
	 scUrdzNGPa5F62JPGX91dN50RQX2+3YeIKsF4RIh2KJXOPCCyhCpiVAzOihb5Xo2fi
	 /Vq+DvWog3y4eYAV3KW2vLIw6D+OZaRgtcELPdlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/265] SUNRPC: preserve timeout policy when cloning clients
Date: Thu, 26 Nov 2026 15:37:28 +0100
Message-ID: <20261126143613.282475639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 5b0ac1f82201c2ab2d9c31ed568cc782bac6a399 ]

rpc_clone_client() and rpc_clone_client_set_auth() leave the
timeout argument unset, causing rpc_new_client() to use the
transport defaults instead of the parent's configured
timeout. This also affects pNFS data-server clients and
changes their request timeout and initial RTT calculations.

Use the parent's cl_timeout when no timeout is specified.
Preserve explicitly supplied timeout overrides.

Fixes: 1b63a75180c6 ("SUNRPC: Refactor rpc_clone_client()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 0a4b4870c4d99..7205c6cdd7668 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -627,6 +627,8 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	}
 	args->servername = xprt->servername;
 	args->nodename = clnt->cl_nodename;
+	if (!args->timeout)
+		args->timeout = clnt->cl_timeout;
 
 	new = rpc_new_client(args, xps, xprt, clnt);
 	if (IS_ERR(new))
-- 
2.53.0



