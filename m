Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC081EB1BF;
	Thu, 17 Apr 2025 18:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913697; cv=none; b=KkHa+xdg6aadFePjvNuGQVepv5uf/h07i+Qcwnjf9eUhVwY0d3E1YtFumOpbucofefb+/y5usOP2Ac2BlG4Zku1prX+l5YbM7UfYoaHVi1NTPd1ziV1HIRA5Egrig3z0eiK6/A4mw2pYeNB3g1+bjf8f2dlzo6CAlpEyoEQXptA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913697; c=relaxed/simple;
	bh=3f+1YgvHBI6hrTQ7Yh/YrO98nQoPkwBtydK7Hw7Ue/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1bKaoM0+zKkLRHEtS4zd+NpI8OnWwTm8xkxEKyY5IY7LxHymbH70n8KYMWhbkX8oWpNPuZbSdJMg+IuYIfjP9F2N67A2ZH7JUxyX5dPCFi6bdXna0EufSK0lZ+EdQWOcwRDRfwmJeePaJjRThYyqBg10jLJxg1rnH0UCzzaPDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Zx9cNhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Zx9cNhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF518C4CEE4;
	Thu, 17 Apr 2025 18:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913697;
	bh=3f+1YgvHBI6hrTQ7Yh/YrO98nQoPkwBtydK7Hw7Ue/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Zx9cNhKxBdH7BUBf8S2ooeNtAOGP3wtp9owPzGmMXVSm4ciiqYhu70FLkerbfPrt
	 Phl6frhuAFEepDulfKniQj2QypCkPzUoFW+C1re+ZcmclLFSCCncBBeMp9zcRTbb71
	 9BYCraXKP+oq8T18mwSm2MqfWdoZ/aRGwLfFiuMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.14 394/449] ftrace: Add cond_resched() to ftrace_graph_set_hash()
Date: Thu, 17 Apr 2025 19:51:22 +0200
Message-ID: <20250417175134.124534964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6853,6 +6853,7 @@ ftrace_graph_set_hash(struct ftrace_hash
 				}
 			}
 		}
+		cond_resched();
 	} while_for_each_ftrace_rec();
 
 	return fail ? -EINVAL : 0;


