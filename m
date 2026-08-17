Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA553DB310;
	Mon, 17 Aug 2026 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974564; cv=none; b=nOgymnjyfojl47u+KcKwptw4as/eyHT7eTpW9Hul4cDQ0kJMCBMaBvXE/I5Qc3SHg8nbugNQC0Z018avBgtn9ZQpTdUgn0mtw+8k3hyiR/wY4NulBHE8u7/kPGMaX7AgeFueoZBfiSChHfqyvYaNNW9Ajb9dvlhTDb/wK/rTdJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974564; c=relaxed/simple;
	bh=UKEkGTd1vbsZWs/X6DSwt6YcZxVOi3ZVPgox8GesCYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUHBhmfZDecNUxC81rlzAIdOa4moKteut1KrnC46vgWNg61B8mB0t2G4diRnfdwH4u4HKxKhOZLENGY+vcSqtKind8Hj/hbIq/l/z1DDJVi2EXau4HRpue2rkSadp3Fz9HVWo5UPrmM8cInkcuUS80TE45q2JL9NxemUsUwcIuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=riGw4yYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="riGw4yYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DF31F00A3A;
	Mon, 17 Aug 2026 13:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974561;
	bh=Tz69K/WAyewqe1E/WnD+wAGOa+GTKwUiLQjKw2+qm9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riGw4yYOn2KntszsI+5QOnpHrnn8HNC6+S1CyGgiajX3VrKIX5Rbjmf4ODGEz4qkB
	 aE4pnDRgCDnyPy04gnCyA3Sp/Lfo0NCy1CS/19YQxMf6V2KhPlvfM3HNPjpuIfo1Cb
	 rKuIVZU7tAs5bHTUI5vAyq+uvgD/sgVM+iKv5+Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 246/271] ring-buffer: Prevent resizing of persistent ring buffer
Date: Mon, 17 Aug 2026 15:32:51 +0200
Message-ID: <20260817132546.871386819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Donnefort <vdonnefort@google.com>

commit 7c727dfce6be04dd009b29091a4a17d952dbfe03 upstream.

Dynamically resizing a persistent ring buffer is not possible. Disable
the feature.

Cc: stable@vger.kernel.org
Fixes: be68d63a139b ("ring-buffer: Add ring_buffer_alloc_range()")
Link: https://patch.msgid.link/20260806211306.3704194-2-vdonnefort@google.com
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2418,6 +2418,8 @@ rb_allocate_cpu_buffer(struct trace_buff
 		if (cpu_buffer->ring_meta->head_buffer)
 			rb_meta_buffer_update(cpu_buffer, bpage);
 		bpage->range = 1;
+
+		atomic_inc(&cpu_buffer->resize_disabled);
 	} else if (buffer->remote) {
 		struct ring_buffer_desc *desc = ring_buffer_desc(buffer->remote->desc, cpu);
 


