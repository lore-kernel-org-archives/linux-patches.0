Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2661F3B38B1;
	Mon, 23 Mar 2026 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278562; cv=none; b=EZTULQTHzbZY08Izx7+Vq+9V4LG7vw6nVsOhiR3scF/jVeprR0RiB8uxa6+tbiG8pft3KijJq0gtlsCxyk2EVdXUsny/xGJ5pGEOzzcdZBT1ZAm2kkocxcZqKKFU2sT1jFaSHGn8l+fKw2E8cn2BFO6sfIzQPqlSmQ9D+s/FSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278562; c=relaxed/simple;
	bh=yaDzKXMrbu4OQOK8F7xcC+SjwhPncXP4rAMoWKFcM3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyu3twazlN97glcF3g69QzyRmSk9I2EwMKoei/DnplBV0O7u/NzxeXJ21SazimBgn83rF7nuuZ3pYRsrw2G505ZDIIcE/aUlG0htRI4w+1JTxgPvBdDzBNcylzvtkzc92/IpmOkAI5Pd4hjYw82vw+hln9MNW6dFo4d+r/p3wsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNrJd8KC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNrJd8KC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8811C4CEF7;
	Mon, 23 Mar 2026 15:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278562;
	bh=yaDzKXMrbu4OQOK8F7xcC+SjwhPncXP4rAMoWKFcM3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNrJd8KC/mIPZTL0KIj9jxtEb3YjJpdR1DHfdbrF4EZtZPKhYOxSt/ENIav2rDh16
	 O+M8dDxwQYK+W778VGjgaZbkkWbAp7l1qEQieP9gZqeozPDYXzPRmSQN9pYEHXFARR
	 /s5GTvtoPIM/4FGsZLtZrk7x/QlZRf7oKl1r33DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 347/567] lib/bootconfig: check bounds before writing in __xbc_open_brace()
Date: Mon, 23 Mar 2026 14:44:27 +0100
Message-ID: <20260323134542.421239643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Law <objecting@objecting.org>

commit 560f763baa0f2c9a44da4294c06af071405ac46f upstream.

The bounds check for brace_index happens after the array write.
While the current call pattern prevents an actual out-of-bounds
access (the previous call would have returned an error), the
write-before-check pattern is fragile and would become a real
out-of-bounds write if the error return were ever not propagated.

Move the bounds check before the array write so the function is
self-contained and safe regardless of caller behavior.

Link: https://lore.kernel.org/all/20260312191143.28719-3-objecting@objecting.org/

Fixes: ead1e19ad905 ("lib/bootconfig: Fix a bug of breaking existing tree nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Law <objecting@objecting.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -534,9 +534,9 @@ static char *skip_spaces_until_newline(c
 static int __init __xbc_open_brace(char *p)
 {
 	/* Push the last key as open brace */
-	open_brace[brace_index++] = xbc_node_index(last_parent);
 	if (brace_index >= XBC_DEPTH_MAX)
 		return xbc_parse_error("Exceed max depth of braces", p);
+	open_brace[brace_index++] = xbc_node_index(last_parent);
 
 	return 0;
 }


