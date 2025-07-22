Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BD72EBDC8;
	Tue, 22 Jul 2025 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193225; cv=none; b=Jkh1e4liUsCTmpanPelvj8jPIcBzp2YgZOQnD5GBAj5VeQiWsXca24Xbl/ey1mAnsI0K8QWfj7f/xFaAYUm93oQrx/AG9CeaE2ZoR5nTSe9+3Ej/m2Z+0lBe4e/eSO+zcUjkcTIz08Qi4Fy3jXsEWVrQ9jIk4ShGvlxMltXSiFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193225; c=relaxed/simple;
	bh=LsTm3EpjVuBITJQjFgWG4CSN00QlseUKyuY8KTUTxRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lv19HhjZMrMwzgjlW0rL9sStoSzAI0laWa5Z8qY45AyfAapQsRg+YMgWyGN2rQgqlZuEWMR8nuDcuKFNzQ3tgOuCVxrHXY11l1dXN2wQQzGtvJd06V70BwvDJC33tzBs7UHB8/Xou0kZTLjysh8gZXG//pYuWKpdwjW4gAKeW80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=du9jw1KD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="du9jw1KD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA2DC4CEEB;
	Tue, 22 Jul 2025 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193224;
	bh=LsTm3EpjVuBITJQjFgWG4CSN00QlseUKyuY8KTUTxRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=du9jw1KDJELZ8ET225n9Pb87wZRuKL87J5RA86VI7jSyecTPSKuM58/tnUzygkMwH
	 CBwXwyBeJuWxmHp3bjg3eVSaBadFPJcfyhua2ge47SUBCti4BamdfkCFyUhKNyQxc/
	 KS//Dbv9cw0YemE7/xYXL5G1R5HWvQPDBjpYKhGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.15 028/187] tracing/probes: Avoid using params uninitialized in parse_btf_arg()
Date: Tue, 22 Jul 2025 15:43:18 +0200
Message-ID: <20250722134346.810400363@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 1ed171a3afe81531b3ace96bd151a372dda3ee25 upstream.

After a recent change in clang to strengthen uninitialized warnings [1],
it points out that in one of the error paths in parse_btf_arg(), params
is used uninitialized:

  kernel/trace/trace_probe.c:660:19: warning: variable 'params' is uninitialized when used here [-Wuninitialized]
    660 |                         return PTR_ERR(params);
        |                                        ^~~~~~

Match many other NO_BTF_ENTRY error cases and return -ENOENT, clearing
up the warning.

Link: https://lore.kernel.org/all/20250715-trace_probe-fix-const-uninit-warning-v1-1-98960f91dd04@kernel.org/

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2110
Fixes: d157d7694460 ("tracing/probes: Support BTF field access from $retval")
Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -657,7 +657,7 @@ static int parse_btf_arg(char *varname,
 		ret = query_btf_context(ctx);
 		if (ret < 0 || ctx->nr_params == 0) {
 			trace_probe_log_err(ctx->offset, NO_BTF_ENTRY);
-			return PTR_ERR(params);
+			return -ENOENT;
 		}
 	}
 	params = ctx->params;


