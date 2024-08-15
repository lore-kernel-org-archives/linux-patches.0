Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929CC7DA8A;
	Thu, 15 Aug 2024 13:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728707; cv=none; b=ZIfvIikKssTa5AIkahRkTtrkM4M/jP/lnrc5kjO0ByOy3Nl0tXADVjSFM1HzhYsDmo0cFMCQHoVsWqxYJzDWtD2kYqbkKvhxwQ0Lq8Cbv08315iQ5M6NCVDTfS5b8yGa0DtSoPEZvQANmWQqKN/GYFn3nqHbKJfSEj3/7BrjEno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728707; c=relaxed/simple;
	bh=WserUgcT2x1XldaT6vEgamkqyAQYbT0lZfFOKdJ5AyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqVJFb3ZU/aq2z81mbWx+xEpGZO8UDAYZ0ZaCN+J2wSKFnnIn8JQm8G1/OHPQ1OiJEhDbA6yDKZWhC+3Vd3N7OgtPnu8Zhkn0rIYeaG+KuPdFnZDgnMYdVFJlvSNh35OgS0jR0X06ZhMcAqW4Z/yUtru2ECsJIgf7hFCP21C1vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M4jj4+Gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M4jj4+Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156A9C4AF0C;
	Thu, 15 Aug 2024 13:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728707;
	bh=WserUgcT2x1XldaT6vEgamkqyAQYbT0lZfFOKdJ5AyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4jj4+GrrsF+3S3/neVjdasgHE/BOitT7x965W800xvf9HGT4eFTk/2HiN3DMCo+c
	 HFKPnn3HLvdVJ64OphOLalSBbE10+11tTQwqZrGRMI7mKp/Jq2ES8ZchovRwsF9F7b
	 SrRla920rmwkaBZCw3wwk7wzN6sSGfH3C3V3fXNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Lk Sii <lk_sii@163.com>
Subject: [PATCH 4.19 085/196] kobject_uevent: Fix OOB access within zap_modalias_env()
Date: Thu, 15 Aug 2024 15:23:22 +0200
Message-ID: <20240815131855.333393132@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -430,8 +430,23 @@ static void zap_modalias_env(struct kobj
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


