Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043116;
	b=xwzxrZPffW2BfJkWV3QHDAa/4SAYjH3KUODBNVNUCG4iMGEPKGg0JphM+aAROsybe2on
	 jGnxhChw+jM3zZxxYulUh1TiXQIpL0/PUSu41dOwZq6P2AxM0QpsqF1mvxPAvr2Q4wZIT
	 oLNeieHxfMmQNcIePlvAdI6nJz3nIXXb2nN6V8DwKjXONYEZ2UdslnRKMisAM7R+HThJj
	 IC2cNxC+FwG/NwWzphteelJQFzmIQqjbhjHR4slkcE/qHM/u+kxA7GYOwXFVX7jlbLUWV
	 ubD3A0c5+HLh0DeaYPs698lReXKEwBFd37yYo/yM6uu0KEZg5NKy2Jpch74aCaU7BSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ks8IqCCwo7Deau26jjpxbHEeQj6PozCCcAjPImk7j6k=;
	b=dIG8nDduq8YoJSIPiPZ99QtK09kFpYGfTaMUelPsKUEQe5y0BaK8zaYwRHcBw0hWl/aE
	 5TJzxXrJUkVzlU87j1b+ptV1cmrxtwgmgEBbxILSgxicjsL0xnIkwqg4XGLR5PBoJyeBt
	 uCO1C6n9ei33oKPIzKuTxIgKYOCd1/TcrkiAA3efI5pjzRyi3MrzWdQ517AkLbuYVnq2S
	 EWupagA8vxQ9LDLIaEdFaYUqOzod2qXuWUcOk6DUY71ZFu3pYaLEqD9I80okWby0lbsqa
	 7pl0nDNnKyV1zlfHrCvxL0yh+BLoPyIu4x1ewX+nOleSQijNGCbQ+g3vltNDLU9kNhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjbKv3NY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD029606A31C;
	Wed, 18 Nov 2026 23:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kjbKv3NY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E8671F000C4;
	Wed, 18 Nov 2026 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043116;
	bh=ks8IqCCwo7Deau26jjpxbHEeQj6PozCCcAjPImk7j6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjbKv3NYBnP62MWc5M7OA7b5/cjjbewZloBY7SK7Vl1mz8C5T4GCoSJaPEPDUoaIy
	 IWeDn6Bw7an3ZAh1K+vGMaHKZELZflgRtpT++cw4m/qyzt+07rpKcIqb+cgbn+zcFI
	 l15SiPDkYGxN4RIH6ovlss5HHz6335cZtr6T7udg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Review <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0095/2857] tools/lib/api: Fix potential double-free from fdarray__grow()
Date: Wed, 18 Nov 2026 15:18:49 +0100
Message-ID: <20261118150204.689764147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit eadce0f46a1d066b812c7e5aa46a33711c78a755 ]

If the realloc for fda->entries succeeds but the realloc for fda->priv
fails, the error path frees the newly allocated entries.

However, fda->entries is neither updated to point to the new entries block
nor cleared to NULL. If realloc moved the allocation to a new block, the
old fda->entries pointer is now freed memory.

When fdarray__exit() is later called to clean up, it executes
free(fda->entries), which would trigger a double-free on that old pointer.

Reported-by: Sashiko Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/20260710200150.11FE71F00A3A@smtp.kernel.org
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fd/array.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/api/fd/array.c b/tools/lib/api/fd/array.c
index f0f195207fca9..dcb396ab51eb1 100644
--- a/tools/lib/api/fd/array.c
+++ b/tools/lib/api/fd/array.c
@@ -31,7 +31,8 @@ int fdarray__grow(struct fdarray *fda, int nr)
 
 	priv = realloc(fda->priv, psize);
 	if (priv == NULL) {
-		free(entries);
+		/* this will be freed by fdarray__exit() */
+		fda->entries = entries;
 		return -ENOMEM;
 	}
 
@@ -50,7 +51,7 @@ struct fdarray *fdarray__new(int nr_alloc, int nr_autogrow)
 
 	if (fda != NULL) {
 		if (fdarray__grow(fda, nr_alloc)) {
-			free(fda);
+			fdarray__delete(fda);
 			fda = NULL;
 		} else {
 			fda->nr_autogrow = nr_autogrow;
-- 
2.53.0



