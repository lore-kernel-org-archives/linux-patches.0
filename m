Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7268228E5F1;
	Wed, 23 Apr 2025 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421513; cv=none; b=LjLwxI5uX2+EkFi6Jx4Xl7+Pua9T/pI7B/N66y6dlLnpxFyt4n173rGPVDNFdEN3zeBy8bCcIC9XKBbcNhWInJnOf8aXOtC35CXy/XAIPrieTnUHVFqunPxqX8ee1qRmelHu8TMgkz0sPvgZkaUERBCrTtFfAx+dXr4K6ls6Xpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421513; c=relaxed/simple;
	bh=0z6VeDvhveUIcWGiFlA5L1cVwiBtGs7MMOW+t+eNe0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxwZq+cTLzUUuJZofKs6Y7dcG8HIefZ3D2CKt4SvMsq7+LC6IW5Hx+DMgkEuPAQ53QmIFby4yUGmHl2/xQBnF5cR0R9SOy7jkxNd3+iirjJKX9TTHNynuH+N17Kun8DTNJV/VPe/bWmAAvuLFFPiLH4gu+4hGV+VZxjaRB5wRqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oy3GPJUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oy3GPJUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034C4C4CEE2;
	Wed, 23 Apr 2025 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421513;
	bh=0z6VeDvhveUIcWGiFlA5L1cVwiBtGs7MMOW+t+eNe0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy3GPJUhrGa/JYViUymyvshf1UqkoA4pXpflTgQffy0A2IqvzoDsXSTuHgNgfpG0c
	 a3Q63pJm3T2fHS/Dnanw3R2XKxvvMAScnxZZm6eUJCdwL0zc078A9FjPZsoWe/l3lr
	 RYyJw5bvg8xGEzYKF4n/n/81VtpJAV2ci/2CZgmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 145/291] ftrace: Add cond_resched() to ftrace_graph_set_hash()
Date: Wed, 23 Apr 2025 16:42:14 +0200
Message-ID: <20250423142630.331183366@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6522,6 +6522,7 @@ ftrace_graph_set_hash(struct ftrace_hash
 				}
 			}
 		}
+		cond_resched();
 	} while_for_each_ftrace_rec();
 out:
 	mutex_unlock(&ftrace_lock);


