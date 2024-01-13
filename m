Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A4D185A;
	Sat, 13 Jan 2024 09:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zD5EzmrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758A7C43390;
	Sat, 13 Jan 2024 09:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139835;
	bh=JcZzu4Vjy7fGlc0WQoyGEi6favtl2be5lROykbOKeyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zD5EzmrPIfLxoZGNCsSAnk9+xaPwNLBSYAbck0o144VTqBNRTiHf3m4I4Haz4LGvr
	 l1BYCDFDBK/cjr7LHKOeh6/+l8ZH1y6ceztvN3kBLYgHGo/VxAuJEDqFioHFkEPh9M
	 HQimaLQDrtrHmt4bJW6bJ6jTAb7DoW1GrHr+G30Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Jann Horn <jannh@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 32/38] net: tls, update curr on splice as well
Date: Sat, 13 Jan 2024 10:50:08 +0100
Message-ID: <20240113094207.433090868@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

commit c5a595000e2677e865a39f249c056bc05d6e55fd upstream.

The curr pointer must also be updated on the splice similar to how
we do this for other copy types.

Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Reported-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20231206232706.374377-2-john.fastabend@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_sw.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1211,6 +1211,8 @@ alloc_payload:
 		}
 
 		sk_msg_page_add(msg_pl, page, copy, offset);
+		msg_pl->sg.copybreak = 0;
+		msg_pl->sg.curr = msg_pl->sg.end;
 		sk_mem_charge(sk, copy);
 
 		offset += copy;


