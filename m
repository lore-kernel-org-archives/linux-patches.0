Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619366;
	b=h0demujmh+rvq1qs6DqeOmJeoV9BuTEZGp24J7KFgD7Nk1OqxQQGEOtTiObBsT57NBQ+
	 RrmBH1UvuH58db0vomNE53eH57XAl7BHiuWdwvKH3wPCswIEwO+dmYUuoCzM9kluO2Bic
	 sRgWRzgpAficAO2mYZ5wmJfbrlA4DO5T3cyjAAIAjHysspVrZDxDQbmqeL/rFlV0S6rnZ
	 enqQvOGS9g9aD06cfDuhEy8gK6QnV7LsDGhWYuwgXBplg7GvTxHhgfzlVNEIV2ql/w75h
	 KqdC49VEG1RwSUh3FvHCcvBhxD1TNzaikBWp1Os9d6vYIUDQusz0H02QvhL4PDMNMsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClYKCEB55bAE7z4m3nx+Re8HbvrTM5N9i/25J30bDC8=;
	b=OImTUy93m3P5VsVf/b3NI250T9nalXq42c+QBk3cT78zkHe4N0x+pf1U7AgK4iiRuk3t
	 RtVQe6VyMR7SF/lD1Whit6ixbTskmLkqOLQIKT8RoktDY0OQ4IRkhSQNSRNglx5IMvRki
	 ldrBGmf4bMXX6JJh/A9hVEtCmuK+xQA6+KN6a2JEDeXAWxPujk1nBgwQPq8UieJgW64qw
	 mQsc6H4ioFEuUiuouhnTox68k5OHhz4BWbVLCdsqa6Sjeq7St+nfR1iBQDr6/eBTE9xBZ
	 hEl3YWVVYZIbMuiNMBxnNWpPbJNcQSheFzV4aPcmiVYdhmp91ly0dsRKkuSQZaMpwsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVu9s0kI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D4E606A31E;
	Wed, 25 Nov 2026 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YVu9s0kI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8201F000CA;
	Wed, 25 Nov 2026 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619365;
	bh=ClYKCEB55bAE7z4m3nx+Re8HbvrTM5N9i/25J30bDC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YVu9s0kIa8ttmgQMunjfcU6I+bfU5X5JeEZ80FUZjecthNfykUu5XwSGMmhBTW4qB
	 dD7zT9eJzsZGk0AjpAerNeODVNVGC4ETRIh5+zHyiUDNSl3p+CKZ1ZaSkDxpykzIXe
	 W0hgDlkH0pJzbDVkdhv5qgDV9YxIualLwstgDQNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0573/1005] kprobes: Fix error return and slot leak in __register_kprobe()
Date: Wed, 25 Nov 2026 15:31:51 +0100
Message-ID: <20261125143835.172074185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 6a658cc2d605e5acf35e638c62f480460d5939cd upstream.

When arm_kprobe() fails in __register_kprobe(), the probe is removed
from kprobe_table and synchronize_rcu() is executed, but the error code
ret was ignored and try_to_optimize_kprobe(p) was executed, returning 0.
Additionally, the instruction slot allocated by prepare_kprobe() was
leaked.

Fix this by releasing the instruction slot via arch_remove_kprobe(p)
and returning ret when arm_kprobe() fails.

Link: https://lore.kernel.org/all/179375030756.247640.10859474201266455798.stgit@devnote2/

Fixes: 587e8e6d640b ("kprobes: Adopt guard() and scoped_guard()")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1711,6 +1711,8 @@ static int __register_kprobe(struct kpro
 		if (ret) {
 			hlist_del_rcu(&p->hlist);
 			synchronize_rcu();
+			arch_remove_kprobe(p);
+			return ret;
 		}
 	}
 


