Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22387264619;
	Thu, 17 Apr 2025 18:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914876; cv=none; b=OcYTt3wq3V3jgc7VICD7N0R4rJwkhzAu7/dCNtlX7y9KyQQNwDVTYN0dMvw+OK+H3UNBh/oCzxVfBaRdR4mksNo2LAJzNG4ouFjOquZUEJrYjn6nPfJjdISRGDyx4dv7+aRXxBSuKEGqHRhRrCpATc3MtcXAyrrcBb2c1moU4hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914876; c=relaxed/simple;
	bh=ofhkt00YnWe7FXNm75tqyUeiFmNBCDnYLtq8PYVEJp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ8wObODuJZIsJomXpibAehDTHdnJbtaEVjy5p/d1/EXhR4v73+IYssu42h9u94Ibjf+Y3KoMb6+pVLslnryqnL/Qx380/oOls1O/ucoW5vMCp3ZZvDnK62QD6TMeBrMuejdwnye7GB0S/0ZgctPVs+WcCSRq4HmO+yF4jqhwbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9E4PR2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9E4PR2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29F2C4CEE4;
	Thu, 17 Apr 2025 18:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914876;
	bh=ofhkt00YnWe7FXNm75tqyUeiFmNBCDnYLtq8PYVEJp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9E4PR2shp8NmEsz3Rr9rDt+FflSFPItvoGNRN5hUKoGWKz9P1HtWn2S537KhhUYi
	 FOhcRLxrNWdtvgP88m2BMf4kp5JlLLz03Ssr5AX+FEEiXTlKSV3qYslx5duZcDdKJG
	 zSjnk/EwRbUdfGreGT5PDTjeCv6W0/5qkGYR9110=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.13 359/414] ftrace: Add cond_resched() to ftrace_graph_set_hash()
Date: Thu, 17 Apr 2025 19:51:57 +0200
Message-ID: <20250417175125.902755414@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6858,6 +6858,7 @@ ftrace_graph_set_hash(struct ftrace_hash
 				}
 			}
 		}
+		cond_resched();
 	} while_for_each_ftrace_rec();
 
 	return fail ? -EINVAL : 0;


