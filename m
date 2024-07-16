Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909EA1DDCE;
	Tue, 16 Jul 2024 16:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145836; cv=none; b=b8dVXYWZVEVAk8LhkqLDM8KY7VyMCY403BgcKX+Fs/3phqz9YmNw9yiUMdLkwLUYGB4BfkY44ESWeS6zHOEFRWDkx6rcYbP0nTV75ak1kJZCKr3r4QwQEJ5clHR+55B8lhXcvGT34zSNimiyF3P3fje306QFHPvhDKEIzaQSJ6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145836; c=relaxed/simple;
	bh=XIY7IRiuWQ7SePMyAg0Jpvjtpz7Hky0ejcYiehF6Byk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf1cgConFURTxZyYG7Nj4v5NY6+lwH1c/nTHAk1OQAhWUowqP94OIRmiN60MgQ9tbzpr2Eqk2vmaGdrUzr4IcR0TVgA4P+Zut/UMPbtbcfjNMwNnG26T2kLifdz8qyFbgNKyRnrGlo28j9CZeuRpriz+DEPtXPoOAYE5vD3M31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bFM8+oT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bFM8+oT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DDAC116B1;
	Tue, 16 Jul 2024 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145836;
	bh=XIY7IRiuWQ7SePMyAg0Jpvjtpz7Hky0ejcYiehF6Byk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bFM8+oTfCg2/SdsndVcCEfBMl2ZzrZk+fiTYirK5RTFbdbQW8KFN/rkR7FkB8mH6
	 KrmTUBullg4lnz7C7cfIQN0fJM5zjhVBsDkZS7y4F4XdMn1bhKLvsrm0KLyJyoGSYL
	 O/rr9HlBXtgj9kfb1XJeteUdZ3gPpCvJ9scDYkUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.6 101/121] misc: fastrpc: Fix ownership reassignment of remote heap
Date: Tue, 16 Jul 2024 17:32:43 +0200
Message-ID: <20240716152755.214197950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit a6f2f158f1ac4893a4967993105712bf3dad32d9 upstream.

Audio PD daemon will allocate memory for audio PD dynamic loading
usage when it is attaching for the first time to audio PD. As
part of this, the memory ownership is moved to the VM where
audio PD can use it. In case daemon process is killed without any
impact to DSP audio PD, the daemon process will retry to attach to
audio PD and in this case memory won't be reallocated. If the invoke
fails due to any reason, as part of err_invoke, the memory ownership
is getting reassigned to HLOS even when the memory was not allocated.
At this time the audio PD might still be using the memory and an
attemp of ownership reassignment would result in memory issue.

Fixes: 0871561055e6 ("misc: fastrpc: Add support for audiopd")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628114501.14310-6-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1238,6 +1238,7 @@ static int fastrpc_init_create_static_pr
 	struct fastrpc_phy_page pages[1];
 	char *name;
 	int err;
+	bool scm_done = false;
 	struct {
 		int pgid;
 		u32 namelen;
@@ -1289,6 +1290,7 @@ static int fastrpc_init_create_static_pr
 					fl->cctx->remote_heap->phys, fl->cctx->remote_heap->size, err);
 				goto err_map;
 			}
+			scm_done = true;
 		}
 	}
 
@@ -1324,7 +1326,7 @@ static int fastrpc_init_create_static_pr
 
 	return 0;
 err_invoke:
-	if (fl->cctx->vmcount) {
+	if (fl->cctx->vmcount && scm_done) {
 		u64 src_perms = 0;
 		struct qcom_scm_vmperm dst_perms;
 		u32 i;


