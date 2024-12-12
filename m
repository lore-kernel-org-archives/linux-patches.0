Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3283113CA93;
	Thu, 12 Dec 2024 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024418; cv=none; b=uCD6eq0Iqmly+Ef2d+sWwYE26+l4q7rrnRh5rUJrGdgRrICt48/n4dIQ9Mi3ROIwUO8gYT/j1Hv/fFLzyoQtVIibQwUtt3ISCU34QWGeel7ImwVJxotpX90BMiLZM/Y9lP72lsbmvWTcPSROXV6fwTIWkmLu4dMDopLazQ6OElc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024418; c=relaxed/simple;
	bh=UvfVCZSnIgXQXD9aI0AKisZFb2xtNnqEswS5P9cGQDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJjf0Ig0w/FigqiHCehimOgAzf4RK+MwYTSSehnWqSOt8jEQiDc7QYjOWANXV2k5/iduWurjnNZkkft+TCJHseSgW+qKwiK9PCRk58pJgnr/qRT83gz5VP2FbOK8W7H73CWqChGMxBeoIxU1djW3w4bIIlw6q6WfAjkXsM5YXAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/1qfC90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/1qfC90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC149C4CED0;
	Thu, 12 Dec 2024 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024418;
	bh=UvfVCZSnIgXQXD9aI0AKisZFb2xtNnqEswS5P9cGQDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/1qfC90dPU0bUJO7p6U0VPQyWZiQZLqqm0FqEU3Dz/daIPzktqNj5CKmL55k8r01
	 QlPKeD+RqFbEunosabERENezqjcTJRdPgmAEIDOUxMR9jiml/MDI3RArBDy9O/8Tlp
	 XUMyCmKXJ33XUVycJOt81EU3AEwnkjgAY3FK9x1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 290/459] um: Always dump trace for specified task in show_stack
Date: Thu, 12 Dec 2024 16:00:28 +0100
Message-ID: <20241212144305.087991483@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 0f659ff362eac69777c4c191b7e5ccb19d76c67d ]

Currently, show_stack() always dumps the trace of the current task.
However, it should dump the trace of the specified task if one is
provided. Otherwise, things like running "echo t > sysrq-trigger"
won't work as expected.

Fixes: 970e51feaddb ("um: Add support for CONFIG_STACKTRACE")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20241106103933.1132365-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/sysrq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 7452f70d50d06..34edf6b8b69d5 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -52,5 +52,5 @@ void show_stack(struct task_struct *task, unsigned long *stack,
 	}
 
 	printk("%sCall Trace:\n", loglvl);
-	dump_trace(current, &stackops, (void *)loglvl);
+	dump_trace(task ?: current, &stackops, (void *)loglvl);
 }
-- 
2.43.0



