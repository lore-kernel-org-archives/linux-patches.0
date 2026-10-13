Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9D4DEC22;
	Tue, 13 Oct 2026 11:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892100; cv=none; b=uv+sgGDNGPfTFvbHpMsLCPiwvQYPbOsh9R2j5mUahfd64Wggb2xoM4hWSkImvQmql0yCdeDFbn1j/djCfCq4f4YR7TGhEOGuBZRKZUHWTPqGchGW/SniQ2oYmQS+uR4vWWw2M8KSbKUStsxiK9xBd8+7KXjwbBwtHSsFe3DnXAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892100; c=relaxed/simple;
	bh=4Qg0tzoicSk2gbS+GbEeIjGvd0pQvU9clLG1doVrbWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWpdHdzYWrxtHnZ3ho6Dc9aZL7Ps48yPAfs0Wd2i9G6wyebMd7OAEHa0cL/BHxVDK9ke4YI0IygXUggCWLfcNUnOukQbzws1VxaFQwNCWVehU23fdmRzhKEkYCy6ccL+WyzbMDKU3OSH9q9k6i5X0CjA8rQAn9grq6XU3luLmOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InbLFvXz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InbLFvXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15171F000FF;
	Tue, 13 Oct 2026 11:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892099;
	bh=ZAl4L6LaYjm3yDmPLDaTATxu4IfmulYL7nU4XUzh5tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InbLFvXzNv95SSyh97FVtE3AbIRi+KWJKErKgHWkiNwbYLn/OVQ+AvFfrxuSB2h1l
	 ekuP6HmP6nbSeo/NJjLOeKbwVcVFiKePZbaCGPSfsJeJx5zHkzJ5rXY2H20OVg4NZZ
	 JFZmpi4xWQJNK2MW4UwgTwwCZBAAqdsVuUaDm80g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rhee <jordanrhee@google.com>,
	Tim Hostetler <thostet@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 059/281] gve: fix XSK buffer leak on error descriptor
Date: Tue, 13 Oct 2026 13:36:15 +0200
Message-ID: <20261013112856.561202859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Joshua Washington <joshwash@google.com>

commit 9fed6a8ab8a5bacba2c709cb19d2dd6d2fa9112e upstream.

When the error bit is set in the RX completion descriptor, the buf_state
and its attached buffer should be freed. In the case of AF_XDP ZC, the
XSK buffer was not freed, leading to a leak.

This issue was caught by LLM.

Fixes: c1fffc5d66a7 ("gve: implement DQO RX datapath and control path for AF_XDP zero-copy")
Cc: stable@vger.kernel.org
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Tim Hostetler <thostet@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260930214735.3288780-3-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -845,7 +845,12 @@ static int gve_rx_dqo(struct napi_struct
 	}
 
 	if (unlikely(compl_desc->rx_error)) {
-		gve_free_buffer(rx, buf_state);
+		if (buf_state->xsk_buff) {
+			xsk_buff_free(buf_state->xsk_buff);
+			gve_free_buf_state(rx, buf_state);
+		} else {
+			gve_free_buffer(rx, buf_state);
+		}
 		return -EINVAL;
 	}
 


