Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C71F7587;
	Tue,  3 Dec 2024 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239696; cv=none; b=YXKdaQpuntA32zZsfvSgLZ1EThQay6TEe8tIzPWh8i+IRlGPJx4JBkCEZs7X3gsJuA3PulA6tZxdqvM7Wl07//6idHrarIhN6vv/Q9vG4uKC3KXNYLxpJhngPFZj75wQoEEP4DVENKi8aCHHv66A3oqRXFdUZO0kC6KbYWRkGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239696; c=relaxed/simple;
	bh=XJ7kNfq1SUZEqWZKVWuYXnLZgyIr6/WYG3Rc7lmG748=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGZUY6mzJAMvBcgrRUjCO8+7/t8Cc1yQ1pxfqxA/9OHGgRDDauMD/xnlFC+z/w9B7eQXcUv3/MD9dXFA0Rzx4GMnUNFdBUEN0KSUmo9Dtslg4dBdv/TP/D0muqX10TsGpRC+WIaiMPqpwYSKDyQWBgVuUed93mXRTLPFsShnuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHG8Rqop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHG8Rqop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B17DC4CED6;
	Tue,  3 Dec 2024 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239695;
	bh=XJ7kNfq1SUZEqWZKVWuYXnLZgyIr6/WYG3Rc7lmG748=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHG8RqopNO7Squ+aWDrpBYpDBCMSRol50iL22jLzXUxVJ3r1wB/vKu5TTpfoS4ZcX
	 tqXcAgJFO4q5l/ul6BXsudolBgFjowWrW/WiXhsrNrLQhPATAQnNTZGePQI5A5CJU5
	 S1u6xHWrONCMqXr3s3PIGlhQT6BnLlEchEcvvfhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.11 702/817] parisc/ftrace: Fix function graph tracing disablement
Date: Tue,  3 Dec 2024 15:44:34 +0100
Message-ID: <20241203144023.381331513@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit a5f05a138a8cac035bf9da9b6ed0e532bc7942c8 upstream.

Due to an apparent copy-paste bug, the parisc implementation of
ftrace_disable_ftrace_graph_caller() doesn't actually do anything.
It enables the (already-enabled) static key rather than disabling it.

The result is that after function graph tracing has been "disabled", any
subsequent (non-graph) function tracing will inadvertently also enable
the slow fgraph return address hijacking.

Fixes: 98f2926171ae ("parisc/ftrace: use static key to enable/disable function graph tracer")
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/ftrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -87,7 +87,7 @@ int ftrace_enable_ftrace_graph_caller(vo
 
 int ftrace_disable_ftrace_graph_caller(void)
 {
-	static_key_enable(&ftrace_graph_enable.key);
+	static_key_disable(&ftrace_graph_enable.key);
 	return 0;
 }
 #endif


