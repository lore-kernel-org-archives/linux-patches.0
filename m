Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10CB228CB5;
	Mon,  2 Jun 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876688; cv=none; b=EIjbXuPGmKGDL9v16l6c2K8YDHZkFXMzZ1w+EmdExQ2nfQMQMR0oqwe4RIyleTda6L+p2qaJY141QsUC+oqp1WilrySlDpHXPB3Vr52j6Ue13o7gnjOQuz56Ox4ceM49pFiUcDDtG5PcYpZvJaj38/BnWppJoz/IrxTkma6lTHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876688; c=relaxed/simple;
	bh=beOuUM4J4X9wgrTF4Ru6TAchi6g58Hgx7gb4ggSAIyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OlEAsE0czkNxkSeOthrOkXjsvr+PTqRfWX0GIisV+I1xeNLmkNHFEXFJ7XF1kLFgkCAL9HyrLlIQh2paY8/MZLWOVdmQ9gcshuInRqCOAQRdIRiS9ln5gqHNpzZLDc8ZktVSQXieEDN+Bs+XmlIZ73XqktU0DpMVk8PgujS5vME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtnV/ODo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtnV/ODo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DCCC4CEEB;
	Mon,  2 Jun 2025 15:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876687;
	bh=beOuUM4J4X9wgrTF4Ru6TAchi6g58Hgx7gb4ggSAIyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qtnV/ODojqrGcSF3G9jF7Wl+tSofrt0heQzRBjVOlrQmHt21udb10ritlN8EzxC/b
	 6oQnHfRVra5NLpKeq8HrZfzQDSATtoOPi1O915vpL7YE3K4jwYulSFsdPi/D0VGwOa
	 ADjRNWKYHDf5KDnChXVli8sJerlonEti2hHa+oVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	gao xu <gaoxu2@honor.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/325] cgroup: Fix compilation issue due to cgroup_mutex not being exported
Date: Mon,  2 Jun 2025 15:44:48 +0200
Message-ID: <20250602134320.241816377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gaoxu <gaoxu2@honor.com>

[ Upstream commit 87c259a7a359e73e6c52c68fcbec79988999b4e6 ]

When adding folio_memcg function call in the zram module for
Android16-6.12, the following error occurs during compilation:
ERROR: modpost: "cgroup_mutex" [../soc-repo/zram.ko] undefined!

This error is caused by the indirect call to lockdep_is_held(&cgroup_mutex)
within folio_memcg. The export setting for cgroup_mutex is controlled by
the CONFIG_PROVE_RCU macro. If CONFIG_LOCKDEP is enabled while
CONFIG_PROVE_RCU is not, this compilation error will occur.

To resolve this issue, add a parallel macro CONFIG_LOCKDEP control to
ensure cgroup_mutex is properly exported when needed.

Signed-off-by: gao xu <gaoxu2@honor.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 6e54f0daebeff..7997c8021b62f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -90,7 +90,7 @@
 DEFINE_MUTEX(cgroup_mutex);
 DEFINE_SPINLOCK(css_set_lock);
 
-#ifdef CONFIG_PROVE_RCU
+#if (defined CONFIG_PROVE_RCU || defined CONFIG_LOCKDEP)
 EXPORT_SYMBOL_GPL(cgroup_mutex);
 EXPORT_SYMBOL_GPL(css_set_lock);
 #endif
-- 
2.39.5



