Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C61D257448;
	Thu, 17 Apr 2025 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916084; cv=none; b=gOOdX6y+pQAJd9DW7Ygnst3e9jqQTVlmgljyuKCcFviY3EMQHErY/Xu9wpRMn+OIcr6V/SdEWwZmmPQYhUn9uNBytNTe9kgw1E+OCfyO1t5e3D5yiPbRIB/pg/VJ0jZqtvnS2TXfkWmMpH/sUNI4v4X/6jGlzIV4G/+wFBmx4tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916084; c=relaxed/simple;
	bh=5esZfmXJvS8yYdlLk+W8IHVMzZ/I2KUKepSmMJw4ym0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZu4otOsaw5+N5BHQCJ7BxaIzh+sKvi1JvoqxKL832B0Um7/YU7GPSNB0WJky+bU2PyP/2OR543fIH37V9lXm/EDCY4xNS+fmkP2G9LFZKkGyEp2pUV9AKQ7vkIgqjm0L/IMKzs5i/e7peDNKXBzOjVLWxVuIe1R19jEt3ShLgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2PLaAEi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2PLaAEi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855C1C4CEE7;
	Thu, 17 Apr 2025 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916083;
	bh=5esZfmXJvS8yYdlLk+W8IHVMzZ/I2KUKepSmMJw4ym0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2PLaAEi8kmjqG2V7CniXiy3Q2tNAOdztFJkRip/Tnjy3K65XEgRrEl5BwY1ukyKtE
	 HGa4fbZqKCJtca9XuafEVq3dX570Rkskd6mhy43MjP5C7BUrvtcS7biVB7x3r+qH9E
	 0CghFFv++/u1lWgi6JCBNCjgAgIRw1oFmNUst6AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 337/393] ftrace: Add cond_resched() to ftrace_graph_set_hash()
Date: Thu, 17 Apr 2025 19:52:26 +0200
Message-ID: <20250417175121.154118091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6848,6 +6848,7 @@ ftrace_graph_set_hash(struct ftrace_hash
 				}
 			}
 		}
+		cond_resched();
 	} while_for_each_ftrace_rec();
 out:
 	mutex_unlock(&ftrace_lock);


