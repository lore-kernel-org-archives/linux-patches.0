Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81263191496;
	Tue, 10 Sep 2024 10:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964026; cv=none; b=cfyTc5mTeBKozpXs7Axp6TIVv3ydV/72lFaoLjX+19Pm9kY3aLyd7CrdKmwNhiltWKDgwQMr433STJXvMT/jhdQMMLMqKxIJoNVvGLbRSbcEBRlKU3gxLZcSVgbjPl9G5YvZw8eJkIBOc7zX438b9iMGeAz1aBaB4KTL4vwZhBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964026; c=relaxed/simple;
	bh=NS85PktJRETKrpjWU7nre0m/TrvuiXlMljaD2DFD87M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2PaX0N00Pp/fiF9ExqBUckyMUnlGBWru1d+TEvNcMVUWlzrbJ9Xdgr92Ab2QQy8pHIsMJIIQdHM20b3QqQtVEceQ33P0HGTXjPq/35WfRBHoR2G4OdGfAtz15vH+Jm0gGd3XtUVELm4Yab0C45Jd9zVdG7u/ng2EHYRF48WSs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWoSlgz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWoSlgz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A1CC4CEC3;
	Tue, 10 Sep 2024 10:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964026;
	bh=NS85PktJRETKrpjWU7nre0m/TrvuiXlMljaD2DFD87M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWoSlgz+3QizXFCRSnOwSrKkIcaUG0Zm2GAkCTwSnv0bFS+1F6e7NMcUw9wXLVUuX
	 Vx+pSF6SjjTn0G/26ypd8qdOXtwt8elOBvuYJWvBrJhcBi53do4JHwEHoV03tdIryY
	 kxDUCpatgwdZENdF5xn1uYk27mgKGQ24MHInMYEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian@huaweicloud.com>
Subject: [PATCH 6.6 043/269] tracing: Avoid possible softlockup in tracing_iter_reset()
Date: Tue, 10 Sep 2024 11:30:30 +0200
Message-ID: <20240910092609.790924201@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Yejian <zhengyejian@huaweicloud.com>

commit 49aa8a1f4d6800721c7971ed383078257f12e8f9 upstream.

In __tracing_open(), when max latency tracers took place on the cpu,
the time start of its buffer would be updated, then event entries with
timestamps being earlier than start of the buffer would be skipped
(see tracing_iter_reset()).

Softlockup will occur if the kernel is non-preemptible and too many
entries were skipped in the loop that reset every cpu buffer, so add
cond_resched() to avoid it.

Cc: stable@vger.kernel.org
Fixes: 2f26ebd549b9a ("tracing: use timestamp to determine start of latency traces")
Link: https://lore.kernel.org/20240827124654.3817443-1-zhengyejian@huaweicloud.com
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4156,6 +4156,8 @@ void tracing_iter_reset(struct trace_ite
 			break;
 		entries++;
 		ring_buffer_iter_advance(buf_iter);
+		/* This could be a big loop */
+		cond_resched();
 	}
 
 	per_cpu_ptr(iter->array_buffer->data, cpu)->skipped_entries = entries;


