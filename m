Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFBB419FC5;
	Fri,  4 Sep 2026 06:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501951; cv=none; b=gdV+JDLDvaQglpOWJCLopc9KTpG8nLBOjf1hpHbS/7xGfpq/UPpYeOJKNTchoAPP5RLldrbV1nRxJpkDM1DLXmGvo7J36KLf/VsCrs4QrQ0UnP0IJV4xmCIuC7h6f2r8vnmXI+SVqsvhZaFqawHNZUSWEBlsX8+CCQ3XelOQ84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501951; c=relaxed/simple;
	bh=Es1y7tZE+Qz0EcIo3FPp0JYiKJxgPpT46WFvqOqAp9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhXgEj2WokiFKiaXbY2F6oLlMMEBIL7rmLKq4dOnrNtryB32/fZs499/cNPgM/bkBQbFs2pMQvW0eGMHg4+q/w4UweRGeAzTPpmaXUyEfUtJerlcFnUQRAFzG0ezQnhi1qJ370IVzuSna9ds9u6zhrWr2pzDp/IfT/YsbLvS0rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVhIP7xo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVhIP7xo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087771F00A3D;
	Fri,  4 Sep 2026 06:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501950;
	bh=tF9ob1xTSToh5bfbBWOf6KrBPMmBnZT75CESlKOJ8mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zVhIP7xofkgGAjq3EJZ3PJbyULNSLpBEbmnJ2DE1MGmpNaxZu5TabqIBcIc+HkHRW
	 6WW2r+KprzaKUxxbUJTWcmeZSq4vH0dtrlv4rYIiUBh2RWqlsJUF2EMtaHluE+HfHf
	 o26Eu/InjGpiqcvz4q0Qw1NttLSQaM5IdTPQusQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 036/403] tracing: Fix logged instance name on creation failure
Date: Fri,  4 Sep 2026 06:57:19 +0200
Message-ID: <20260904045735.634431520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

commit a9a01be2834a529cbd490ccbab02643f0c1735f2 upstream.

When boot instance creation fails, the kernel incorrectly logs "(null)"
as the instance name because strsep() consumes curr_str entirely during
parsing.

Print the properly parsed name variable instead. And while at it log
the error code.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260807085423.4175161-1-vdonnefort@google.com
Fixes: cb1f98c5e574 ("tracing: Add creation of instances at boot command line")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -10431,7 +10431,8 @@ __init static void enable_instances(void
 
 		tr = trace_array_create_systems(name, NULL, addr, size);
 		if (IS_ERR(tr)) {
-			pr_warn("Tracing: Failed to create instance buffer %s\n", curr_str);
+			pr_warn("Tracing: Failed to create instance buffer '%s' (%ld)\n", name,
+				PTR_ERR(tr));
 			continue;
 		}
 


