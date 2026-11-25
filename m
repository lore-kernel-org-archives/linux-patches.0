Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623847;
	b=c2STVz4gBAeS6jYww02WlQJcvU/F383TPVaeXy0A633iBOBZVYLvVU6nLBxGwAS/coVq
	 CMTo9B3xvKpDw+S7HGGP+octvbcJTUzZ2KMH9dkO3Rd2fVhq0UWO2zJ2eh34GmLrrh545
	 0/Yy/KJvWQkVa6tEfEt6oZsy3fPZ5FdapoyIJ/3QGL4PXTi/6YrCXKtqL4Dm093an8FFF
	 d5zYUss7VCQY4rNAkxtDAZyQuJz0ho1RISoW/VOQBlNDXLWsZAQ3IgVLJgNK98EBKwCez
	 9hB28EfIk7cIJSVuSqhQaY2gmsdOGSYqCgDkjp5qkC1akl/pfqmkP5IUk7H7XkQsJmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5F/LOFyzwk/IAkLlwNBMs9Q9e4Eer9MXncrG9Fl/5uk=;
	b=zi8P2RA9WmiyYUv/yJQXVTKh5bccXekRWc6TjHeDfWRC+TKNLm8CSLm+0A2tjBR31E/p
	 CPReWQlezGZ41wRyy7Z+nuN1xszjqaItnjYwgIWLsIVhJ/WfrtrjfQZS6DCoLKWL9eJMV
	 6Y+vSO4FERqrqfq0JPSp/qo7GiKiRWE5L3Gm66UPB6Z2uFRpJf487AalR+iR0jP7wHaC+
	 8d8KfXFj0nrer1f3bPwZ9AM3qhWYS/b5q/sNE42wvKk/Mr0ZMmLOZ6Hp8njEdVzsSa7sr
	 79dKokA+WaMPeFTl31nO6DJ7/PDZwIqAdYIXp1BYWQqp/Uk9LB9Jikoq/YDxIGjkMpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ei7gRL9B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958A2606A31E;
	Wed, 25 Nov 2026 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ei7gRL9B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB331F000C6;
	Wed, 25 Nov 2026 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623847;
	bh=5F/LOFyzwk/IAkLlwNBMs9Q9e4Eer9MXncrG9Fl/5uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ei7gRL9BdCBpnEaxuq3hVMKocYKPNYGBOWbSn81dfzQUJpwekaAwU+LW9J9LaIK1V
	 AiPGao9g8b3wegtIDPPd+p8QlNrgIO76ONkPshIsrV1eXiBP/R3zT2OrGnBRtqeUht
	 MyTu5ZxIHOqphPSfAdWmbzrTIqCJREqKz0L7z0WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sandeen@redhat.com,
	Stefano Garzarella <sgarzare@redhat.com>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.18 978/990] 9p: fix privport option setting wrong RDMA field
Date: Wed, 25 Nov 2026 15:39:05 +0100
Message-ID: <20261125143844.891520487@linuxfoundation.org>
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

From: Stefano Garzarella <sgarzare@redhat.com>

commit 7fb9bd3659051ff74a29387de0023bb8300e4aa7 upstream.

While reviewing a patch adding vsock transport to 9p, I noticed that
since commit 1f3e4142c0eb ("9p: convert to the new mount API"), the
Opt_privport case incorrectly sets rdma_opts->port instead of
rdma_opts->privport, so mounting with the privport option overwrites
the RDMA port number instead of enabling privileged port usage.

Fixes: 1f3e4142c0eb ("9p: convert to the new mount API")
Cc: stable@vger.kernel.org
Cc: sandeen@redhat.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Message-ID: <20260703102254.114446-1-sgarzare@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/v9fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -384,7 +384,7 @@ int v9fs_parse_param(struct fs_context *
 		break;
 	case Opt_privport:
 		fd_opts->privport = true;
-		rdma_opts->port = true;
+		rdma_opts->privport = true;
 		break;
 	}
 


