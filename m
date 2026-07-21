Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5201F3B47E3;
	Tue, 21 Jul 2026 22:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672866; cv=none; b=Znj+pRz812Ju9KRZ3WXsAC0XcvlYd4U8W5YYhVe3vWM6bIVbYDw+fB7REk3uktEMAyab8mF+RtIGF6N91nNMvZrkLwYC7ACbPRZfBmT9eYkBWiGGq5vdc2ZO4xkUtnNO1AePK687ATlqgYL8mYkmh2ujVz73OagT2mQ3RfUc9ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672866; c=relaxed/simple;
	bh=OXsXAhVQvFaEnx+q3Klp5NF5XINNYApcUwPTH+YbUUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDA2sb9IVz9nbBdLdxZT3ytaTcxJ9qa9acST8qvZU07zZ+BXxKP0wVfAytALWbxyQu6ZAaNm90iWlro28VmtU6fZMAVbAvuiqpqszDK45hdZAv6uzZTHDwZ7VHzkgsQvoylaMkcxv2L1gCcDHmXc0IuKw6uOqm5WieVOSNY3Q+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5PmIBjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5PmIBjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625A71F000E9;
	Tue, 21 Jul 2026 22:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672864;
	bh=C1b7lMIotLY1wdwId5CUsLdsSvKQHE5XtDvqybR4u98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5PmIBjQaa+3iFgpEcGMnp9klMhhfKFTOOmNU8AQXRgpHyNN/uatxWQqU1OUlM+p0
	 JuZ+ZfoqmSLKpRTB3rpfq8MgaElPLbcZ98ippFuW+uDzzlqNYOx9DRm3690Ajh9uT0
	 hVZus2EcXzGDTJqAOftj2TLTmwnUyF04/rCR0oWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 787/843] ksmbd: destroy async_ida in ksmbd_conn_free()
Date: Tue, 21 Jul 2026 17:27:02 +0200
Message-ID: <20260721152423.766586204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit b32c8db48212a34998c36d0bbc05b29d5c407ef5 ]

When per-connection async_ida was converted from a dynamically
allocated ksmbd_ida to an embedded struct ida, ksmbd_ida_free() was
removed from the connection teardown path but no matching
ida_destroy() was added.  The connection is therefore freed with the
IDA's backing xarray still intact.

The kernel IDA API expects ida_init() and ida_destroy() to be paired
over an object's lifetime, so add the missing cleanup before the
connection is freed.

No leak has been observed in testing; this is a pairing fix to match
the IDA lifetime rules, not a response to a reproduced regression.

Fixes: d40012a83f87 ("cifsd: declare ida statically")
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c1016dd1d8b2 ("ksmbd: track the connection owning a byte-range lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -40,6 +40,7 @@ void ksmbd_conn_free(struct ksmbd_conn *
 	kvfree(conn->request_buf);
 	kfree(conn->preauth_info);
 	kfree(conn->mechToken);
+	ida_destroy(&conn->async_ida);
 	kfree(conn);
 }
 


