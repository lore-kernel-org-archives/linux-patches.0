Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062216;
	b=WmCufEA5BHK7p3UKww7VUTdzGKPwif3iwm0cb8xEbxDOIBjsEYDGtvaP6JyBx3/x+RD9
	 P5fI5E6Y+2NHhyaBGXwr7TQA3am6nvsTGCMetEytO4EcZbzVDWtPLNKJDJIkIbihdiQTw
	 KBpDUGbFdpbkhNkSUAHR4YPD8sl4FtIfKQM5BD5Hmbmqe0mD9h/mBS2Kl5f7C8YDlG4Gg
	 Yua3/VIlFsQntpzsdf5mFLFaP38PP/MyXSgQxI8u4B5qQDi4RejAD1zxzKQJXSpIIGJkz
	 kTK2V+ymVegBmh4Z29u/TxF58KjCyEFsAPw7mRSCKK79XmnvXMSN0nkRggfi7piSTDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=kQ6egJXz7KAg0zQKUQPePtJyY+bRugZq7h3qm4k7vEI=;
	b=oVGjTZWCoCTjf4PfiC6QubzIFx+CpVy4oaLIdqMYR7fkTxqqHt40UVcmPJsIMr300XW/
	 EsLhAnAGTKpCIsyqCC76zyE9N15SsVWfW5mAmGWNX2zNjMEvplppPvpYkL+v2mx95ZcoA
	 Ggw83wSFr5CMl86oxzblTocqlCHqRyxIU2udGX4DqCE6Sf3yUVIHhJ5Brfm91Kp9K50cQ
	 2AUa+PoKM5UdvBqzL3Yuuxim2I7tN1PhxtKcu0Qbq/dzyJ84RIdHF/Bvh5cSXRCxvUepl
	 xnM9sWASJR3MjXbRLTC8RI+VfhDMQmZVFsY3oyG9Ieq6egYsuP1ERdYX1xZdryU9TVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCscz7xm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AAD606A325;
	Thu, 19 Nov 2026 04:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCscz7xm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E531F000C4;
	Thu, 19 Nov 2026 04:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062216;
	bh=kQ6egJXz7KAg0zQKUQPePtJyY+bRugZq7h3qm4k7vEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCscz7xm3ey/9IDwUfV10XxtQuX9YJYtLnI9zU0yYCVvmdF9aAqCktm8tGnBjxREy
	 2UeBujtTj8vAf3YHkWwwl6/vNPqhEmwZWZt/974glWZ1Nq1JzcVJdAKfTxNyYfighd
	 D7TtqmnumB0soka8tX+07KzpXUQLoXRpxMcIqG5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 1832/1848] selftests/net: fix EVP_MD_CTX leak in tcp_mmap
Date: Wed, 18 Nov 2026 16:04:30 +0100
Message-ID: <20261118150036.328257749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

commit f4ef35efbb49527293309f668ea73ec5de9b8e7a upstream.

In tcp_mmap.c, both child_thread() and main() allocate an EVP_MD_CTX
via EVP_MD_CTX_new() when integrity checking is enabled, but neither
function releases the context.  child_thread() misses the free in its
common cleanup block, and main() returns without freeing the context.

This results in a SHA256 context leak on every run that uses the
‑i (integrity) option.  Add the missing EVP_MD_CTX_free() calls to
the appropriate cleanup paths to fix the leak.

Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sent in tcp_mmap")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Link: https://patch.msgid.link/20260702025949.442523-1-wangyan01@kylinos.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tcp_mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -297,6 +297,8 @@ end:
 				ru.ru_nvcsw);
 	}
 error:
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	munmap(buffer, buffer_sz);
 	close(fd);
 	if (zflg)
@@ -587,6 +589,8 @@ int main(int argc, char *argv[])
 		EVP_DigestFinal_ex(ctx, digest, &digest_len);
 		send(fd, digest, (size_t)SHA256_DIGEST_LENGTH, 0);
 	}
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	close(fd);
 	munmap(buffer, buffer_sz);
 	return 0;


