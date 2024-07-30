Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C54188013;
	Tue, 30 Jul 2024 16:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357908; cv=none; b=XBCReR18DKX5RRUdupeLvmT9HNEkYYbS61d3e2U6sv36Ry4/Uqxp39DHARLUFZGR/GbECqzPL3Wwr5qoHWfaDU/NH2tywVZ71nS8vbwuaeI/f+Tln3shT9CZBGaea34inP5JNZ9vu51xgeBm78RBuGp/ij0mc21LF/zRn7ZZT3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357908; c=relaxed/simple;
	bh=gdJnLC/QNTTYUmK/PY/jMRc6JlwKtg0/+RzwtYSKD9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzOa3zX5R4RbYGPfVMEDOkUplFHxy38SJyCProR9KZ93PwCZDURHDQWoByhZZlhloiS2kGtiSU4naI/Vw62Harse0kvkglhbI0y4DfUq7GbZWQZz6Bk2l8NhM4utgGSUikEg98zF4uMRXAz0UsXttsjMvPGuukSh4cm/HamNf/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=slagj+fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="slagj+fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180CCC32782;
	Tue, 30 Jul 2024 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357908;
	bh=gdJnLC/QNTTYUmK/PY/jMRc6JlwKtg0/+RzwtYSKD9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slagj+fksTigVnz7JayMFvvvGHGQ62CNq1vPEz4hXloFfXAlatzzs/hUURXb0Ecuv
	 9tR8sSRzg1whjbvzFZh3WlCKbUMVWILnbGxqzHN+mVcgWJpMXL3ZtiJq91oht6rqdR
	 yyNE6sUePSYYCqI3IzviJs8n5XEr4YrGrYs3HDqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Lk Sii <lk_sii@163.com>
Subject: [PATCH 6.1 338/440] kobject_uevent: Fix OOB access within zap_modalias_env()
Date: Tue, 30 Jul 2024 17:49:31 +0200
Message-ID: <20240730151629.019122951@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit dd6e9894b451e7c85cceb8e9dc5432679a70e7dc upstream.

zap_modalias_env() wrongly calculates size of memory block to move, so
will cause OOB memory access issue if variable MODALIAS is not the last
one within its @env parameter, fixed by correcting size to memmove.

Fixes: 9b3fa47d4a76 ("kobject: fix suppressing modalias in uevents delivered over netlink")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Lk Sii <lk_sii@163.com>
Link: https://lore.kernel.org/r/1717074877-11352-1-git-send-email-quic_zijuhu@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kobject_uevent.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -432,8 +432,23 @@ static void zap_modalias_env(struct kobj
 		len = strlen(env->envp[i]) + 1;
 
 		if (i != env->envp_idx - 1) {
+			/* @env->envp[] contains pointers to @env->buf[]
+			 * with @env->buflen chars, and we are removing
+			 * variable MODALIAS here pointed by @env->envp[i]
+			 * with length @len as shown below:
+			 *
+			 * 0               @env->buf[]      @env->buflen
+			 * ---------------------------------------------
+			 * ^             ^              ^              ^
+			 * |             |->   @len   <-| target block |
+			 * @env->envp[0] @env->envp[i]  @env->envp[i + 1]
+			 *
+			 * so the "target block" indicated above is moved
+			 * backward by @len, and its right size is
+			 * @env->buflen - (@env->envp[i + 1] - @env->envp[0]).
+			 */
 			memmove(env->envp[i], env->envp[i + 1],
-				env->buflen - len);
+				env->buflen - (env->envp[i + 1] - env->envp[0]));
 
 			for (j = i; j < env->envp_idx - 1; j++)
 				env->envp[j] = env->envp[j + 1] - len;


