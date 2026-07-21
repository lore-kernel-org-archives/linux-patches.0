Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6216438FEE;
	Tue, 21 Jul 2026 20:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666972; cv=none; b=fng69mwT7VJ28jK1sNuYfCrS8Eiq5YFpoBH1ZuexKRWb6JDHajoXy6zK4NfBRVJc3kMtM0+lt2YONNnVAVAWyVVZcmQpCwdE9MDpfkHImTgoNBM68U9Jf+n1CZKbspGc3gfgoTsuT+sCqCw4MrX5By0UPF2L5yujwob4Cc+wO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666972; c=relaxed/simple;
	bh=04fEMBzwDycgFqdQvBaHzUxiR3wQdSrih5M5gM8EJFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IGWntc8PvRKzSqUrI2ZvYYYW9R+4io4yq+EPIwZ2YYQgAOI5XFwsDI07tP587uG2X/w8eXVaS5h9gasUHg0z1pcROxZmlH/HHy4jc+Fnkk57Ewl6vDqlGSP0bgVEqtMCnT6cgher+Io1QSUTcEap2vYKTvaLQsSPLk8aSBSr5KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vf/wb7xs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vf/wb7xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57ACD1F000E9;
	Tue, 21 Jul 2026 20:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666969;
	bh=9Ks3wtjT6hZjO+Lz10Bc6dkixb8fYL4PxGo5s50BwKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vf/wb7xsYC1s6DHJ2vt/97ouXVX+SQg4PanqA8DetF9vIuWQrHWHBzngYEz7iyP/+
	 E6jHm0ZCN5A+YyFGFecwCGI1EszE+SAidXsN26UOI+dZa/RlYVq9/qFHExD0rkwNEF
	 e19UhRaHWZ+Vel9ZuZC/rLsRPL8bvV49QKBp6M4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0885/1266] selftests/net: fix EVP_MD_CTX leak in tcp_mmap
Date: Tue, 21 Jul 2026 17:22:02 +0200
Message-ID: <20260721152501.654534840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit f4ef35efbb49527293309f668ea73ec5de9b8e7a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_mmap.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 4fcce5150850dd..2544ae35d07a83 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -313,6 +313,8 @@ void *child_thread(void *arg)
 				tcp_info_get_rcv_mss(fd));
 	}
 error:
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	munmap(buffer, buffer_sz);
 	close(fd);
 	if (zflg)
@@ -606,6 +608,8 @@ int main(int argc, char *argv[])
 		EVP_DigestFinal_ex(ctx, digest, &digest_len);
 		send(fd, digest, (size_t)SHA256_DIGEST_LENGTH, 0);
 	}
+	if (ctx)
+		EVP_MD_CTX_free(ctx);
 	close(fd);
 	munmap(buffer, buffer_sz);
 	return 0;
-- 
2.53.0



