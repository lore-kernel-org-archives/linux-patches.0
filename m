Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C2530566A;
	Fri, 15 May 2026 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860547; cv=none; b=Ok1pkczNG4t1dIA05+5Iqp7dPN8X2xWVopXe9nMfQNWsGesyJ5lREExQVjp6ZsYZBKHui1qCKApIZeqbflbgUS8LV2TH25q5dJHFvaFk7vb8BnwStRbL7P5+9RHrP6zsXNUdtD5IC94CEM2Rc2rVwllJYI1VZMng33jFbtq7yYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860547; c=relaxed/simple;
	bh=Eb81/pL7jL3MbFStJK9FagbkM75gITUbZy1Wol0KC1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVFNgOMDK+U4/6rQCo6TaoyJU86j2A2hdC36WeAo4oGlZdPZfkwNDcomEF3SX/4/LJNc70k6HqVHdJq/fSvcc3gxlsyvEWV/2ba4xfpkrIzHEKIvhTaoGtj09e9xmSFkR3t3pKpmPKbk0Y+2thTUFHtCgvejvh1IXkwjHdwKOoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej28Eww+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej28Eww+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEF6C2BCC7;
	Fri, 15 May 2026 15:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860547;
	bh=Eb81/pL7jL3MbFStJK9FagbkM75gITUbZy1Wol0KC1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ej28Eww+xkve/IgSlCB79//saOSUEC10VqTF1OsPyGyK3eN3iEjoOJJEZtlRdpbnE
	 V7bg6uSjR9iYjroDxB229gqIRdbjbuMqB0MXOY2eoJUBgOhf6+5iLtExFUuLA1npay
	 4TEaGWK1OhO1J5o9TmdM1dZ2jDWH9B1KksnMUFJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 131/144] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_get_sndtimeo_cb()
Date: Fri, 15 May 2026 17:49:17 +0200
Message-ID: <20260515154656.553015715@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 78a88d43dab8d23aeef934ed8ce34d40e6b3d613 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 8d836d71e222 ("Bluetooth: Access sk_sndtimeo indirectly in l2cap_core.c")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1734,6 +1734,9 @@ static long l2cap_sock_get_sndtimeo_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return 0;
+
 	return sk->sk_sndtimeo;
 }
 


