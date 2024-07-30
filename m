Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800431A76A1;
	Tue, 30 Jul 2024 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360346; cv=none; b=nJnsPv/opRutMbqjHXyWTbho6Y+G/WFtUHgeGjVQ7kj9je1xhyWWTfgztaokeqm+OJ/OfCiZ7Cf/bS87TOFhRmdqjYEt9QKUZRW5nYFgDwj6W3fycJ3+frQeAs2W5rzNk744QapP61kfe7Hxvgr+1iNUTCAq0i0SmnHGdPpI07I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360346; c=relaxed/simple;
	bh=WY2HtPyGcDmSi5rQHvWJLpOeE7jvz6Jed9LOgO6nHV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAVF7r4jljsXWofzmj1WZHFb10EnAMmeRvyKebczOxXmlDbxjxRi/d/ZNh2awEiBPGwmx6V71b1oTNPoZRSqKMwmtzzkRax5RPeIcfwO/sFtdP4AE8Xt9ygvB+WSB92kkvXe9W0aPFCwgL1SKVefAWEEYESmafdJ8w5Sn3LHvtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wf4a5Km2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wf4a5Km2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A356EC4AF0C;
	Tue, 30 Jul 2024 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360346;
	bh=WY2HtPyGcDmSi5rQHvWJLpOeE7jvz6Jed9LOgO6nHV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wf4a5Km2yl4eQfovEFRzqaOgFwHExVrZC21oc63qKZ+AJM0Hb5tYdacE0u21SEJno
	 NsrMZg8Wc7Fqr7wOZjjrJ2qKwa5Lcog4K2yG65UxA8PLvFBA3lb6C/vJGsyG2pgMwx
	 RoiyqDx5J+KPNXLAapvINjqScDCNNh0lCsvMNeMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Lk Sii <lk_sii@163.com>
Subject: [PATCH 6.10 671/809] kobject_uevent: Fix OOB access within zap_modalias_env()
Date: Tue, 30 Jul 2024 17:49:07 +0200
Message-ID: <20240730151751.405749744@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -433,8 +433,23 @@ static void zap_modalias_env(struct kobj
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


