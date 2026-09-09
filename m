Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF09545D82;
	Wed,  9 Sep 2026 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962042; cv=none; b=QFAwrG0uP36TZx50Kc/MVXBreSIkQDjPkQ4oslA0uLEnKArktTrfU/bA4APUyJE/Hvk5nU6uJx3GCdH6XL6RxhNr+2KpYrh3TE8NQEa1YfjZazAZs0rocJHp0MqhN/z8/Fstr46HwCOjHJWjjBy7XJgwgdG42g9ujPZOnUVOFjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962042; c=relaxed/simple;
	bh=IhmpGJIjNiRgo3K9XLDAabUfTgSlEmvGuvS7h0cJ3fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZavq9DlCnFC5KgkOuepTFC1cspuXOcpA127MgDKoMM9svGpHtZk/T6MctagwjLigmAsd1RDfTDSDOeZ4DpNgiLB1M4Gh5PaCTr8VqBHrqx6i/NnW5sCypsMyi5NnLFra4JUXHZ1YA1YOq81d7pD43KDanmlIYNHhon82jveS0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DU87pQBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DU87pQBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146121F00A3A;
	Wed,  9 Sep 2026 13:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962041;
	bh=5C7gyf4q5BirYT/XUDswav17obJzgO6b9gOG21Wx+5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DU87pQByKyFaGntSR84uhW4gc8J7HPJz0Ff7prbdHtOjxiojdsSimT5Zk+Ck11gnr
	 Es4hZ3O8fzB0chaztTUr4kh3CZ+Io0BtxzlAznE2cKL09mYF0m6sLV7ZYxWIagyfOh
	 j9VMbClXJtfZZtya71+WLgGPts0fVr9FL++ZRei8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 152/556] ring-buffer: Allow splice reads on static buffers
Date: Wed,  9 Sep 2026 15:37:12 +0200
Message-ID: <20260909134235.783008402@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

commit 6365c44a824ff138e7926413932bb5c2e28a4c8c upstream.

ring_buffer_read_page() rejects splice (full=1) reads on static buffers
(that is user-mapped, persistent or remote) because !read check assumes
unread pages must be swapped. However for those buffers we have no other
choice than memcpy the data.

For the memcpy case, only return an error when the writer is still on
the reader page for the splice interface to wait.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901155445.1475405-2-vdonnefort@google.com
Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7182,15 +7182,8 @@ int ring_buffer_read_page(struct trace_b
 		unsigned int event_size;
 		unsigned int flags = 0;
 
-		/*
-		 * If a full page is expected, this can still be returned
-		 * if there's been a previous partial read and the
-		 * rest of the page can be read and the commit page is off
-		 * the reader page.
-		 */
-		if (full &&
-		    (!read || (len < (size - read)) ||
-		     cpu_buffer->reader_page == cpu_buffer->commit_page))
+		/* If a full page is requested, it cannot be the commit page */
+		if (full && cpu_buffer->reader_page == cpu_buffer->commit_page)
 			return -1;
 
 		if (len > (size - read))


