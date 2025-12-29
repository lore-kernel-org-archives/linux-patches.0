Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E34B31B111;
	Mon, 29 Dec 2025 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024899; cv=none; b=YQ9Cug7nndTaxrheQ6Mbg9J+k1rPgXte/GxQt7+EMbr7gsM51lnpLSIQaF0Z0/EqQ7ES3hJIHvO7GZ8DoIJ0Rrt2mpS1kaRe1+36DwsFICoqfL1GhCH0y3b4Sv/Sxj+tK/k5zV5WyoVFOj9DAJQTXoXleOaqO1S5DUuP3WLUkSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024899; c=relaxed/simple;
	bh=QpHmL35HbN5vF8qyLfVMokCvevAy4iUbO/uI7T0Lss8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LshxMBqZr3IVLIcA+CO+HibV/BNGhJE1CUcZ0jPWQ8U5eslpfHkRCXLjcGvfx+F9sDzYMvOSSGjD6MUnlADsVpmuz2klxwYCOtt0kMN54Byate7dYJSEtC08/+1DuFVAKOEw42lWTuhCGbsUmE74+KQ3UagTmxyo8oQtbHgXK1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiUYCmdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiUYCmdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187A5C4CEF7;
	Mon, 29 Dec 2025 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024899;
	bh=QpHmL35HbN5vF8qyLfVMokCvevAy4iUbO/uI7T0Lss8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiUYCmdIW4tu3g4tuWhVsojEQCXWqO9eINQFZlA0VdQnNh0KxY4rLGKC0LyFgGGfr
	 GwyC3HfBZRzKTYfolPagsHv6cgo1bY4R+D/X5o7P0fvvndSiaAFY55sN/8L+LFRGEY
	 ogJuIaCF08wMLQR87O44d3E7mc39GprTb4/1lySY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"T.J. Mercier" <tjmercier@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/430] bpf: Fix truncated dmabuf iterator reads
Date: Mon, 29 Dec 2025 17:06:46 +0100
Message-ID: <20251229160724.309687108@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: T.J. Mercier <tjmercier@google.com>

[ Upstream commit 234483565dbb2b264fdd165927c89fbf3ecf4733 ]

If there is a large number (hundreds) of dmabufs allocated, the text
output generated from dmabuf_iter_seq_show can exceed common user buffer
sizes (e.g. PAGE_SIZE) necessitating multiple start/stop cycles to
iterate through all dmabufs. However the dmabuf iterator currently
returns NULL in dmabuf_iter_seq_start for all non-zero pos values, which
results in the truncation of the output before all dmabufs are handled.

After dma_buf_iter_begin / dma_buf_iter_next, the refcount of the buffer
is elevated so that the BPF iterator program can run without holding any
locks. When a stop occurs, instead of immediately dropping the reference
on the buffer, stash a pointer to the buffer in seq->priv until
either start is called or the iterator is released. This also enables
the resumption of iteration without first walking through the list of
dmabufs based on the pos value.

Fixes: 76ea95534995 ("bpf: Add dmabuf iterator")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Link: https://lore.kernel.org/r/20251204000348.1413593-1-tjmercier@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/dmabuf_iter.c | 56 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 49 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/dmabuf_iter.c b/kernel/bpf/dmabuf_iter.c
index 4dd7ef7c145ca..cd500248abd95 100644
--- a/kernel/bpf/dmabuf_iter.c
+++ b/kernel/bpf/dmabuf_iter.c
@@ -6,10 +6,33 @@
 #include <linux/kernel.h>
 #include <linux/seq_file.h>
 
+struct dmabuf_iter_priv {
+	/*
+	 * If this pointer is non-NULL, the buffer's refcount is elevated to
+	 * prevent destruction between stop/start. If reading is not resumed and
+	 * start is never called again, then dmabuf_iter_seq_fini drops the
+	 * reference when the iterator is released.
+	 */
+	struct dma_buf *dmabuf;
+};
+
 static void *dmabuf_iter_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	if (*pos)
-		return NULL;
+	struct dmabuf_iter_priv *p = seq->private;
+
+	if (*pos) {
+		struct dma_buf *dmabuf = p->dmabuf;
+
+		if (!dmabuf)
+			return NULL;
+
+		/*
+		 * Always resume from where we stopped, regardless of the value
+		 * of pos.
+		 */
+		p->dmabuf = NULL;
+		return dmabuf;
+	}
 
 	return dma_buf_iter_begin();
 }
@@ -54,8 +77,11 @@ static void dmabuf_iter_seq_stop(struct seq_file *seq, void *v)
 {
 	struct dma_buf *dmabuf = v;
 
-	if (dmabuf)
-		dma_buf_put(dmabuf);
+	if (dmabuf) {
+		struct dmabuf_iter_priv *p = seq->private;
+
+		p->dmabuf = dmabuf;
+	}
 }
 
 static const struct seq_operations dmabuf_iter_seq_ops = {
@@ -71,11 +97,27 @@ static void bpf_iter_dmabuf_show_fdinfo(const struct bpf_iter_aux_info *aux,
 	seq_puts(seq, "dmabuf iter\n");
 }
 
+static int dmabuf_iter_seq_init(void *priv, struct bpf_iter_aux_info *aux)
+{
+	struct dmabuf_iter_priv *p = (struct dmabuf_iter_priv *)priv;
+
+	p->dmabuf = NULL;
+	return 0;
+}
+
+static void dmabuf_iter_seq_fini(void *priv)
+{
+	struct dmabuf_iter_priv *p = (struct dmabuf_iter_priv *)priv;
+
+	if (p->dmabuf)
+		dma_buf_put(p->dmabuf);
+}
+
 static const struct bpf_iter_seq_info dmabuf_iter_seq_info = {
 	.seq_ops		= &dmabuf_iter_seq_ops,
-	.init_seq_private	= NULL,
-	.fini_seq_private	= NULL,
-	.seq_priv_size		= 0,
+	.init_seq_private	= dmabuf_iter_seq_init,
+	.fini_seq_private	= dmabuf_iter_seq_fini,
+	.seq_priv_size		= sizeof(struct dmabuf_iter_priv),
 };
 
 static struct bpf_iter_reg bpf_dmabuf_reg_info = {
-- 
2.51.0



