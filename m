Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535E40F742;
	Fri,  4 Sep 2026 05:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498518; cv=none; b=hzpdwvicwRdMd82v0LuNhjkvn/IfrW9yd79j2LsTCP38inZuDm09D/2+HaxUPePAjaL7xhqANU2ZoTjSqoaoMGVeGTFaHgiZPlG4GfW1Hydsj7fk9J3jgscgkwYgtuUa0yBkHECtDbjurkyxx8A1XB/sqL3b6HLMkhPwXTUyGX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498518; c=relaxed/simple;
	bh=v16HYZHhE2Yl3Vx9g8g16bfNIXfxAgNq/gi7Z8sdVek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1ID18J7oYtbdLzqeS53RpkBuVSjEbfIDofhqIajeZR/mSZpKF9VXF3eju6Z4A1YVOpNKehjadWYJtqk7LlKkwl//Jf937j90bNaQl+b6lWw71RrShF2QhTL+7B+2Use8q+JiEgTEU0axqLAffMvECY8CbHk5ljhuD2RWSquzTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlvsSIyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlvsSIyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1BA1F00A3E;
	Fri,  4 Sep 2026 05:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498514;
	bh=j2CsdK18T4RUuB9FcSMWsw2AFSQFbDHZWGILUaqoSq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlvsSIybN46ZPi68JHG8/AQrqVG0wRmtK+u3wJTja6T+DECnk+UAwj0vXj+lW1nEA
	 C8KaGBz/ZzSOly5tquUO84M/GlX+/Axhr0X7EUftylCZcXwu1iWIdjrPK9XbZuREcq
	 pUs2oqonotojDrMblueBjNS7Vhv8kiFPf9Zj/k/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Ivan Immanuel Shaji <ivanimmanuel1234@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 091/713] tracing: Fix retry exhaustion in simple ring buffer reader swap
Date: Fri,  4 Sep 2026 06:50:59 +0200
Message-ID: <20260904045805.879183611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Immanuel Shaji <ivanimmanuel1234@gmail.com>

commit e0d3aed7b12cf37b74c7cc5265073d0263b49cde upstream.

simple_ring_buffer_swap_reader_page() starts with retry set to 8 and
post-decrements it only after a failed link replacement. On the final
attempt, a successful replacement leaves retry at zero, while a failed
replacement leaves it at -1.

The current !retry test reverses both outcomes. It returns an error after
a successful final replacement, leaving the link update complete but the
reader bookkeeping unfinished. After a failed final replacement, it
falls through and updates the head and reader pointers as though the
replacement succeeded, which can corrupt the ring.

Treat only a negative counter as exhaustion and return the documented
-EBUSY error.

Cc: stable@vger.kernel.org
Fixes: 34e5b958bdad ("tracing: Introduce simple_ring_buffer")
Link: https://patch.msgid.link/20260825-kernel-patch-1-v2-1-bb3461807a32@gmail.com
Assisted-by: LLM sparse
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Ivan Immanuel Shaji <ivanimmanuel1234@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/simple_ring_buffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/simple_ring_buffer.c
+++ b/kernel/trace/simple_ring_buffer.c
@@ -160,8 +160,8 @@ int simple_ring_buffer_swap_reader_page(
 		overrun = cpu_buffer->meta->overrun;
 	} while (!simple_bpage_unset_head_link(last, reader, SIMPLE_RB_LINK_NORMAL) && retry--);
 
-	if (!retry)
-		return -EINVAL;
+	if (retry < 0)
+		return -EBUSY;
 
 	cpu_buffer->head_page = simple_bpage_from_link(reader->link.next);
 	cpu_buffer->head_page->link.prev = &reader->link;


