Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03661351C04;
	Fri,  4 Sep 2026 05:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499665; cv=none; b=DdJHgF+bSSqSkZiHoOcxyzXhDg3X6gVIcR5H8n2jt/5M69yS1HaDZVyRmu+xRfIeQVgp5GRdH+n6x0PH4tXKstvk99GmjYtuST0NVHYpyPefiKjmRiLDdtIIGyoK+pZtccOSl3vtaJBtjTWLcG28vb5b/Uzf1ycLcAPfaeDG550=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499665; c=relaxed/simple;
	bh=eBIrsW1xjM8s4hfV6kSf0zKqEPZp9J49vuivIlC1FJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JR03TaJHMoZa4aSJI8y2yg+tC8qtLP2lSmVnAAEma1DXSX0eDYc9JhG9gZsL7LtDPS+RMUVrcwQR4sEVPrSu0DLUOLDkU5ZxLsEWKdGbrRISGpWi47W3v96leiioqD9NW3z9ByU+WVS+PkFaZdFYQWRkyWKy3xmXbTIEL7NIzxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYZw6NP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYZw6NP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8BE1F00A3D;
	Fri,  4 Sep 2026 05:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499663;
	bh=kkTEMaziiJCvxYtg2uQqvAMbUqqIi7C6CEOGbPdkPQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYZw6NP1RzN+qgzGhtzX0MQjVEIq3E5MKoVzZnAS9yHhFZU3uQaRnUZy4L7qUmJW/
	 txza3kGqxV14Pl8w5uBcEM1U5Gi+b0DvrPLIBMWy4f+cyNvgkvuUhW7HJx9ogcfFcE
	 4iNtLRC8hycebKDpyZGbTP2GQmtpX8SMMHZ5U09c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 454/713] ring-buffer: Hold cpu_buffer::lock when resizing a subbuf
Date: Fri,  4 Sep 2026 06:57:02 +0200
Message-ID: <20260904045814.003118771@linuxfoundation.org>
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
@@ -7477,8 +7477,10 @@ int ring_buffer_subbuf_order_set(struct
 		cpu_buffer->nr_pages = cpu_buffer->nr_pages_to_update;
 		cpu_buffer->nr_pages_to_update = 0;
 
+		arch_spin_lock(&cpu_buffer->lock);
 		old_free_data_page = cpu_buffer->free_page;
 		cpu_buffer->free_page = NULL;
+		arch_spin_unlock(&cpu_buffer->lock);
 
 		rb_head_page_activate(cpu_buffer);
 


