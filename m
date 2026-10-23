Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774739;
	b=O9fVQioWNtB6jCeE7SysnFJ9NAB7bSuuhLhGfkIVY6xJvdCKNhBzM4YXC7b/HkkX/Jyi
	 00o22/yF9QIajRScNSFTe2tWy+YNstwkBWq2fvm6Wi3kbBdkifoNZGz90MAamBFSEa1Yy
	 H4MkPXVeA5g05D9MO3Ef5X2VUV+Z6DP/5ZM2t57llGOrr2jYEb0MPZuR3BmcpK7FEaKFg
	 Aaoq0AwNXt4Etqg08o9sc8AYFXRm6Edw2e9xtNcXipYDzF+sKp66dj9Ff/1hlQAwcfShm
	 DMeScyrb1HfAXk0XBikTqv1WOMeq8v5T1tqt1QKSJ3H5y++mnuIJytdU+r91vr6PJfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NeNXWwueNI9M2SdMCUMAw3WpTpbgkitBtbRF6AKwwqw=;
	b=K77MNMowHoMwtzL8Lys/fbpFSildUDl0pVopoa31BdRWPDHdlfOJCKWXOclNFHip6/uG
	 QUTQgq3JxIqs9HhekHAzYcRXCepRtla4M7gI6MyQorc4EVeeK3jr1pAsoQtIGGs7shz/x
	 HVudJJ6CkYyqJv4vnM9sQTi6PCQx7b6IKpY7bWYD3QYpb53x/5MiW1/MupsPg+xR8ZjNF
	 d3BbjhLxxQaRIXS7X1pN/+Gar9+Eiq4FWZ95CmwxD9ww8wc7LaQ/S7sqO+TNeYwUKeJ2P
	 06LLA8Cf+FdkqcApiywznNz8ZQoJQ6dfHtEa6Qaybn+GKrsw7tyMzCo4w3SP0GSI7xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQyfjNlJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D24B606A31A;
	Fri, 23 Oct 2026 16:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uQyfjNlJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990241F01828;
	Fri, 23 Oct 2026 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774739;
	bh=NeNXWwueNI9M2SdMCUMAw3WpTpbgkitBtbRF6AKwwqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQyfjNlJemmhIYIMIpiQe2PFtHWj+Tnf+gQAh5CpM55z1XGZwFbbWK7BzDu9QeZ2t
	 e4AZdcnyF1bbry1lrd8ejXnMvdlDZGYPjGdlgANotGnM1IP0yvE3t23tealoOJYmvH
	 r8WcH7n24xfE/WSIOup6wnjFIYaLAvNuIhRT1vhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com,
	Krystian Kaniewski <krystianmkaniewski@gmail.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 143/242] ring-buffer: Fix false warning in ring_buffer_map_get_reader()
Date: Fri, 23 Oct 2026 18:39:45 +0200
Message-ID: <20261023163717.162732457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

commit 89bab1dba8a0167ef0d819e0f55b6bafa038e87f upstream.

The mmap reader can warn when it catches up with a writer that is still
committing events. rb_get_reader_page() returns NULL in this case, but
ring_buffer_map_get_reader() treats that result as an error.

The initial rb_per_cpu_empty() check filters out an empty buffer, but it
does not guarantee that the next reader page has committed data. Writers
do not take reader_lock and can advance commit_page before publishing the
committed length on the new page. rb_get_reader_page() can swap to that
page, catch up with the writer and return NULL.

Handle NULL through the existing no-data exit without warning. Remove the
caller's reader_page == commit_page check as well, since the reader-page
helper already handles that case. The existing metadata update and return
path remain in place.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260924084946.20104-1-krystianmkaniewski@gmail.com
Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
Link: https://syzkaller.appspot.com/ai_job?id=488adc18-a10e-42d2-a205-25327c38837f
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7982,12 +7982,8 @@ consume:
 		goto out;
 	}
 
-	/* Did the reader catch up with the writer? */
-	if (cpu_buffer->reader_page == cpu_buffer->commit_page)
-		goto out;
-
 	reader = rb_get_reader_page(cpu_buffer);
-	if (WARN_ON(!reader))
+	if (!reader)
 		goto out;
 
 	/* Check if any events were dropped */


