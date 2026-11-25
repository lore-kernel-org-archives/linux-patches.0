Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623427;
	b=jeAnhrcrdYr1SjjEItQ5EZCc8IrCs4R3p4XiC/W8prx0Q6CSb9nM8oTWKvFMZcQUNVyo
	 10Bw4a+1ZERKh4zfjviLefrQHV0pyJUEFrQ3sJ6cdzrcDES8n8PPc8ma9bi1fPX5L/cD0
	 l+2z54oW8lGxuatmWu/8jfAWEqsyqMMz5bWba+pC06OTnQAgls5HliBhto/jqXqnBOIWE
	 iwOT6o9uouR99L6M3eaW/xRUlQPkmeXxLqtjy8kojylK5FApfQmbItTWK2XZckYyIRyt2
	 3IC03fQ1Rt/959kN2LzZ8ssaRL0zEqvUMg4j0lJ+LShVTVyZPmzxoIxJx4cELffcUGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P540gyvosfilTDIwGGb9gNwZllYXKajWzYlbE070xzw=;
	b=HWsOQJspkYd4Ir2XsaFUHFO2uiPqKik5+Dwpy0xOdBpNP8TQc9iHx+3sl39CTWuKYQia
	 Z7H5aPpSTImBMRthS+2GLFCnIz1Ck2KjmvkEnQ5WL+F0OX+bSvSX62rqATAblgybjlDc9
	 qf4IV0XlazFaXEPa5SMZz+siskaNORTTTljSlOA6HQabjDqeD6kn0I+UuWWB3dkJC477h
	 f5GAaXPVZ7sRBIbKTfJMHf1r9F+YEReNL5My8rlWWaocaHj/ApL/YGQmmyevB+1Mqs5hD
	 MFJY1ZXhzHjzBycuIZe0AGOgQZbQM+7n2VkgqykV9RhvUJgrlaOL80F1KEKsYR3nh8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIPZpaia;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C37606A321;
	Wed, 25 Nov 2026 16:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIPZpaia
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B5B1F000C6;
	Wed, 25 Nov 2026 16:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623427;
	bh=P540gyvosfilTDIwGGb9gNwZllYXKajWzYlbE070xzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIPZpaiaG6DertpF0MHcE7nT/cMwaKv3rFO6csLjPNLG8nu2O1FmrlUxkPT/Vcl0/
	 rlZiStw3HzKDtkIn5oFGcE296m1eOqoHS+fYG7reNzBqV7gazPDov6JggmJOK6yAix
	 H6IfraVhyLwOM8YA+ZUmugIRmjVP5W+3sdGDKFq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 856/990] dm mpath: fix buffer overflow in parse_hw_handler()
Date: Wed, 25 Nov 2026 15:37:03 +0100
Message-ID: <20261125143842.078596302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 8f611fe94a781c6fb658488cc7eab4e4923e6df6 upstream.

parse_hw_handler() builds the hw_handler parameter string in a buffer
sized with

	len = 4;

plus one byte per argument.  Those four bytes were meant for the decimal
form of the parameter count, three digits plus the terminating NUL.
dm_read_arg_group() accepts up to 1024 arguments and the count written is
'hw_argc - 1', so a count of 1000 or more needs four digits plus the NUL
and sprintf() writes one byte past the allocation.

Size the buffer from the actual string length instead.

Fixes: 2bfd2e1337f0 ("[SCSI] scsi_dh: Use scsi_dh_set_params() in multipath.")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-mpath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1084,8 +1084,9 @@ static int parse_hw_handler(struct dm_ar
 
 	if (hw_argc > 1) {
 		char *p;
-		int i, j, len = 4;
+		int i, j, len;
 
+		len = snprintf(NULL, 0, "%d", hw_argc - 1) + 1;
 		for (i = 0; i <= hw_argc - 2; i++)
 			len += strlen(as->argv[i]) + 1;
 		p = m->hw_handler_params = kzalloc(len, GFP_KERNEL);


