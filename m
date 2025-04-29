Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8BF242D6E;
	Tue, 29 Apr 2025 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946851; cv=none; b=KBnfxOE7BaxiLdAyL1vUWXyHUzpxWeOZrT7hycChwdpiY+V9/rP0sZHqPhLSHf8ycUfxxoedevzyZejIDD5qSupD/e0gck5l06SiBvVSjmYj/p/uQdWXD/RCSbhb90piQucPOhkx4Smv9mibpURuWKRQaf28OozTYv3zNw8Mu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946851; c=relaxed/simple;
	bh=k++T/4YMjhA4i1Cxb5cbEXU8LehiFOoTcNKb1vm4Rc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw3LurhtOQ2NikV1RoGREwlfz+ZNFaOSygPaJG2U3/fDXPnsE2X7WOV4vWwdi7x2aLUXH56JsCWPYykjokkXujsI5kN1pv3kYLWiAaj1r+teBgABvgZpnAByUdEClxv9loJJ0wV4BgxVHSEKHbpaKN2j7DaP91pkk8suC6Ghw6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDzJylpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDzJylpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D455C4CEE3;
	Tue, 29 Apr 2025 17:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946851;
	bh=k++T/4YMjhA4i1Cxb5cbEXU8LehiFOoTcNKb1vm4Rc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MDzJylpBVYJwMYTiBO7ShHxPEyA4syX0JJ/GaCdmG7/DCOu3CKs8102XuZqEVW1Y0
	 tF67+vt7UE7JT5jra1yn7Md7a+Bl+tZb6SUuw/hzvtJiEW1bQwRWs9EHjA48mnWecl
	 tuyrZ3s82sJVb6527nlyzBny4OSw809cVn3gn6jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 089/286] ftrace: Add cond_resched() to ftrace_graph_set_hash()
Date: Tue, 29 Apr 2025 18:39:53 +0200
Message-ID: <20250429161111.520663289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhoumin <teczm@foxmail.com>

commit 42ea22e754ba4f2b86f8760ca27f6f71da2d982c upstream.

When the kernel contains a large number of functions that can be traced,
the loop in ftrace_graph_set_hash() may take a lot of time to execute.
This may trigger the softlockup watchdog.

Add cond_resched() within the loop to allow the kernel to remain
responsive even when processing a large number of functions.

This matches the cond_resched() that is used in other locations of the
code that iterates over all functions that can be traced.

Cc: stable@vger.kernel.org
Fixes: b9b0c831bed26 ("ftrace: Convert graph filter to use hash tables")
Link: https://lore.kernel.org/tencent_3E06CE338692017B5809534B9C5C03DA7705@qq.com
Signed-off-by: zhoumin <teczm@foxmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -6096,6 +6096,7 @@ ftrace_graph_set_hash(struct ftrace_hash
 				}
 			}
 		}
+		cond_resched();
 	} while_for_each_ftrace_rec();
 out:
 	mutex_unlock(&ftrace_lock);


