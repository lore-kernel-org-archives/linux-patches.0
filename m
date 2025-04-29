Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFCF132103;
	Tue, 29 Apr 2025 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948765; cv=none; b=ICZIP+M+fz0sInFhv+ZO+m2g+mfJfVUFJYVjBR47jdAIQT+QzRB83aSHyz3Rqz+QeLoS8b1vzoVbJla6F4eqbeP3ENBy+m3AR4U5bkHqiCGBFSHAisUW9PA8KWcNyvhQQbxn3EtAkQK30y75a8rUyimmkooQZa1Yuo3m1rntqH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948765; c=relaxed/simple;
	bh=hLK6eSY/iAC+S8Vp8OcZfZeIY5KfWI2sB/TKDFMY8gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSwddFM/JxxvH906lko9ZvGybD5VILkrRhzYqXQ9OcDqa6nzjb+WE5e9V1WGf8hVE4TdNSeYE5tb0vkP+rRkNmaOhF5zdeLvfvSvpvhwMRP15J10R2ZAVFAAWDxgGRHoMpinzRUHYegBCo9I6I0pZ9M+5skLylOMUcvB1mnNW20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKBpuDb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKBpuDb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F80C4CEE3;
	Tue, 29 Apr 2025 17:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948765;
	bh=hLK6eSY/iAC+S8Vp8OcZfZeIY5KfWI2sB/TKDFMY8gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKBpuDb2nBCpuT45O0AB4WKfblx0k7yLZJoTP95ZeaBxiKIvVse0vc1f/fGQtXEDO
	 weLCm2vWAy/tiBudQhktF+p1xHiMjN7KHe+lNxXBmcuGuKx5A0pT0HubnQgNjEhZzb
	 8XOLRHlwdhXYS6vAg2VSGE8Avm4T1nynXissTH6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhoumin <teczm@foxmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 106/373] ftrace: Add cond_resched() to ftrace_graph_set_hash()
Date: Tue, 29 Apr 2025 18:39:43 +0200
Message-ID: <20250429161127.530749242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6090,6 +6090,7 @@ ftrace_graph_set_hash(struct ftrace_hash
 				}
 			}
 		}
+		cond_resched();
 	} while_for_each_ftrace_rec();
 out:
 	mutex_unlock(&ftrace_lock);


