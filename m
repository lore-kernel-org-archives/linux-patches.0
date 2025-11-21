Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D0534EF04;
	Fri, 21 Nov 2025 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733427; cv=none; b=sH9JswB6gf3xB9b7KBm6qD0juhNxwjK4fwnIUKu/EPjgBQhhmZDiChGKo/9YYLdxIBwbQZP5egn6GHCjm201wmqsX3La7pxUVDR2sRvH4hetw8TyowyKOOAuRDGvQ9O+qrWP0XDqA1wCqFflJl3ekkFQO6ptjr0Vy8/K4aieBoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733427; c=relaxed/simple;
	bh=HBBzTiuHRHCjr6N5jEBnYakwN0zleI7S5HV6SiXTo1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkpHG42uKUiVKXQb8Aopg7mMMKHU+Ii+5/kblidF02iFeNTQTZ4K7Y8LuCqNbDrX33YlSzEE4PH/z5Bld1GqZY/nSOc/qMigUD0QImYnDMt+46TFYSqM6n2j5DqSn6j7weAHPSv7v6e1tawBr5p1fau8xYx51hjT453DaXQbbpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bu7wTVEO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bu7wTVEO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E717C4CEF1;
	Fri, 21 Nov 2025 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733427;
	bh=HBBzTiuHRHCjr6N5jEBnYakwN0zleI7S5HV6SiXTo1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bu7wTVEOkuh4lEUsOP/rP59MXuzVajtqDHJC27geg7HykcnV5GX3WlqXjN8m24Rzm
	 /LlaGpvNcgY85OCYJzTe7rQPOh9kiIqxSZzGlqTaVBMg7LODidqWHOFbWuHaM2qnIz
	 jHi4tv6qcvBA+M8fivPBybfjvQ2P8FMt9rh+FHRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 465/529] ksmbd: close accepted socket when per-IP limit rejects connection
Date: Fri, 21 Nov 2025 14:12:44 +0100
Message-ID: <20251121130247.554835332@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

commit 98a5fd31cbf72d46bf18e50b3ab0ce86d5f319a9 upstream.

When the per-IP connection limit is exceeded in ksmbd_kthread_fn(),
the code sets ret = -EAGAIN and continues the accept loop without
closing the just-accepted socket. That leaks one socket per rejected
attempt from a single IP and enables a trivial remote DoS.

Release client_sk before continuing.

This bug was found with ZeroPath.

Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -286,8 +286,11 @@ static int ksmbd_kthread_fn(void *p)
 			}
 		}
 		up_read(&conn_list_lock);
-		if (ret == -EAGAIN)
+		if (ret == -EAGAIN) {
+			/* Per-IP limit hit: release the just-accepted socket. */
+			sock_release(client_sk);
 			continue;
+		}
 
 skip_max_ip_conns_limit:
 


