Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F59641A794;
	Fri,  4 Sep 2026 06:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502526; cv=none; b=H71CO5zYkRbRWehY1CwjcnvNh9bXWNK4z8OjMNCzeQdNvpocFIofgAxatKi9ClwNWYm0DuM4tzIPQ93zxHFo/Ex0SWZ4icfgjCalKvgifLVbgf6y1SEjTxhKcmCNZ/BeAu2XUKlAQ19I/nHNuDiYNKK4FwtUmn9RkwCf4SHZlAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502526; c=relaxed/simple;
	bh=WDMuoLlAtJb2vmuhc6l2a0nm2995qIRsQbds3PVr7mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMhAOBlZt4Bk8N3Mktawxwaev3mYdH0vKpn9DefhUzY8LsY3t/NkaM1+Y6Zur476WYxVsB9tp3Ut3ODB+jh2c1BayfdDD8+NxFHWjkOc2SI+laEUhZjjsrcZc53mm5Rmi7AmN9N6vVvqXob6zNw/RA4/tEoPHcwOIwgpl52BNrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnrtXQ6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnrtXQ6A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82241F00A3D;
	Fri,  4 Sep 2026 06:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502525;
	bh=DwHPqImB8hK9MAKmz39NursQ3DH/YfA1SHJlu561xMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnrtXQ6A1smpk30V0GbEO5VuuTq6kR+O0vMztIf+CLgoUpCOtfFZl6R797S+VWgd7
	 NAIeB8vcsAtunM93GrDj15fV6cVcZ/ZCzZc7o2x0d5JaNZZsUith8LB9mK3gy5mWuD
	 eJ98EaVnaaAGdhIMykBpR1EqcBGAqzPOhihRohYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 239/403] ring-buffer: Hold cpu_buffer::lock when resizing a subbuf
Date: Fri,  4 Sep 2026 07:00:42 +0200
Message-ID: <20260904045740.304638506@linuxfoundation.org>
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

commit 24974bd0da1b47fd56c975533ead50abf754e74d upstream.

Because, ring_buffer_subbuf_order_set() can clear cpu_buffer->free_page,
hold cpu_buffer->lock to prevent races with
ring_buffer_alloc_read_page() and ring_buffer_free_read_page().

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260813131152.3589632-3-vdonnefort@google.com
Fixes: 8e7b58c27b3c ("ring-buffer: Just update the subbuffers when changing their allocation order")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260810125633.3344684-1-vdonnefort%40google.com # patch 3
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6814,8 +6814,10 @@ int ring_buffer_subbuf_order_set(struct
 		cpu_buffer->nr_pages = cpu_buffer->nr_pages_to_update;
 		cpu_buffer->nr_pages_to_update = 0;
 
+		arch_spin_lock(&cpu_buffer->lock);
 		old_free_data_page = cpu_buffer->free_page;
 		cpu_buffer->free_page = NULL;
+		arch_spin_unlock(&cpu_buffer->lock);
 
 		rb_head_page_activate(cpu_buffer);
 


